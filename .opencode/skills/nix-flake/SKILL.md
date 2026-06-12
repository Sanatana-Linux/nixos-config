---
name: nix-flake
description: Manage, update, and troubleshoot the Nix flake — inputs, outputs, overlays, and templates
level: 1
---

# Nix Flake — ShizNix

Manage the project's Nix flake configuration.

## Flake Structure

```
flake.nix
├── inputs (16)
│   ├── nixpkgs (unstable)
│   ├── stable (nixos-25.05)
│   ├── home-manager
│   ├── stylix
│   ├── nixos-hardware
│   ├── sops-nix
│   ├── cachy-tweaks (BORE scheduler)
│   └── ... (9 more)
├── outputs
│   ├── nixosConfigurations (4 hosts)
│   ├── templates (42 templates)
│   ├── packages
│   └── overlays
├── overlays/
└── pkgs/
```

## Commands

| Command | Description |
|---------|-------------|
| `nix flake update` | Update ALL inputs to latest |
| `nix flake lock --update-input <name>` | Update a specific input |
| `nix flake check` | Validate flake integrity |
| `nix flake show` | List all flake outputs |

## Input Management

| Input | Purpose | Update Frequency |
|-------|---------|-----------------|
| nixpkgs | Main package set (unstable) | Weekly |
| stable | Pinned stable packages (25.05) | Monthly |
| home-manager | User env mgmt | Weekly |
| stylix | Theming | Monthly |
| nixos-hardware | HW modules | Monthly |
| sops-nix | Secrets | As needed |
| rust-overlay | Rust toolchain | Weekly |
| cachy-tweaks | BORE scheduler | Monthly |

## Common Issues

| Issue | Resolution |
|-------|------------|
| Package not found | May be in `stable` not `nixpkgs` — check `pkgsStable` |
| Build failed in nixpkgs | Update nixpkgs with `nix flake lock --update-input nixpkgs` |
| Conflicting package versions | Use `overlays/` or `pkgs/` to pin specific versions |
| Hash mismatch on inputs | Try `nix flake update <input>` to refresh the lock |