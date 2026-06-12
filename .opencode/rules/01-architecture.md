# Architecture Overview

Auto-generated from codebase analysis for the **ShizNix** project.

## High-Level Architecture

NixOS flake configuration with 4 hosts, home-manager as NixOS module, enable-by-option module system, and system-wide Stylix theming.

## Config Layering

```
flake.nix — Entry point, defines 16 inputs and 4 nixosConfigurations
  │
  ├── overlays/ — nixpkgs patches/overrides
  │
  ├── pkgs/ — Custom package derivations (~8)
  │
  ├── hosts/<host>/ — Per-host configuration
  │   ├── default.nix        — Host entry: imports, hostname, stateVersion
  │   └── hardware-configuration.nix  — Auto-generated hardware config
  │
  ├── modules/nixos/ — System-level NixOS modules (15 categories)
  │   ├── hardware/          — lenovo.nix, nvidia.nix, intel-cpu.nix
  │   ├── desktop/           — lightdm.nix, awesome.nix, picom.nix
  │   ├── security/          — firewall.nix, sshd.nix
  │   ├── services/          — Various services
  │   ├── system/            — kernel.nix, boot.nix, nix-settings.nix
  │   ├── users/             — tlh.nix, smg.nix (host-scoped imports)
  │   └── ...
  │
  ├── modules/home-manager/ — User-level modules (7 categories)
  │   ├── programs/          — git.nix, zsh.nix, tmux.nix, yazi.nix
  │   ├── desktop/           — firefox.nix, thunar.nix
  │   ├── development/       — nvim.nix
  │   └── ...
  │
  └── home/<user>/ — Per-user home-manager overrides
      ├── tlh/
      ├── smg/
      └── user/
```

## Key Dependencies

| Input | Version/Pin | Purpose |
|-------|-------------|---------|
| nixpkgs | unstable (26.11pre-git) | Main package set |
| stable | nixos-25.05 | Pinned stable packages |
| home-manager | 0-unstable-2026-06-05 | User environment |
| stylix | latest | System-wide theming |
| nixos-hardware | latest | Hardware modules |
| sops-nix | latest | Secrets management |
| cachy-tweaks | latest | BORE scheduler |
| rust-overlay | latest | Rust toolchain |

## Data Flow

1. **flake.nix** defines `nixosConfigurations` for each host
2. Each host `default.nix` imports shared modules and sets host-specific options
3. NixOS module system evaluates all `options` and `config` recursively
4. `mkIf` guards conditionally include config based on `enable` options
5. Home-manager runs as a NixOS module within the same eval
6. Stylix propagates theme colors/fonts to apps automatically
7. Build output is a Linux kernel + initrd + systemd + NixOS activation script
8. `nixos-rebuild switch` activates the new generation atomically