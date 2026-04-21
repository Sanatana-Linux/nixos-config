<!-- Generated: 2026-04-20 | Project: nixos-configuration -->

# NixOS Configuration - Project Instructions

## Overview

Multi-host NixOS flake configuration managing four machines: bagalamukhi, bhairavi, matangi, and chhinamasta (live ISO). Uses home-manager for user-level configuration with a modular enable-by-option architecture.

## Technology Stack

- **Language**: Nix
- **Framework**: NixOS + Home Manager
- **Package Manager**: Nix Flakes
- **Build System**: `nixos-rebuild switch --flake .#<host>`

## Host Overview

| Host | User | Purpose |
|------|------|---------|
| bagalamukhi | tlh | Lenovo Legion 5 Pro (primary) |
| bhairavi | tlh | VM / secondary |
| matangi | smg | Sara's Lenovo Legion Pro |
| chhinamasta | user | Live USB ISO |

## Build Commands

| Command | Description |
|---------|-------------|
| `sudo nixos-rebuild switch --flake .#bagalamukhi` | Build and switch bagalamukhi |
| `sudo nixos-rebuild switch --flake .#bhairavi` | Build and switch bhairavi |
| `sudo nixos-rebuild switch --flake .#matangi` | Build and switch matangi |
| `nixos-rebuild build --flake .#chhinamasta` | Build live ISO |
| `nix fmt` | Format with alejandra |
| `nix flake check` | Validate flake |

## Project Structure

```
/etc/nixos/
├── flake.nix              # Flake entry: hosts, home-manager, overlays
├── flake.lock             # Pinned dependencies
├── hosts/                 # Per-host configuration
│   ├── bagalamukhi/       # Primary laptop
│   ├── bhairavi/          # VM
│   ├── matangi/           # Sara's laptop
│   └── chhinamasta/       # Live ISO
├── modules/
│   ├── nixos/             # NixOS modules (enable-by-option)
│   │   ├── desktop/       # AWesomeWM, LightDM, XFCE
│   │   ├── hardware/      # NVIDIA, Intel, Bluetooth, etc.
│   │   ├── packages/      # System package sets
│   │   ├── security/      # Doas, sudo, firewall, SSH
│   │   └── users/         # User account modules (tlh, smg, user)
│   └── home-manager/      # Home-manager shared modules
│       ├── desktop/        # GTK, cursor theme
│       ├── programs/       # Firefox, kitty, neovim, etc.
│       ├── services/       # picom, xscreensaver
│       └── shell/          # zsh, starship, xdg, scripts
├── home/                  # Per-user home-manager configs
│   ├── tlh/
│   ├── smg/
│   └── user/
├── pkgs/                  # Custom package definitions
├── overlays/              # Nixpkgs overlays
├── external/              # Git submodules (nvim, firefox, awesome)
└── templates/             # Flake templates
```

## Module Convention

All modules use the **enable-by-option** pattern:

```nix
{
  options.modules.<category>.<name>.enable = mkEnableOption "...";
  config = mkIf config.modules.<category>.<name>.enable { ... };
}
```

User modules additionally declare `home-manager.users.<user>` inside the `mkIf` block to avoid evaluating home-manager options for users not present on a given host.

## Code Style

- Format with `alejandra` (`nix fmt`)
- No comments unless explicitly requested
- Use `with lib;` sparingly; prefer explicit `lib.` prefix
- Module options use `mkEnableOption` and `mkOption` with descriptions
- Config blocks guarded by `mkIf cfg.enable`
- Use `mkForce` sparingly; prefer `mkDefault` / `mkOption` defaults

## Important Rules

- **Never import user modules globally** — only import them on hosts that need them (avoids home-manager stateVersion errors for absent users)
- **Never reference `home-manager.users.<user>` for users not on the current host** — this triggers evaluation errors
- **Always `git add` new files** before building with flakes — Nix only sees git-tracked files
- **Home-manager stateVersion** must be set in every user's `home/` config
- **User modules** are imported per-host, not via a shared `default.nix`

## Git Workflow

- Feature branches: `feature/...`
- Fix branches: `fix/...`
- Conventional commits where possible

<!-- MANUAL: Add custom instructions below this line -->