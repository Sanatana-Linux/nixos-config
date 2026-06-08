# Ingested Nix Learning Resources — 2026-05-17

## Summary

14 URLs ingested into `.opencode/context/research/nix-guides/` covering Nix flakes, NixOS configuration, and the Nix expression language from multiple authoritative sources.

## Sources & Topics

| URL | Author/Org | Topic |
|-----|-----------|-------|
| garnix.io/blog/converting-to-flakes | Julian K. Arni (garnix) | Converting legacy Nix projects to flakes |
| ianthehenry.com/posts/how-to-learn-nix/ | Ian Henry | Comprehensive Nix learning series (TOC only — 49 parts) |
| serokell.io/blog/practical-nix-flakes | Alexander Bantyev (Serokell) | Practical flake usage, packaging Haskell/Rust/Python |
| xeiaso.net/blog/nix-flakes-1-2022-02-21 | Xe Iaso | Blocked by Anubis anti-bot |
| xeiaso.net/blog/nix-flakes-2-2022-02-27 | Xe Iaso | Blocked by Anubis anti-bot |
| tweag.io/blog/2020-05-25-flakes | Eelco Dolstra (Tweag) | Flakes Part 1: Introduction & tutorial |
| tweag.io/blog/2020-06-25-eval-cache | Eelco Dolstra (Tweag) | Flakes Part 2: Evaluation caching |
| tweag.io/blog/2020-07-31-nixos-flakes | Eelco Dolstra (Tweag) | Flakes Part 3: Managing NixOS systems |
| nixos.org/guides/nix-pills/ | Luca Bruno (NixOS) | Nix Pills preface (full TOC) |
| nixos.wiki/wiki/Flakes | NixOS Wiki Community | Complete flake reference (schema, NixOS usage, tips) |
| nixos.org/learn.html | NixOS Foundation | Central learning portal with manual links |
| ianthehenry.com/posts/how-to-learn-nix/introduction/ | Ian Henry | Part 1: What's all this about? (series intro) |
| github.com/mikeroyal/NixOS-Guide | Mike Royal | Comprehensive NixOS desktop setup guide (TOC) |

## Key Takeaways

### Tweag Flakes Series (Eelco Dolstra, 2020)
Three canonical blog posts from the creator of Nix:
- **Part 1**: Why flakes exist (reproducibility, composability, discoverability), basic usage, writing first flake, lock files
- **Part 2**: Evaluation caching — SQLite cache at `~/.cache/nix/eval-cache-v1/`, hermetic evaluation enables safe caching, future: precomputed caches on `cache.nixos.org`
- **Part 3**: NixOS configs as flakes — `nixosConfigurations` output, `nixos-rebuild --flake`, system.configurationRevision for traceability, third-party modules (hydra example)

### Garnix Guide (Julian K. Arni, 2022)
Practical guide for converting existing Nix projects to flakes:
- Minimal change approach: keep `default.nix` working, add `flake.nix` alongside
- Must `git add flake.nix` before building (flakes only see git-tracked files)
- The `#pkg` vs `#packages.<system>.pkg` shorthand confusion

### Serokell Guide (Alexander Bantyev, 2021)
Practical application-focused:
- Haskell with cabal2nix, Rust with crate2nix, Python with poetry2nix
- flake-utils for multi-platform boilerplate reduction
- `nix develop`, `nix shell`, `nix profile` as replacements for legacy commands

### NixOS Wiki Flakes Page
The living reference:
- Full output schema documented (checks, packages, apps, devShells, nixosConfigurations, templates, etc.)
- Multiple-channel setup pattern (stable + unstable nixpkgs)
- `nix.registry` pinning pattern
- nix-direnv integration for fast shell switching
- Importing from PRs: `nix build github:nixos/nixpkgs?ref=pull/<PR>/head#<package>`

### How to Learn Nix (Ian Henry, 2021-2024)
49-part series structured as a first-person journey through the manuals:
- Starts from absolute beginner confusion
- Structured as: Nix manual walkthrough → Nixpkgs manual walkthrough → Nix Pills → Real-world usage → Flakes migration
- Notable finding: "disconnect between what you want to do and how Nix actually does it"

### Mike Royal NixOS Guide
Reference-style guide covering:
- Desktop setup, gaming (Steam, Proton, Lutris), development environments
- Extensive tool/module catalog (Hydra, Home Manager, Disko, Colmena, deploy-rs, etc.)
- Language-specific packaging guides
