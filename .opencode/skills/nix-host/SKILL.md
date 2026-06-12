---
name: nix-host
description: Manage per-host NixOS configuration — host-specific modules, users, hardware, and deployment
level: 1
---

# Nix Host — ShizNix

Manage per-host NixOS configurations.

## Host Structure

Each host has a `hosts/<host>/default.nix` that defines:

```nix
{ modulesPath, pkgs, lib, inputs, ... }:
{
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    ./hardware-configuration.nix
    ../../modules/nixos/users/tlh.nix  # or smg.nix, user.nix
    inputs.stylix.nixosModules.stylix
    # shared module categories
    ../../modules/nixos/hardware
    ../../modules/nixos/desktop
    # ...
  ];

  # host-specific config
  system.stateVersion = "24.11";
  networking.hostName = "<hostname>";

  # enable host-specific modules
  modules.<category>.<name>.enable = true;
}
```

## Host Matrix

| Host | File | User | GPU | Desktop | Kernel |
|------|------|------|-----|---------|--------|
| bagalamukhi | `hosts/bagalamukhi/default.nix` | tlh | NVIDIA+Intel Prime | awesome | xanmod |
| matangi | `hosts/matangi/default.nix` | smg | NVIDIA+Intel Prime | xfce | xanmod |
| bhairavi | `hosts/bhairavi/default.nix` | tlh | modesetting | awesome | xanmod |
| chhinamasta | `hosts/chhinamasta/default.nix` | user | Intel | awesome | xanmod |

## Principle

- **Shared config** goes in `modules/` — available to all hosts
- **Host-specific** stays in `hosts/<host>/` — overrides via `mkForce` if needed
- **No host imports another host's config** — each is independent
- **hardware-configuration.nix** is auto-generated per host — do not edit

## Adding a New Host

1. Create `hosts/<name>/default.nix` with the template above
2. Generate hardware config: boot installer and run `nixos-generate-config`
3. Copy to: `hosts/<name>/hardware-configuration.nix`
4. Add to `flake.nix` `nixosConfigurations`
5. Test: `nixos-rebuild build --flake .#<name>`