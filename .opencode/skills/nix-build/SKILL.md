---
name: nix-build
description: Build, switch, test, and verify NixOS configurations for any of the 4 ShizNix hosts
level: 1
---

# Nix Build — ShizNix

Build and switch NixOS configurations across the 4 hosts.

## Commands

| Command | Description |
|---------|-------------|
| `sudo nixos-rebuild switch --flake .#<host>` | Build and activate permanently |
| `nixos-rebuild test --flake .#<host>` | Build and activate temporarily |
| `nixos-rebuild build --flake .#<host>` | Dry-run build (no activation) |
| `nixos-rebuild vm --flake .#bhairavi` | Build and run in VM (bhairavi only) |
| `nix flake check` | Validate flake (syntax + eval) |
| `alejandra .` | Format all `.nix` files |

## Workflow

1. **Format**: `alejandra .` — always format before building
2. **Validate**: `nix flake check` — catches syntax/eval errors fast
3. **Test** (optional): `nixos-rebuild build --flake .#<host>` — dry run
4. **Deploy**: `sudo nixos-rebuild switch --flake .#<host>`

## Common Issues

| Issue | Resolution |
|-------|------------|
| `file '...' is not in the flake` | New `.nix` file not `git add`-ed |
| `infinite recursion encountered` | Option references itself — check `config` in module |
| `attribute '...' is missing` | Module not imported or typo in option name |
| Build timeout | Reduce parallelism with `--cores 0 -j2` or add to `nix.buildMachines` |
| Systemd ordering cycle | Add `requires` / `after` / `before` to break cycles |