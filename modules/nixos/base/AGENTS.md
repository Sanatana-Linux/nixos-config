<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-07-04 -->

# modules/nixos/base/

## Purpose
Core NixOS system configuration — nix daemon settings, FHS compatibility, essential services, permitted package set, shell environment, and system environment variables.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports base submodules (includes zsh enable, shells, pathsToLink, defaultUserShell) |
| `nix.nix` | Nix daemon config (flakes, nix-command, substituters, auto-optimise) |
| `fhs.nix` | FHS compatibility environment (nix-ld) for running non-Nix binaries |
| `services.nix` | Essential system services (dbus, gvfs, polkit, etc.) |
| `permitted-packages.nix` | Packages allowed for unprivileged users via doas/sudo |
| `shell.nix` | Shell environment (ZSH config, default shell selection) — formerly in `shell/` |
| `variables.nix` | System environment variables (browser, Java/OpenGL/ZSH optimizations) — formerly in `shell/` |
| `fonts.nix` | Font packages (Nerd Fonts, icon fonts, system fonts) and fontconfig settings |
| `permitted-packages.nix` | Packages allowed for unprivileged users via doas/sudo |

## For AI Agents

### Working In This Directory
- `nix.nix` enables experimental features (flakes, nix-command) — required for this flake
- `fhs.nix` provides nix-ld for running downloaded binaries without patchelf
- These modules are typically enabled on all hosts

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->