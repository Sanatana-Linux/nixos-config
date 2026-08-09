---
name: nix-best-practices
description: Best practices for the ShizNix flake — flake.nix structure, input `follows`, overlay application, unfree package handling, and dev-shell patterns. Adapted from 0xbigboss/claude-code. Use when editing flake.nix, adding inputs, applying overlays, enabling unfree packages, or creating dev shells.
tags: [nix, flakes, overlays, unfree, devshell, follows]
license: MIT
---

# Nix Best Practices (ShizNix)

## Flake Structure

ShizNix uses a unified multi-host flake. `flake.nix` defines inputs + `nixosConfigurations` for all hosts. Key inputs include nixpkgs (unstable), stable (26.05), home-manager, stylix, sops-nix, nixos-hardware, nix-cachyos-kernel.

## Follows Pattern (Avoid Duplicate Nixpkgs)

When adding overlay/input deps, use `follows` to share the parent nixpkgs and avoid multiple nixpkgs downloads:

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  # Overlay follows parent nixpkgs
  some-overlay.url = "github:owner/some-overlay";
  some-overlay.inputs.nixpkgs.follows = "nixpkgs";
};
```

All inputs must appear in the `outputs` function arguments (or `...`).

## Applying Overlays (ShizNix)

Overlays live in `overlays/` (additions, modifications, cachyos-patches, stable-packages) and are wired in `flake.nix` via `nixpkgs.overlays`. They follow the `final: prev: { ... }` scope — never mutate `pkgs` in place.

- **New packages** → add to `pkgs/<name>/default.nix`, register in the `additions` overlay.
- **Patching existing packages** → add an override in the `modifications` overlay.

```nix
# overlays/default.nix — additions overlay fragment
additions = final: prev: {
  my-package = final.callPackage ../pkgs/my-package { };
};

# modifications overlay — override existing
modifications = final: prev: {
  some-pkg = prev.some-pkg.override { enableFeature = true; };
};
```

## Handling Unfree Packages (ShizNix)

This repo uses `nixpkgs.config.allowUnfree = true;` (set in `modules/nixos/base/permitted-packages.nix` and hardware modules) plus `allowUnfreePredicate` where scoping is needed (see `modules/nixos/hardware/nvidia.nix`).

- Do NOT default to `NIXPKGS_ALLOW_UNFREE=1` as a permanent answer.
- For insecure packages, add to `permittedInsecurePackages` (see `modules/nixos/base/permitted-packages.nix`).

## Deprecation: `pkgs.system`

Never use `pkgs.system` — it's deprecated. Use `pkgs.stdenv.hostPlatform.system`. See `.opencode/rules/nix-pkgs-system-deprecation.md`.

```nix
# ❌
inputs.foo.packages.${pkgs.system}.default
# ✅
inputs.foo.packages.${pkgs.stdenv.hostPlatform.system}.default
```

## Dev Shells (this repo's `nix develop`)

```nix
# flake.nix devShells
devShells.${system}.default = pkgs.mkShell {
  packages = with pkgs; [ alejandra ... ];
  shellHook = ''echo "ShizNix dev env ready"'';  # alejandra is the formatter
};
```

For C-library native deps, expose headers via `C_INCLUDE_PATH`/`LIBRARY_PATH`/`PKG_CONFIG_PATH` in `shellHook`.

## Common Commands

```bash
# Update all inputs
nix flake update

# Update a single input
nix flake lock --update-input stylix

# Check flake validity
nix flake check

# Enter dev shell
nix develop
```

## Troubleshooting

- **Untracked file** → `git add <file>` before any flake command. Flakes only see tracked files.
- **`config.allowUnfree` doesn't reach `nix develop`** → this repo sets it via `nixpkgs.config`, not `nix develop --impure`; for ad-hoc use `NIXPKGS_ALLOW_UNFREE=1 nix develop --impure`.
- **Overlay not applied** → verify it's in the `overlays` list wired in `flake.nix` (or `nixpkgs.overlays`), and that the host actually enables the module that uses it.

## Related Skills

- **ultimate-nixos** — deeper ecosystem reasoning
- **nixos-best-practices** — overlay scope / useGlobalPkgs
- **nix-flake-ops** — flake input maintenance
