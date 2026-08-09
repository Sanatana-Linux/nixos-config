---
name: nixos-ops
description: Operational manual for the ShizNix multi-host NixOS repository — architecture, per-host deployment, testing, rollback, and tooling integration. Adapted from olafkfreund/nixos-ops. Use when deploying to a host, testing a config, understanding repo architecture, or managing the host fleet.
tags: [nixos, ops, deployment, multi-host, architecture, hosts]
license: MIT
---

# NixOS Operations: Architecture, Deployment & Tooling

> **Operator's Manual for the ShizNix Infrastructure**
> Covers operational aspects: architecture, deployment workflows, testing, and tooling.

## Project Architecture

### Flake Structure (`flake.nix`)

Unified multi-host flake:
- **Inputs**: nixpkgs (unstable), stable (26.05), home-manager, stylix, sops-nix, nixos-hardware, nix-cachyos-kernel, etc. (16 inputs).
- **Outputs**: `nixosConfigurations` for all 4 hosts.
- **Overlays**: `overlays/` (additions, modifications, cachyos-patches, stable-packages).
- **Home Manager**: integrated as a NixOS module via `home-manager.nixosModules.home-manager` (not standalone).

### Host Directory Structure

```text
hosts/
├── bagalamukhi/   # Primary laptop — Lenovo Legion 5 Pro, user tlh, NVIDIA PRIME sync, awesome+LightDM, cachyos-bore
├── matangi/       # Sara's laptop — Legion Pro, user smg, XFCE
├── bhairavi/      # VM test host — user tlh, awesome
└── chhinamasta/   # Live USB ISO builder — user user
```

### Module System

Modules organized by category under `modules/nixos/` and `modules/home-manager/`:
- **`hardware/`**: GPU (nvidia, intel), lenovo, bluetooth, keyboard, sound, udev.
- **`system/`**: boot, cron, systemd, networking, apps, desktop, performance, security, users.
- **`base/`**: nix, fhs, services, permitted-packages, shell, variables.

Every module uses the enable-by-option pattern.

## Deployment Workflows

### Local / Host Deployment

```bash
# Safe test on VM host (no live risk)
nixos-rebuild build --flake .#bhairavi

# Dry-run activation
nixos-rebuild dry-activate --flake .#<host>

# Actual switch (primary host)
sudo nixos-rebuild switch --flake .#bagalamukhi --impure
```

The `--impure` flag is required because sops-nix references the absolute path `external/secrets/secrets.yaml`.

### Testing & Validation (always before switching a live host)

```bash
# Flake validity (eval only)
nix flake check --no-build

# Build without switching (ensure it compiles)
nixos-rebuild build --flake .#<host>

# Format check
alejandra --check .
```

### Rollback

NixOS generations are the rollback mechanism:
```bash
# List generations
nix-env --list-generations -p /nix/var/nix/profiles/system

# Roll back to previous generation
sudo nixos-rebuild switch --rollback
# Or reboot and pick an earlier generation from the boot menu
```

## Emergency Recovery

If a host fails to build/switch, roll back to the previous known-good generation before debugging. Do not GC aggressively — the previous generation is your safety net.

## Tooling Reference

| Tool | Purpose | Notes |
|------|---------|-------|
| `nixos-rebuild` | Build/switch/test | `--flake .#<host>`; `--impure` for sops |
| `nix flake` | Input/lock management | `update`, `lock --update-input`, `check`, `metadata` |
| `alejandra` | Nix formatter | `alejandra .` or `alejandra --check .` |
| `nix` (build) | Build outputs | `nix build .#<host>.config.system.build.toplevel` |
| OpenCode `nix-build` tool | Wraps rebuild | actions: build/switch/vm/iso/check/dry-build/dry-activate |
| OpenCode `nix-flake` tool | Wraps flake ops | update/check/lock |
| OpenCode `nix-format` tool | Wraps alejandra | format/check |

## Best Practices for this Repo

1. **Test first**: run `nixos-rebuild build --flake .#bhairavi` (or the target host's build) before `switch`.
2. **Module options**: use the enable-by-option pattern; register modules in category `default.nix`; `git add` new files.
3. **Secrets**: manage via sops-nix; never commit plaintext.
4. **External submodules**: do NOT modify `external/` unless explicitly instructed.
5. **Rollback available**: keep the previous generation; don't GC until the new one boots.
6. **Format**: run `alejandra .` after editing Nix files.

## Related Skills

- **nixos-btw** — general NixOS administration
- **nixos-module** — enable-by-option module authoring
- **nixos-debug** — build/eval failure diagnosis
- **nix-flake-ops** — flake input maintenance
- **nixos-best-practices** — overlay scope
