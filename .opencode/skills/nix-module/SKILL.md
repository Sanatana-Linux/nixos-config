---
name: nix-module
description: Create, modify, and verify NixOS or home-manager modules following the enable-by-option pattern
level: 1
---

# Nix Module — ShizNix

Create or modify NixOS/home-manager modules following project conventions.

## Module Pattern (Mandatory)

Every module must follow the **enable-by-option** pattern:

```nix
{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.modules.<category>.<name>;
in {
  options.modules.<category>.<name> = {
    enable = mkEnableOption "Description of what this enables";
    # additional options...
  };

  config = mkIf cfg.enable {
    # configuration goes here
  };
}
```

## Category Structure

### NixOS modules: `modules/nixos/<category>/`

| Category | Purpose | Examples |
|----------|---------|---------|
| hardware | HW-specific config | lenovo, nvidia, intel-cpu |
| desktop | Display managers, compositors | lightdm, awesome, picom |
| security | Firewall, SSH, auditing | firewall, sshd, fail2ban |
| services | Daemons and servers | postgres, nginx, syncthing |
| system | Core system settings | kernel, boot, nix settings |
| users | User declarations | tlh, smg (host-scoped) |
| network | Network config | wifi, vpn, dhcp |

### Home-manager modules: `modules/home-manager/<category>/`

| Category | Purpose | Examples |
|----------|---------|---------|
| programs | CLI/TUI programs | git, zsh, tmux, yazi |
| desktop | Desktop app config | firefox, thunar, picom |
| development | Dev tools | vscode, nvim, docker |
| services | User services | gpg-agent, syncthing |
| shell | Shell environment | aliases, env vars, prompt |
| theme | User-level theming | gtk, qt, cursor |
| media | Media apps | mpv, zathura (deprecated) |

## Index Files

Category directories have `default.nix` that imports submodules:

```nix
{ lib, ... }:
with lib;
{
  imports = [
    ./hardware
    ./desktop
    ./security
    # ...
  ];
}
```

For conditional imports by host:

```nix
imports = lib.optional (builtins.elem "specific-service" (builtins.attrNames config.modules.services))
  ./specific-service.nix;
```

## Conventions

- Module options are in `options.modules.<cat>.<name>.*`
- Config is always wrapped in `mkIf cfg.enable`
- Use `types` from `lib.types` for option types
- String types: `types.str` (NOT deprecated `types.string`)
- `mkEnableOption` for boolean enables
- `mkPackageOption` for package references
- No direct `imports = [ ./path ]` that bypass the enable option in host configs