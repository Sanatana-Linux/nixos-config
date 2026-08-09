---
name: nix-ecosystem-guide
description: Foundational Nix ecosystem guide — declarative philosophy, flake anatomy, module system, priority control, package customization, and common gotchas — adapted to the ShizNix flake. From aeshakhzod/nixos-and-flakes-skill. Use for general Nix/NixOS/Flakes/Home-Manager conceptual guidance.
tags: [nix, nixos, flakes, home-manager, concepts, philosophy]
license: MIT
---

# Nix Ecosystem Guide

## Core Philosophy

1. **Declarative over Imperative** — describe desired state, not steps to reach it.
2. **Reproducibility** — `flake.lock` pins exact versions.
3. **Immutability** — Nix Store is read-only; same inputs = same outputs.
4. **Rollback** — every generation preserved; instant recovery via boot menu.

## Flake Structure (ShizNix)

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # CRITICAL: avoid duplicate nixpkgs
    };
    stylix.url = "github:danth/stylix";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.bagalamukhi = nixpkgs.lib.nixosSystem {
      modules = [ ./hosts/bagalamukhi/default.nix ./modules/nixos ];
      specialArgs = { inherit inputs; };
    };
  };
}
```

## Essential Patterns

### Input Management
```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  stable.url = "github:NixOS/nixpkgs/nixos-26.05";
  # Use parent's nixpkgs to avoid duplicate downloads
  home-manager.inputs.nixpkgs.follows = "nixpkgs";
};
```

### Module System (ShizNix enable-by-option)
```nix
{ config, lib, pkgs, ... }:
with lib; let cfg = config.modules.<category>.<name>; in {
  options.modules.<category>.<name> = {
    enable = mkEnableOption "description";
  };
  config = mkIf cfg.enable { /* conditional configuration */ };
}
```

### Priority Control
```nix
{
  services.nginx.enable = lib.mkDefault true;  # base module default (prio 1000)
  services.nginx.enable = true;                # normal config (prio 100)
  services.nginx.enable = lib.mkForce false;   # override everything (prio 50)
}
```

### Package Customization
```nix
{
  # Override function arguments
  pkgs.fcitx5-rime.override { rimeDataPkgs = [ ./custom-rime ]; }
  # Override derivation attributes
  pkgs.hello.overrideAttrs (old: { doCheck = false; })
  # Overlays (global, in this repo's overlays/)
  nixpkgs.overlays = [ (final: prev: { myPackage = prev.myPackage.override { }; }) ];
}
```

## Commands Reference (ShizNix)

| Task | Command |
|------|---------|
| Rebuild NixOS (host) | `sudo nixos-rebuild switch --flake .#<host> --impure` |
| Test build (safe) | `nixos-rebuild build --flake .#bhairavi` |
| VM test | `nixos-rebuild vm --flake .#bhairavi` |
| Dev shell | `nix develop` |
| Temp package | `nix shell nixpkgs#<package>` |
| Update all inputs | `nix flake update` |
| Update one input | `nix flake lock --update-input <name>` |
| GC old generations | `sudo nix-collect-garbage -d` |
| Debug build | `nixos-rebuild switch --show-trace -L -v` |

## Common Gotchas (ShizNix-specific)

1. **Untracked files ignored** — `git add` before any flake command.
2. **`pkgs.system` deprecated** — use `pkgs.stdenv.hostPlatform.system`. See `.opencode/rules/nix-pkgs-system-deprecation.md`.
3. **Duplicate input downloads** — use `follows`.
4. **Downloaded binaries fail** — use FHS/nix-ld (this repo has nix-ld configured).
5. **Merge conflicts in lists** — use `lib.mkBefore`/`lib.mkAfter`.
6. **sops absolute path breaks pure eval** — use `--impure` for rebuilds.

## Related Skills

- **nix-best-practices** — flake/overlay/unfree
- **ultimate-nixos** — deeper ecosystem
- **nixos-btw** — administration
- **nixos-module** — module authoring
