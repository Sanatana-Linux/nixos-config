---
title: "NixOS Configuration Architecture"
type: concept
tags: [architecture, modules, nixos, enable-by-option, flakes]
created: 2026-07-15
updated: 2026-07-15
sources: [.documentation/ARCHITECTURE.md, .documentation/Nix_Modules_Explained_Coherently.md]
status: active
---

# NixOS Configuration Architecture

## Project Structure

```
/etc/nixos/
├── flake.nix               # Flake entry point — 13 inputs, 4 hosts
├── hosts/                  # Host-specific configurations
│   ├── bagalamukhi/       # tlh's Legion 5 Pro (NVIDIA+Intel)
│   ├── matangi/           # smg's Legion Pro (NVIDIA+Intel)
│   ├── bhairavi/          # tlh's VM (modesetting)
│   └── chhinamasta/       # Live USB ISO
├── modules/
│   ├── nixos/             # System-level modules (15 categories)
│   └── home-manager/      # User-level modules (7 categories)
├── overlays/              # Nixpkgs overlays
├── pkgs/                  # Custom package derivations
├── external/              # Git submodules (awesome, nvim, firefox, secrets)
└── templates/             # 42 dev environment flake templates
```

## Enable-by-Option Module Pattern

Every module follows this structure — imported by default but only activates when explicitly enabled:

```nix
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.<category>.<name>;
in {
  options.modules.<category>.<name> = {
    enable = mkEnableOption "description of what this enables";
  };

  config = mkIf cfg.enable {
    # All NixOS options go here
  };
}
```

Unlike "activate-by-import" (where importing a module always enables it), this pattern:
- **Imports everything** — all modules are loaded but inert until enabled
- **Allows modules to compose** — one module can enable or configure another
- **Raises conflicts** — two modules competing over the same option is visible to the user
- **Documents all options** — machine-discoverable via `nixos-option`

### Module Organization

**NixOS modules** (`modules/nixos/`) — 15 categories:
`ai`, `base`, `desktop`, `environment`, `hardware`, `packages`, `performance`, `power`, `printer`, `programs`, `security`, `services`, `shell`, `system`, `users`, `virtualization`

**Home Manager modules** (`modules/home-manager/`) — 7 categories:
`desktop`, `environment`, `packages`, `programs`, `services`, `shell`, `users`

Each category directory contains:
- `default.nix` — imports all modules in that category
- Individual module files (e.g., `nvidia.nix`, `bluetooth.nix`)

### Option Naming

- **Option paths**: `modules.<category>.<name>` — mirrors directory and file structure
- **Config variable**: always `cfg = config.modules.<category>.<name>`
- **File names**: lowercase-kebab-case matching `<name>`
- **Option names**: camelCase for multi-word (e.g., `powerProfilesDaemon`)

## Host Configurations

Each host in `hosts/<name>/default.nix`:
1. Imports all module categories
2. Enables the modules it needs via `modules.<category>.<name>.enable = true`
3. Sets host-specific config (networking, users, packages)

```
Hosts:
  bagalamukhi  — tlh,   Lenovo Legion 5 Pro, NVIDIA+Intel, awesome+LightDM, CachyOS kernel
  matangi      — smg,   Lenovo Legion Pro,   NVIDIA+Intel, xfce,            CachyOS kernel
  bhairavi     — tlh,   VM,                  modesetting,  awesome,          CachyOS kernel
  chhinamasta  — user,  Live USB ISO,        Intel,        awesome,          CachyOS kernel
```

## Home Manager Integration

Home Manager is integrated as a NixOS module (not standalone) via `home-manager.nixosModules.home-manager`. This means `nixos-rebuild switch` applies both system and user configurations in one command.

- **Shell**: ZSH configuration, prompts, aliases
- **Programs**: Neovim, Kitty, GPG, SSH
- **Services**: GnuPG agent, screensaver, picom
- **Desktop**: GTK theme, X11 resources
- **Users**: `tlh`, `smg`, `user` — per-user configs

## Kernel Modules and Parameters

Kernel modules and parameters belong **with the hardware modules that require them**, not in a central location:

```nix
# modules/nixos/hardware/nvidia.nix — owns its kernel modules
config = mkIf cfg.enable {
  boot.initrd.kernelModules = ["nvidia" "nvidia-drm"];
};
```

Use `lib.mkMerge` for conditional configuration across different hardware variants.

## Overlays and Packages

- **`pkgs/`** — New package derivations (e.g., honor-icon-theme, sea-greeter)
- **`overlays/`** — Patches/overrides to existing nixpkgs packages
  - `additions/` — New packages not in nixpkgs
  - `modifications/` — Patched or modified packages  
  - `stable-packages/` — Force versions from the stable channel
  - `nur/` — NUR (Nix User Repository) overlays

## Git Submodules and Out-of-Store Symlinks

External configurations (Neovim, AwesomeWM, Firefox) are managed as git submodules in `external/` and linked to their expected locations via `config.lib.file.mkOutOfStoreSymlink`. This enables live editing without rebuilding:

```nix
xdg.configFile."nvim" = {
  source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/external/nvim;
};
```

**Do not modify files in `external/`** — they are managed in their own repos.

## Stylix Theming

System-wide theming via Stylix (Monokai Pro Spectrum base16) propagates colors and fonts to all supported applications. Avoid duplicating color/font config in individual modules — Stylix handles it.

Available variables: `base00`-`base0F`, `base00Hex`-`base0FHex`, `cursor`, `cursorText`, `border`.

## Quick Reference

```bash
# Build and switch
sudo nixos-rebuild switch --flake .#bagalamukhi

# Test without switching
sudo nixos-rebuild test --flake .#bagalamukhi

# VM test
nixos-rebuild vm --flake .#bhairavi

# Format code
alejandra .

# Update flake
nix flake update
```
