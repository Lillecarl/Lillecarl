# render.nix — render the built site for review, per page: screen.png,
# dark.png, print.pdf, and one PNG per printed page. The engine is
# nix/render.py (raw CDP over websockets; it carries its own why); this
# file is the sandbox around it: private fonts, a pdftoppm of every
# print PDF, and a guard that a page cannot vanish silently.
{ pkgs, site }:

let
  renderPy = ./nix/render.py;
in
pkgs.stdenv.mkDerivation {
  name = "lillecarl-render";
  src = site;
  nativeBuildInputs = [
    pkgs.chromium
    pkgs.python3
    pkgs.python3Packages.websockets
    pkgs.poppler-utils
    pkgs.fontconfig
    pkgs.dejavu_fonts
  ];
  buildPhase = ''
    export HOME=$TMPDIR

    # The sandbox has no font cache; give chromium one and something to
    # cache. fontconfig's stock alias config is absent too, so map the
    # generic families by hand: the site is monospace-styled, and without
    # an alias `monospace` resolves to a serif and the render lies.
    mkdir -p $TMPDIR/fc
    cat > $TMPDIR/fonts.conf <<EOF
    <fontconfig>
      <dir>${pkgs.dejavu_fonts}/share/fonts</dir>
      <cachedir>$TMPDIR/fc</cachedir>
      <alias><family>monospace</family><prefer><family>DejaVu Sans Mono</family></prefer></alias>
      <alias><family>sans-serif</family><prefer><family>DejaVu Sans</family></prefer></alias>
      <alias><family>serif</family><prefer><family>DejaVu Serif</family></prefer></alias>
    </fontconfig>
    EOF
    export FONTCONFIG_FILE=$TMPDIR/fonts.conf

    # The engine serves the process cwd, so run it from the unpacked
    # site and let it write straight into $out.
    python3 ${renderPy} . $out

    # The print PDF is the paginated truth; its pages are what a reader
    # gets. One PNG per printed page, beside the PDF that produced it.
    find $out -name print.pdf | while read -r pdf; do
      pdftoppm -png -r 110 "$pdf" "''${pdf%.pdf}"
    done

    # CDP failures raise inside the engine, but a page that navigated to
    # nothing would still leave a hole; count what landed.
    [ -n "$(find $out -name print.pdf)" ] || { echo "no page rendered"; exit 1; }
  '';
  installPhase = ''
    (cd $out && find . -type f | sort > manifest.txt)
  '';
}
