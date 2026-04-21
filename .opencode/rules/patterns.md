# NixOS Module Patterns

## Enable-by-Option Module

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.<category>.<name>;
in {
  options.modules.<category>.<name> = {
    enable = mkEnableOption "Description";

    # Additional options with defaults
    example = mkOption {
      type = types.str;
      default = "value";
      description = "Description";
    };
  };

  config = mkIf cfg.enable {
    # Configuration only applied when enabled
  };
}
```

## User Module (with home-manager)

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.users.<username>;
in {
  options.modules.users.<username> = {
    enable = mkEnableOption "Create user account for <username>";
    homeManagerConfig = mkOption {
      type = types.path;
      default = ../../../home/<username>/default.nix;
    };
  };

  config = mkIf cfg.enable {
    users.users.<username> = { ... };
    home-manager.users.<username> = import cfg.homeManagerConfig;
  };
}
```

**Critical**: User modules must only be imported on hosts that use them. Never import all user modules via a shared `default.nix`.

## Conditional Package Lists

```nix
packages = optionals cfg.<suboption>.enable [
  pkg1
  pkg2
];
```

## Host Configuration

```nix
{
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/users/<username>.nix
  ];

  modules = {
    <category>.<name>.enable = true;
  };

  system.stateVersion = "24.11";
}
```