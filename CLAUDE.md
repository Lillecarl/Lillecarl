# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal website and CV for a DevOps/SRE engineer, built with Hugo. Minimal custom theme with no external dependencies.

## Development Commands

```bash
# Enter dev environment (requires Nix with flakes)
direnv allow  # or: nix-shell

# Local development server
hugo server

# Spell check (typos); runs in CI before deploy
nix build --file . checks

# Build for production
nix build --file . site -o public
```

## Architecture

**Hugo static site** with custom layouts (no external theme):

- `content/` - Markdown content. Blog posts in `content/blog/`, CV at `content/cv.md`
- `layouts/` - HTML templates. Base template with theme toggle in `_default/baseof.html`, CV has its own layout in `cv/single.html`
- `static/style.css` - Single stylesheet with CSS variables for light/dark themes (`--bg`, `--fg`, `--link`, `--code-bg`, `--muted`)
- `hugo.toml` - Site config, menu structure, Goldmark markdown settings

**Theme system:** Uses `prefers-color-scheme` media query with manual override via localStorage. Toggle button in nav.

**Deployment:** GitHub Actions builds and deploys to GitHub Pages on push to main/master. Custom domain: lillecarl.com

## Content Conventions

- Blog posts use `hidden: true` frontmatter to hide from listings while remaining accessible via direct URL
- CV uses inline `<details>` elements for expandable technical details
- CV has embedded `<style>` block for page-specific styling
