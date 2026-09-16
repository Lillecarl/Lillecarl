---
title: "ghanix (GitHub Actions workflows as NixOS modules)"
date: 2026-09-16
description: "ghanix: write GitHub Actions workflows as NixOS modules and get back plain values. Why YAML was the last thing left, what the module system buys, and what it deliberately does not."
hidden: false
authorship: "vibed"
---

This site's deploy workflow used to be the usual thing: a step to wget a Hugo .deb, a step to build, a step to upload. Earlier this year I got tired of it and moved the whole build into Nix — the flake holds the site package and the spell check, and the YAML job shrank to installing Nix and running two `nix build` calls. All the logic lives where it can be tested; the YAML is a shell.

That left exactly one piece of YAML worth complaining about: the workflow file itself. So I wrote [ghanix](https://github.com/lillecarl/ghanix) — write GitHub Actions workflows as NixOS modules, and get back plain values that a caller turns into YAML.

## Why Bother?

Because a workflow is configuration of exactly the kind the module system already solves, and GitHub Actions' answer to composition is copy-paste. The workflow I actually want to write looks like this:

```nix
ghalib.evalWorkflow {
  name = "On commit";
  on.push = { };
  jobs.build.steps = [
    (ghalib.steps.checkout { })
    (ghalib.steps.installNix { })
  ];
}
```

`evalWorkflow` runs the attrset through `lib.evalModules` against a schema of the workflow, job and step shapes, then strips nulls. A declared key gets a type, a default and a description. And the result is *values*, not text — which means a job is code: one definition shared by two variants, a step list built by a function, a timeout computed once instead of pasted into four places where it will drift.

## What it does not give you

Being a spell-checker. The workflow level is closed — a key it does not know is an evaluation error — but jobs and steps are deliberately freeform, so GitHub can grow a key and nothing here has to be taught it. The cost is that a typo passes:

```nix
jobs.a.steps = [ { run = "true"; tiemout-minutes = 5; } ];
# renders "tiemout-minutes": 5, and GitHub ignores it
```

Note the irony on a site whose CI now runs [typos](https://github.com/crate-ci/typos) at build time. The point is: the schema is there to give the common keys a type and a sane default, not to police the rest. What ghanix buys is that the workflow is code. What it does not buy is that you spelled it right.

## The job preamble

The steps at the front of every job are the same in every repository, and writing them out is how they drift. So a job can ask for them by name:

```nix
jobs.test = {
  ghanix = {
    checkout.enable = true;
    nix.install = {
      enable = true;
      settings.trusted-users = [ "root" "runner" ];
    };
    nix.cachix.enable = true;
    userNamespaces.enable = true;   # the Nix sandbox, and passt
    freeDiskSpace.enable = true;
  };
  steps = [ { run = "nix build --file . thing"; } ];
};
```

Each contributes to `steps` through `mkOrder`, below the 1000 a plain list definition gets, so they come first and in a fixed order: checkout, room on the disk, Nix, cachix, then the runner's own permissions. Everything the job wrote for itself follows.

The `nix.install.settings` trick is my favorite: it is an attrset of nix.conf keys, where a list joins on spaces. That lets a project with a cache of its own drop the composite action it would otherwise carry around — and a composite action cannot hold `timeout-minutes` at all, which is the kind of thing you learn by losing twenty minutes to it.

Every step constructor also carries a default `timeout-minutes`, generous against the measured time — the cap is there to catch a step that *stopped*, not a step that is slow.

## Rendering is the caller's job

`evalWorkflow` returns an attrset and the caller writes the file. That is not laziness; it is that my two consumers disagree about how. nanopynix renders through its own `to_yaml` because it wants the key order, and a pytest gate compares the result against the checked-in YAML. nixkube writes with `pkgs.formats.yaml`, runs yamlfmt, and ends CI in `git diff --exit-code`. Both gates compare *values*, so style never fails a build.

(YAML is a superset of JSON, so `builtins.toJSON` into a `.yml` file is also a valid workflow and needs no builder at all. It is unreadable in a diff, which is usually the reason not to.)

## Takes lib and nothing else

The constraint that makes it a project instead of a directory: `lib` from nixpkgs — for `evalModules`, `types` and `asserts` — and nothing else. No flake, no store path, no nixpkgs source. A repository that pins its own nixpkgs, or none, can still import it.

ghanix grew inside nanopynix, which is still its first consumer. The header there used to say the split "would let this directory be lifted into its own project unchanged". It was, and it was: three files moved without an edit to any of them. That is the kind of sentence I want more of in my repos.

## Try it

Source at [github.com/lillecarl/ghanix](https://github.com/lillecarl/ghanix), with the honest caveat from its own CV entry: good, but not even half-finished. The step library covers what my repositories needed; yours will want more. If writing a workflow as a module system configuration sounds like your kind of Tuesday, it is usable today — and if it sounds like heresy, the YAML was always this shape, ghanix just makes you look at it.
