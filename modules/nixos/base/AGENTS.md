<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/nixos/base/

## Purpose
Core NixOS system configuration — nix daemon settings, FHS compatibility, essential services, and permitted package set for unprivileged users.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports base submodules |
| `nix.nix` | Nix daemon config (flakes, nix-command, substituters, auto-optimise) |
| `fhs.nix` | FHS compatibility environment (nix-ld) for running non-Nix binaries |
| `services.nix` | Essential system services (dbus, gvfs, polkit, etc.) |
| `permitted-packages.nix` | Packages allowed for unprivileged users via doas/sudo |

## For AI Agents

### Working In This Directory
- `nix.nix` enables experimental features (flakes, nix-command) — required for this flake
- `fhs.nix` provides nix-ld for running downloaded binaries without patchelf
- These modules are typically enabled on all hosts

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->