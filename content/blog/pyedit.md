---
title: "pyedit (super editing powers for agents)"
date: 2026-09-15
description: "Why I built pyedit: scripted edits for AI agents, staged in memory, merged by git, applied and undone as patches."
hidden: false
---

As promised in the first post: an occasional opinion. This one comes with software.

If you run AI coding agents you have watched the edit-tool saga unfold. First came line-number patching, and line numbers go stale the moment two edits touch the same file. Then search-and-replace, and the model replaces a string in a different file than it meant to. Underneath both sits the same mistake: every edit is a discrete gamble with no receipt. A *complicated* edit — ten files, one refactor — is twenty little gambles, and if gamble twelve is wrong you find out by reading.

Then Anthropic decided the dedicated tools were the problem. Recent Claude Code builds inject a standing instruction while auto mode is active, verbatim from the binary:

> Do your work through the Bash tool wherever it can accomplish the job: read files with cat, head, or sed -n, search with grep and find, and make file changes with sed, heredocs, or short scripts, rather than using the dedicated Read, Edit, or Write tools. Fall back to a dedicated tool only when Bash genuinely cannot do the job.

So Claude started editing files with bare Python, everywhere, all the time. In practice that is a `python3 - <<'PY'` block doing `src.replace(...)` on real code: no diff to review, no failure when the anchor text is wrong, nothing anyone can run again — and per the bug reports, occasionally half a document deleted because a one-liner misfired. The instruction is hardcoded behind an undocumented experiment gate with no setting to turn it off, two changelog entries that had shipped the *opposite* guidance as fixes a few versions earlier never got a reversal entry, and the [issue tracker](https://github.com/anthropics/claude-code/issues/87971) [filled](https://github.com/anthropics/claude-code/issues/89731) [up](https://github.com/anthropics/claude-code/issues/88041).

Now, my own rule file opens with the standard countermeasure: *never rewrite a source file by piping a Python or sed program into the shell*. But somewhere around the fifth Python heredoc of the week it clicked: **if Anthropic thinks bare Python is good enough for editing files, why not make bare Python actually good at editing files?** Not another rule telling the model to stop — a proper library and runner for scripted edits.

So I wrote [pyedit](https://github.com/Lillecarl/pyedit). It gives an agent super editing powers, and the edits stop being gambles.

Full disclosure, since we are being honest: pyedit was built with AI, and the first draft of this post was written by one. I am not even trying to hide it — I am firmly in the "honesty is best" camp. A tool for AI agents, built with AI, announced in an AI-written post: the recursion is the point.

## Why Bother?

pyedit runs a Python edit script. That is the whole interface — everything around the script is the point:

- Every file the script touches lands in an **in-memory overlay**. The first read proxies to disk and caches the whole file; writes stay in memory. Reads see staged content, so read-your-writes holds.
- A run **prints a unified diff and touches nothing**. Disk is written only with `--apply`. The diff is not a prediction of what would happen, it is a rendering of what `--apply` *will* write.
- **Syntax is checked before the diff prints** — tree-sitter where a grammar is installed, `compile()` for Python. Applying known-broken syntax refuses without `--force`.
- Every applied change prints an **undo id** — a reverse patch, rendered before the write. `pyedit apply <id>` un-does the whole run.

The invariant: staged state lives in memory, and one function is the only thing that writes to disk. A dry-run is not a second code path — it is a run that reaches the end without calling apply.

## Many edits, zero line numbers

The part agents actually care about. pyedit allows edits in multiple VFSes, so the model never needs to be concerned with multi-edit line number differences:

```python
pyedit.edit("src/app.py", "def parse(cfg):", "def parse(cfg, strict):")
with pyedit.VFS():
    pyedit.edit("src/app.py", "import json", "import json\nimport os")
```

A `pyedit.VFS()` scope is an independent overlay on top of disk truth. It cannot see the parent's staged state, and sibling scopes cannot see each other. When the scope exits, pyedit merges it with **git's own three-way merge**: disk is the ancestor, the parent is ours, the scope is theirs. Edits in different regions merge clean no matter what line numbers each one was written against; two edits to neighbouring lines belong in one scope, and git says so.

That is the whole trick — **line numbers never enter into it**. A conflict is a `Collision`, never a guess, and nothing is staged before every conflict is known. (Rename detection rides along, like git's: a delete is paired with a similar add so an edit follows the file to its new name. `--no-rename-detection` turns it off.)

## git does the paperwork

Storing and replaying patches is a solved problem, and the solver is libgit2. pyedit runs it entirely in memory — a repository with a mempack object database, no workdir, no index file, no path on disk. It owns every format git invented: hunk rendering, base85 binary payloads, symlinks as mode-120000 blobs.

So pyedit's own patches are git's own, written by libgit2 and applied by libgit2:

- A dry-run wraps its diff in `# pyedit dry-run <id>` comments, and `pyedit apply <id>` applies that stored patch later. Handy when a human wants to review agent output before it lands.
- An applied run's undo id is the reverse patch, written before the write.
- No Python parses a diff anywhere on this path. Line numbers are exact by construction, so nothing needs fuzzy matching.

## Trusting patch confetti

Agents also handle *other people's* patch formats — OpenAI `apply_patch` envelopes, unified diffs from tool output — and what arrives is often patch confetti. libgit2's apply refuses most of it: no `diff --git` line (agents write these constantly), creates without mode headers, zero-hunk sections. So pyedit meets the confetti where it is:

- `pyedit.apply_v4a(text)` — the vendored OpenAI primitive
- `pyedit.apply_diff_git(text)` — libgit2, exact line numbers
- `pyedit.apply_diff_unidiff(text)` — the unidiff library, with hunks anchored by search and a whitespace-insensitive fallback, because an `@@` number from a model is a suggestion, not a promise

Fail closed, always: one hunk that will not anchor fails the whole input and nothing is staged. `--force` downgrades that to per-file skips.

The same spirit runs the semantic layer: rope does Python renames and reference finding in-process, a real language server covers other languages, and tree-sitter serves position queries and outlines — all reading staged content, so the tools agree with the diff.

## Try it

Source and the full manual live at [github.com/Lillecarl/pyedit](https://github.com/Lillecarl/pyedit) — `pyedit skill` prints the whole agent-facing manual as markdown, which is the authoritative usage guide and doubles as a decent architecture lesson.

The pitch: if your agent makes three search-and-replace calls to rename one function, give it pyedit. It writes one script, reads one diff, applies one patch — and if the result is wrong, one id un-does the whole thing.
