<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# modules/home-manager/environment/

## Purpose
Session environment configuration — home-manager session variables, XDG user directories, Nix CLI settings, and environment variables. Split from `shell/` to separate interactive shell config from environment/session config.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports environment submodules |
| `home.nix` | Home-manager session variables |
| `environment.nix` | Environment variables and PATH entries |
| `nix.nix` | Nix CLI configuration for the user |
| `xdg.nix` | XDG user directories and default applications |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| *(none)* | — |

## For AI Agents

### Working In This Directory
- These modules set session-wide defaults — changes may require re-login
- XDG directories must be consistent between home-manager and NixOS-level settings
- `nix.nix` configures the user-level Nix CLI (separate from `modules/nixos/base/nix.nix` which configures the system daemon)

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->