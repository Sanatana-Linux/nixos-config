---
name: nix-flake-ops
description: Manage Nix flake operations — update inputs, lock flake, check evaluation, and maintain flake.nix. Use when updating flake dependencies, troubleshooting lock conflicts, adding/removing inputs, or running flake checks. Integrates with the nix-flake and nix-build tools.
tags: [nix, flake, lock, inputs, maintenance]
---

# Nix Flake Operations Skill

Manage the ShizNix flake — inputs, lockfile, evaluation checks, and flake.nix maintenance.

## When to Use

- Updating all flake inputs (`nix flake update`)
- Updating a single input (`nix flake lock --update-input <name>`)
- Adding a new flake input to `flake.nix`
- Removing or replacing a flake input
- Running flake evaluation checks
- Troubleshooting lockfile conflicts or hash mismatches
- After a `flake.lock` update that breaks evaluation

## Flake Inputs Reference

The ShizNix flake has 16 inputs. Key ones:

| Input | Type | Purpose | Update Cadence |
|-------|------|---------|----------------|
| `nixpkgs` | Primary | Main package set (nixos-unstable) | Weekly |
| `stable` | Stable pin | nixos-25.05 for pinned packages | Monthly |
| `home-manager` | User env | Home-manager module | Weekly |
| `stylix` | Theming | System-wide theming | Monthly |
| `sops-nix` | Secrets | Encrypted secrets | As needed |
| `nixos-hardware` | Hardware | Lenovo Legion modules | Monthly |
| `nur` | User repo | Nix User Repository | Monthly |
| `nix-cachyos-kernel` | Kernel | CachyOS kernel patches | Monthly |

## Workflow

### Update All Inputs

```bash
nix flake update
```

Then run checks:
```bash
nix flake check
nixos-rebuild build --flake .#bhairavi
```

### Update a Single Input

```bash
nix flake lock --update-input stylix
```

### Add a New Input

1. Add to `flake.nix` inputs block:
```nix
inputs = {
  # existing inputs...
  new-input = {
    url = "github:owner/repo";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

2. Add to `outputs` function arguments
3. Pass to host configs as needed
4. `git add flake.nix` then `nix flake lock`

### Remove an Input

1. Remove from `flake.nix` inputs block
2. Remove from `outputs` function arguments
3. Remove from host configs
4. Run `nix flake lock` to regenerate lockfile

## Troubleshooting

### Hash Mismatch / Integrity Error

```bash
nix flake lock --regenerate
```

### Input Follows Broken

If an input's `follows` chain is broken, check the input's own `flake.nix` for the expected input name.

### Evaluation Error After Update

1. Check which input caused the break: `nix flake metadata`
2. Pin the problematic input to a known-good revision:
```bash
nix flake lock --update-input <name> --override-input <name> github:owner/repo/<known-good-rev>
```
3. Or revert `flake.lock` with git

## Verification

After any flake operation:

1. `nix flake check` — validate flake evaluation
2. `nixos-rebuild build --flake .#bhairavi` — test build
3. `alejandra flake.nix` — format
