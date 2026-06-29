# Nix Module Patterns

> Enable-by-option module conventions used throughout ShizNix.

## Core Pattern

Every module declares `options.modules.<category>.<name>.enable = mkEnableOption "..."` and guards its `config` block with `lib.mkIf cfg.enable`:

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.<category>.<name>;
in {
  options.modules.<category>.<name> = {
    enable = lib.mkEnableOption "description of what this enables";
    # Additional options...
  };

  config = lib.mkIf cfg.enable {
    # Implementation...
  };
}
```

## Naming

- **Option paths**: `modules.<category>.<name>` — matches directory and file structure
- **Config variable**: always `cfg = config.modules.<category>.<name>`
- **File names**: lowercase-kebab-case matching `<name>` from the option path
- **Option names**: camelCase for multi-word options (e.g., `powerProfilesDaemon`, `cpuBoostOnAc`)

## Registration

After creating a new module file, register it in the category's `default.nix`:

```nix
# modules/nixos/<category>/default.nix
{
  imports = [
    ./existing-module.nix
    ./new-module.nix
  ];
}
```

Then `git add` the new file — Nix flakes only see tracked files.

## Option Types Reference

| Type | Usage | Example |
|------|-------|---------|
| `types.bool` | Enable flags | `default = false;` |
| `types.int` | Numeric values | `default = 75;` |
| `types.str` | String values | `default = "powersave";` |
| `types.enum [a b]` | Fixed choices | `default = "18";` |
| `types.lines` | Multi-line string | for config file contents |
| `types.package` | A package | `default = pkgs.hello;` |
| `types.path` | A filesystem path | |
| `types.attrsOf types.bool` | Attrset of bools | for feature flags |
| `types.listOf types.str` | List of strings | for package lists |
| `types.nullOr types.str` | Optional value | `default = null;` |

## Conditional Config

### Simple enable guard
```nix
config = lib.mkIf cfg.enable { ... };
```

### Conditional sub-features
```nix
config = lib.mkIf cfg.enable {
  services.some-service = lib.mkIf cfg.subFeature.enable { ... };
};
```

### Conditional package lists
```nix
environment.systemPackages = with pkgs; []
  ++ lib.optionals cfg.featureA.enable [ pkgA pkgB ]
  ++ lib.optionals cfg.featureB.enable [ pkgC ];
```

## Cross-Module Dependencies

When a module depends on another being enabled, use assertions:

```nix
config = lib.mkIf cfg.enable {
  assertions = [{
    assertion = config.modules.<other>.<module>.enable;
    message = "<this module> requires <other module> to be enabled";
  }];
};
```

For configuration that references another module's options:

```nix
config = lib.mkIf cfg.enable {
  services.some-app.config = {
    theme = config.stylix.base16Scheme.base00;
  };
};
```

## Systemd Services in Modules

Services should follow the store-path pattern:

```nix
systemd.services.my-service = lib.mkIf cfg.sub.enable {
  description = "...";
  wantedBy = ["multi-user.target"];
  after = ["network.target"];
  path = with pkgs; [ pkgs.my-pkg pkgs.bash pkgs.coreutils ];
  script = ''
    ${pkgs.my-pkg}/bin/my-binary --flag
  '';
};
```

See `.opencode/rules/nix-service-scripts.md` for the full rules on service script conventions.

## Stylix Integration

```nix
config = lib.mkIf cfg.enable {
  # Use Stylix colors from the base16 scheme
  programs.some-app.theme = {
    background = config.stylix.base16Scheme.base00;
    foreground = config.stylix.base16Scheme.base05;
  };
};
```

Available Stylix variables: `base00`-`base0F`, `base00Hex`-`base0FHex`, `cursor`, `cursorText`, `border`.

## File-Level Conventions

- **One module per file** — don't combine unrelated features
- **File name matches option name** — `power.nix` → `modules.hardware.lenovo.power`
- **Comments explain purpose, not history** — see `.opencode/rules/comment-style.md`
- **`with lib;`** can be used at the top of a module to avoid repeating `lib.` prefixes on `mkEnableOption`, `mkIf`, `mkOption`, `types`, `optionals`

## Examples

### Good: Minimal module with sub-options
```nix
{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.modules.hardware.lenovo.cooling;
in {
  options.modules.hardware.lenovo.cooling = {
    enable = mkEnableOption "Thermal guard";
    thermalGuard.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Monitor CPU temp and throttle when overheating";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.legion-thermal-guard = mkIf cfg.thermalGuard.enable {
      ...
    };
  };
}
```

### Bad: No enable option, no mkIf guard
```nix
{ config, pkgs, ... }: {
  services.foo.enable = true;  # Force-enabled, no opt-out
  environment.systemPackages = [ pkgs.foo ];
}
```
