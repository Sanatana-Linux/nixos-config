<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-22 | Updated: 2026-04-22 -->

# packages/

## Purpose
User-level package sets managed through home-manager. Provides essential packages that every user should have (thunderbird, imagemagick, keychain, nodejs, fzf, rofi, etc.) with a Python LSP package built from python314.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports `essential.nix` via imports |
| `essential.nix` | Essential user packages: email, image tools, VCS hooks, Wayland tools, JS runtime, fuzzy finder, launcher, Python LSP |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| *(none)* | — |

## For AI Agents

### Working In This Directory
- `essential.nix` uses `lib.attrValues` with `inherit (pkgs)` pattern for the package list — follow this pattern when adding packages
- The Python LSP (`pylsp`) is a custom `python314.withPackages` derivation, not a direct package
- This is home-manager packages (`home.packages`), not NixOS system packages — they are installed per-user

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->