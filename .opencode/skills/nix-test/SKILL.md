---
name: nix-test
description: Test NixOS configurations — VM testing, flake validation, and configuration checking
level: 1
---

# Nix Test — ShizNix

Test NixOS configurations before activating on production hosts.

## Commands

| Command | Description |
|---------|-------------|
| `nix flake check` | Validate entire flake (fastest) |
| `nixos-rebuild build --flake .#<host>` | Dry-run build |
| `nixos-rebuild test --flake .#<host>` | Activate temporarily (until reboot) |
| `nixos-rebuild vm --flake .#bhairavi` | Boot test in VM (bhairavi only) |
| `nix build -L .#nixosConfigurations.<host>.config.system.build.toplevel` | Build with full logs |

## Test Workflow

1. **Format**: `alejandra .`
2. **Quick check**: `nix flake check`
3. **Build test**: `nixos-rebuild build --flake .#<host>`
4. **VM test** (complex changes): `nixos-rebuild vm --flake .#bhairavi`
5. **Temporary activation** (user-specific): `nixos-rebuild test --flake .#<host>`

## Module-Specific Testing

```bash
# Check options for a specific host
nix eval '.#nixosConfigurations.bagalamukhi.options.modules' --json | head -50

# Check an option value
nix eval '.#nixosConfigurations.bagalamukhi.config.modules.hardware.nvidia.enable'

# List enabled modules for a host
nix eval '.#nixosConfigurations.bagalamukhi.config.modules' --json | jq 'keys'
```

## What to Test

- [ ] `nix flake check` passes with no errors
- [ ] Build succeeds for each modified host: `nixos-rebuild build --flake .#<host>`
- [ ] Module enable/disable toggle works (set `enable = false`, check config disappears)
- [ ] Cross-host changes don't break other hosts
- [ ] Stylix theming works (restart affected apps after switch)