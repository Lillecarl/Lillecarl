---
title: "self-verifying agents: I built a VT multiplexer I don't understand"
date: 2026-10-10
description: "The human job in agentic development isn't knowing the domain, it's building the harness that lets agents verify their own work. Pymux is where that workflow fit like a glove."
hidden: false
authorship: "vibed"
---

cmatrix in a background window pegged a whole core and drew five frames in five seconds. My multiplexer was working harder to show nothing than to show something. That multiplexer is [pymux](https://github.com/Lillecarl/pymux) — Jonathan Slenders' Python tmux, dead since 2017, which I forked and let agents rebuild: 820 commits since January, all agent-written except the prompts. I still can't read VT by sight. `CSI 4:1 m` means nothing to me, and I stayed ignorant on purpose.

This post isn't about pymux. It's about the only agentic workflow I've seen actually work: the human builds the machine that checks the work, the agents do the work. My contribution is test facilities with mechanical verdicts. Pymux just fit that workflow like a glove, because terminal correctness is observable: six other emulators to vote, pixels to subtract, bytecode to count. Where correctness needs taste, agents guess — so the harness never asks them to.

The trick: I never let the agent decide what "correct" means. I made it count shit instead.

## There is no spec, only whatever xterm does

VT "spec" is a polite fiction. The real spec is xterm's mood that day, plus 40 years of programs that depend on its bugs.

Fuck documents. I test against six other terminals that hate each other: **kitty, WezTerm, Alacritty, libvterm, Ghostty, xterm.js**. C, Rust, Zig, TypeScript — different bloodlines, different bugs. Same bytes go into my widget (ptterm draws one terminal, pymux arranges several) and into all six, and the harness compares screens cell by cell.

xterm itself sits in the corner as a seventh oracle. It answers characters but no attributes over DECRQCRA, so it gets to comment but never vote. Fair. It invented the game.

A judge that can't hold something abstains instead of lying. Only libvterm and WezTerm know what SGR 73 even is, so the rest sit that round out. The verdict stays dumb on purpose. Agree means ship it. ptterm-wrong means every voting judge agrees with each other and not with me, so I eat the bug. Split means the judges fight each other, so it's taste, not a bug: write it down, touch nothing. No LLM judgment call anywhere. I just count shit.

The same harness flogs borrowed suites. esctest2 runs from the inside: 5 fails bare, 9 fails in a pane, and that delta is what pymux adds. vttest goes screen by screen. libvterm's own 43 test files get turned around and fired at us (270 assertions). Alacritty's 45 recordings of vim/tmux/fish replay through a real pane into a real `Term` (Alacritty's grid struct). What breaks in a pane but not on a pty is my fault. What breaks in both belongs to the emulator. That split ends hours of pointing fingers.

Price: the panel group needs kitty, Rust, C, node and X. 19 files carry that weight, 17 stay pure Python. A new test lands in the right group by the import it writes, and a unit test that tries to skip fails loud. No silent green.

## Screenshots caught the shit cells couldn't

The model holds cells. Your eyeballs eat pixels. Those two divorce exactly where it hurts: double-size lines, blinking cursors, underlines.

`checks.pymux-pictures` runs the same program twice in the same real terminal — once bare, once inside a fullscreen pymux pane — and subtracts the screenshots. Never cross-compare terminals; every font stack draws different glyphs, so that diff is toilet paper. Bare-vs-pane in the *same* emulator or GTFO.

That's how we caught two ghosts: a cursor that stopped blinking, and an underline that showed up uninvited. Every cell check waved both through.

And sometimes the diff says the *other guy* is the idiot. A pane re-spells `CSI 4:1 m` into `CSI 4 m`. xterm ignores the first and draws the second, so 206 pixels differ. foot reads both forms, pictures identical. Verdict: the difference belongs to xterm, written down in `picture-differences.txt` with the reason. That list gets judged in both directions, so a regression screams and a fix screams too. Same deal for the esctest/vttest/vterm failure lists.

Want a real fixture instead of a hand-made toy? Record your own broken session:

```
ptterm-record --into pymux/tests/recordings --lines 24 --columns 80 \
    claude -- claude
```

Go use the thing, reproduce the fuckup, quit. Now `recorded-claude` replays your actual bytes, bare vs pane. A hand-written fixture only holds what somebody bothered to imagine. This one holds what actually bit you. Read it before you commit it, it holds your screen.

Flaky bit: vttest pictures item 2 still flaps on a fixed-delay change after one screen draw, pure timing flake. It stays non-gating. A flaky gate is worse than no gate.

## Wall-clock lies, so I count bytecode

Agents love making code slower while all tests stay green. Wall-clock can't fail a build — a second belongs to whatever else was running on the box. So I count **bytecode instructions** with `sys.monitoring`. Same code + same bytes + same interpreter = same number, regardless of box load. Carl's law: "number go up = bad."

Budgets live in `*-budgets.txt` next to the tests. Drift >5% either way and you're red. Up means you got slow. Down means you forgot to update the budget, also red. `PYTHONHASHSEED` pinned, Python upgrade means re-record everything. That's the bill, pay it.

Counting found the fat one: every title bar re-measured the whole window, 950k instructions against a 55k frame. We now measure the plan once. The census also found a one-pane layout is 106 nested boxes and 36 of them are chrome (borders, title bars, status fluff) for that single pane ([#366](https://github.com/Lillecarl/pymux/issues/366)). A key press still walks the whole layout to build a cache key that then hits ([#317](https://github.com/Lillecarl/pymux/issues/317)), 33% of the press, growing with every overlay. The fix needs a layout version counter prompt-toolkit doesn't have. So it sits open, with numbers, instead of rotting in someone's head.

Current damage, counted and timed:

```
bare pty:  0.05 ms median
pymux:     3.85 ms median, 7.6 ms p99  (1.1 ms in, 2.7 ms out)
```

Socket vs in-process transport: identical. The socket costs nothing here; the renderer costs everything.

The cmatrix story from the top? `ptyhost` polled for an idle loop that never comes while prompt-toolkit reposted redraws the same way: 40,552 reposts to defer one read a quarter second ([#253](https://github.com/Lillecarl/pymux/issues/253)). After: 19% of a core, 26 frames in 5s instead of 5. Same shape fixed nyancat, pipes, tty-clock. And the "impossible rate" tell: one cold count showed 500M instr/s next to 132M in the same run. Can't happen. We had compared two different piles of work, first-frame paint vs steady-state, merged keybindings vs hot path. Split them and the numbers made sense again.

Big-screen tax, measured not guessed: 80x24 idle 6.9 ms, 342x74 idle 22.2 ms. A frame is ~5.7 ms fixed + 0.65 µs per cell. So `frame-rate 30` (default) stays because uncapped melts cores: uncapped cmatrix eats 93% of a core at 45 fps, capped at 10 it eats 32% at 9.8 fps, typing latency unchanged. That's a window option because a window is what you look at.

## 557 issues and I wrote zero of them

Over 500 issues on the tracker. I filed none. Not one. The rule agents actually follow: file an issue for what you find and do not fix. The issue is how you stay on the task instead of wandering off to stroke shiny crap.

So the tracker reads like a drunk lab journal, and I love it:

[#227](https://github.com/Lillecarl/pymux/issues/227) — every scrollback row allocated a closure just to return one shared cell. 10.7 MB of identical lambdas at 50k rows. Of ~800 bytes a row, 215 was the `Row` and its little hat.

[#426](https://github.com/Lillecarl/pymux/issues/426) — resize on the alternate screen eats a wrapped line. pyte-roaming finds it one run in ten with a two-chunk seed. Fucker hid since before the fork.

[#232](https://github.com/Lillecarl/pymux/issues/232) — 45% of a keystroke was neither work nor socket, just waiting. Instruction counts can't see waiting by construction. So now we count loop turns too.

[#254](https://github.com/Lillecarl/pymux/issues/254) — a frame builds 11,033 cells to emit 437 characters. The diff emits only what changed, but everything before it rebuilds the universe to find out.

437 closed, 120 open as I type this. All in `Lillecarl/pymux`, even the cross-repo ones. If it's not in an issue it doesn't exist, and if your exclusion pattern matches nothing the gate fails — so dead excuses die fast.

## Count votes, diff pixels, budget bytecode

Full disclosure like last time: robots wrote ~all the code, and one wrote the first draft of this post. Recursion is the point.

What actually transferred, in order:

Give the robot a number and it behaves: agree/wrong/split, pixel diffs, instruction deltas. Ask it "is this correct?" and you get vibes back.

Record reality. `ptterm-record` your broken Claude session instead of inventing bytes. Alacritty's vim recordings beat any synthetic corpus. Real programs or it didn't happen.

Keep failure lists bidirectional. Every `*-failures.txt` / `*-budgets.txt` / `picture-differences.txt` fails on regression *and* on silent fix. A fix you didn't notice means your test is blind.

This setup survives because the verdicts are mechanical and the evidence is checked in. I built the checker, not the knowledge: I still can't read VT. I can read a vote, a diff, and a budget. That's the whole fucking job, and I get to stay dumb.

Umbrella with all eight repos and every check: [github.com/Lillecarl/pyterm](https://github.com/Lillecarl/pyterm). The fork: [github.com/Lillecarl/pymux](https://github.com/Lillecarl/pymux). Run `nix build --file . checks.all`, then `checks.pymux-pictures.run` and go look at the pictures — that's the fun one.
