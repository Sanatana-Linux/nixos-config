---
name: nixos-module
description: Create and manage NixOS modules following the enable-by-option pattern used in ShizNix. Use when adding new system functionality, refactoring existing modules, or creating home-manager modules. Covers module structure, option declarations, mkIf guards, Stylix integration, and cross-module dependencies.
tags: [nix, nixos, module, configuration]
---

# NixOS Module Skill

Create and manage NixOS and home-manager modules following the ShizNix enable-by-option pattern.

## When to Use

- Adding a new system-level feature (new NixOS module)
- Adding a new user-level feature (new home-manager module)
- Refactoring an existing module to follow the enable-by-option pattern
- Adding Stylix theming support to a module
- Creating cross-module dependencies or option references

## Module Pattern

### NixOS Module Structure

Every NixOS module in `modules/nixos/` follows this structure:

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.<category>.<name>;
in {
  options.modules.<category>.<name> = {
    enable = lib.mkEnableOption "<description of what this enables>";
    # Additional options...
  };

  config = lib.mkIf cfg.enable {
    # Implementation...
  };
}
```

### Home-Manager Module Structure

Every home-manager module in `modules/home-manager/` follows:

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.<category>.<name>;
in {
  options.modules.<category>.<name> = {
    enable = lib.mkEnableOption "<description>";
  };

  config = lib.mkIf cfg.enable {
    # home-manager config...
  };
}
```

### Category Placement

| Category | NixOS Path | Home-Manager Path |
|----------|-----------|-------------------|
| base | `modules/nixos/base/` | `modules/home-manager/core/` |
| hardware | `modules/nixos/hardware/` | — |
| system | `modules/nixos/system/` | — |
| stylix | `modules/nixos/stylix/` | `modules/home-manager/stylix/` |
| virtualization | `modules/nixos/virtualization/` | — |
| desktop | — | `modules/home-manager/desktop/` |
| programs | — | `modules/home-manager/programs/` |
| services | — | `modules/home-manager/services/` |
| shell | — | `modules/home-manager/shell/` |
| packages | — | `modules/home-manager/packages/` |

### Registration

After creating a new module file, register it in the category's `default.nix`:

```nix
# modules/nixos/<category>/default.nix
{
  imports = [
    ./existing-module.nix
    ./new-module.nix  # Add here
  ];
}
```

Then `git add` the new file — Nix flakes only see tracked files.

## Stylix Integration

When a module supports theming, integrate with Stylix:

```nix
config = lib.mkIf cfg.enable {
  # Use Stylix colors
  programs.kitty.settings = {
    background = config.stylix.base16Scheme.base00;
    foreground = config.stylix.base16Scheme.base05;
    # etc.
  };
};
```

Available Stylix color variables: `base00`-`base0F`, `base00Hex`-`base0FHex`, plus `cursor`, `cursorText`, `border`.

## Cross-Module Dependencies

When a module depends on another module being enabled:

```nix
config = lib.mkIf cfg.enable {
  assertions = [{
    assertion = config.modules.<other>.<module>.enable;
    message = "<this module> requires <other module> to be enabled";
  }];
};
```

## Verification

After creating or modifying a module:

1. Format: `alejandra <file>` or use the `nix-format` tool
2. Build test: `nixos-rebuild build --flake .#bhairavi` or use the `nix-build` tool
3. Check eval: `nix flake check` or use the `nix-flake` tool
4. `git add` the new file before building
