# Render every page of a built Hugo site to AI-reviewable artifacts.
#
# Usage: render.py SITE_DIR OUT_DIR
#
# Pages come from the site's own sitemap.xml. One headless chromium over
# the DevTools protocol writes, per page: screen.png (light, full page),
# dark.png (emulated prefers-color-scheme), and print.pdf (the print
# stylesheet -- the CV's print mode included).
#
# Why raw CDP instead of Playwright or Puppeteer: their browser
# downloads are anti-Nix and their drivers break in build sandboxes.
# chromium plus a websocket client is the whole dependency surface, and
# the two verbs that matter -- captureScreenshot with
# captureBeyondViewport, printToPDF with printBackground -- need no
# framework around them.
#
# Pages are served over localhost, not file://: they link their assets
# root-absolute (/style.css, /cv-photo.png), and under file:// those
# resolve against the filesystem root. The first build of this tree
# rendered every page as a blank page with a broken-image icon.

import base64
import json
import subprocess
import sys
import tempfile
import threading
import time
import xml.etree.ElementTree as ET
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlparse

from websockets.sync.client import connect

WIDTH = 1280
HEIGHT = 800
PORT = 8123


class DevTools:
    def __init__(self, ws_url):
        self.ws = connect(ws_url, max_size=2**25)
        self.next_id = 1
        self.responses = {}
        self.events = []
        self.session = None

    def send(self, method, params=None, session=False):
        msg = {"id": self.next_id, "method": method, "params": params or {}}
        if session and self.session:
            msg["sessionId"] = self.session
        self.next_id += 1
        self.ws.send(json.dumps(msg))
        while True:
            if msg["id"] in self.responses:
                data = self.responses.pop(msg["id"])
                if "error" in data:
                    raise RuntimeError(f"{method}: {data['error']}")
                return data["result"]
            data = json.loads(self.ws.recv())
            if "id" in data:
                self.responses[data["id"]] = data
            else:
                self.events.append(data)

    def wait_event(self, name, timeout=30):
        deadline = time.time() + timeout
        while True:
            for i, event in enumerate(self.events):
                if event.get("method") == name:
                    return self.events.pop(i)
            if time.time() > deadline:
                raise TimeoutError(f"no {name} in {timeout}s")
            data = json.loads(self.ws.recv())
            if "id" in data:
                self.responses[data["id"]] = data
            else:
                self.events.append(data)


def launch_chromium():
    profile = Path(tempfile.mkdtemp(prefix="lillecarl-render-"))
    proc = subprocess.Popen(
        [
            "chromium",
            "--headless=new",
            "--no-sandbox",
            "--disable-gpu",
            "--disable-dev-shm-usage",
            "--no-first-run",
            "--no-default-browser-check",
            "--remote-debugging-port=0",
            f"--user-data-dir={profile}",
            "about:blank",
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    port_file = profile / "DevToolsActivePort"
    for _ in range(300):
        if proc.poll() is not None:
            raise RuntimeError("chromium died on startup")
        if port_file.exists():
            break
        time.sleep(0.1)
    else:
        raise TimeoutError("chromium never wrote DevToolsActivePort")
    port, socket_path = port_file.read_text().split()
    return proc, f"ws://127.0.0.1:{port}{socket_path}"


def pages(site_dir):
    tree = ET.parse(Path(site_dir) / "sitemap.xml")
    for loc in tree.iter():
        if loc.tag.endswith("loc") and loc.text:
            path = urlparse(loc.text).path
            rel = path.strip("/") or "index"
            page = Path(site_dir) / rel
            if (page / "index.html").exists() or page.with_suffix(".html").exists():
                yield rel
            else:
                print(f"skip (no build output): {rel}", file=sys.stderr)


def main():
    site_dir, out_dir = Path(sys.argv[1]), Path(sys.argv[2])
    server = ThreadingHTTPServer(
        ("127.0.0.1", PORT), SimpleHTTPRequestHandler
    )  # serves the process cwd, which is the unpacked site
    threading.Thread(target=server.serve_forever, daemon=True).start()
    proc, ws_url = launch_chromium()
    try:
        dt = DevTools(ws_url)
        target = dt.send("Target.createTarget", {"url": "about:blank"})
        session = dt.send(
            "Target.attachToTarget", {"targetId": target["targetId"], "flatten": True}
        )
        dt.session = session["sessionId"]
        dt.send("Page.enable", session=True)
        dt.send(
            "Emulation.setDeviceMetricsOverride",
            {"width": WIDTH, "height": HEIGHT, "deviceScaleFactor": 1, "mobile": False},
            session=True,
        )

        count = 0
        for rel in pages(site_dir):
            dest = out_dir / rel
            dest.mkdir(parents=True, exist_ok=True)
            dt.send(
                "Page.navigate", {"url": f"http://127.0.0.1:{PORT}/{rel}"}, session=True
            )
            dt.wait_event("Page.loadEventFired")

            for scheme, name in (("light", "screen.png"), ("dark", "dark.png")):
                dt.send(
                    "Emulation.setEmulatedMedia",
                    {"features": [{"name": "prefers-color-scheme", "value": scheme}]},
                    session=True,
                )
                shot = dt.send(
                    "Page.captureScreenshot",
                    {"format": "png", "captureBeyondViewport": True},
                    session=True,
                )
                (dest / name).write_bytes(base64.b64decode(shot["data"]))

            pdf = dt.send(
                "Page.printToPDF",
                {"printBackground": True, "preferCSSPageSize": True},
                session=True,
            )
            (dest / "print.pdf").write_bytes(base64.b64decode(pdf["data"]))
            count += 1
            print(f"rendered {rel}")
        print(f"{count} pages")
    finally:
        proc.terminate()


if __name__ == "__main__":
    main()
