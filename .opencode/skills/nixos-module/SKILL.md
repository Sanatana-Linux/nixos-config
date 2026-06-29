---
name: nixos-module
description: Create and manage NixOS and home-manager modules following the enable-by-option pattern used in ShizNix. Use when adding new system functionality, refactoring existing modules, creating home-manager modules, adding systemd services, or working with option declarations. Covers module structure, option types, mkIf guards, systemd services, Stylix integration, cross-module dependencies, and verification.
tags: [nix, nixos, module, configuration, systemd, enable-by-option]
---

# NixOS Module Skill

Create and manage NixOS and home-manager modules following the ShizNix enable-by-option pattern.

## When to Use

- Adding a new system-level feature (new NixOS module)
- Adding a new user-level feature (new home-manager module)
- Adding a systemd service to an existing module
- Refactoring an existing module to follow the enable-by-option pattern
- Adding Stylix theming support to a module
- Adding conditional sub-features within a module
- Creating cross-module dependencies or option references

## Module Structure

### NixOS Module Template

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.<category>.<name>;
in {
  options.modules.<category>.<name> = {
    enable = lib.mkEnableOption "description of what this enables";
    # Add sub-options here...
  };

  config = lib.mkIf cfg.enable {
    # Implementation here...
    # Packages, services, environment, etc.
  };
}
```

### Home-Manager Module Template

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.<category>.<name>;
in {
  options.modules.<category>.<name> = {
    enable = lib.mkEnableOption "description";
  };

  config = lib.mkIf cfg.enable {
    # home-manager config (home.packages, programs, xdg, etc.)
  };
}
```

### `with lib;` Shortcut

Many modules use `with lib;` at the top to avoid repeating `lib.` prefixes:

```nix
{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.modules.hardware.lenovo.cooling;
in {
  options.modules.hardware.lenovo.cooling = {
    enable = mkEnableOption "Thermal guard";
  };
  config = mkIf cfg.enable { ... };
}
```

## Option Declarations

### Basic Types

```nix
options.modules.my-module = {
  enable = lib.mkEnableOption "my feature";

  # Boolean flag
  verbose = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable verbose logging";
  };

  # Numeric value
  threshold = lib.mkOption {
    type = lib.types.int;
    default = 75;
    description = "Temperature threshold in °C";
  };

  # String with fixed choices
  mode = lib.mkOption {
    type = lib.types.enum ["powersave" "balanced" "performance"];
    default = "balanced";
    description = "Power profile mode";
  };

  # Optional value (null by default)
  customPath = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Custom config file path";
  };

  # Package reference
  package = lib.mkOption {
    type = lib.types.package;
    default = pkgs.my-package;
    description = "Package to use";
    defaultText = "pkgs.my-package";
  };
};
```

### Nested Options (Sub-Features)

```nix
options.modules.hardware.lenovo.cooling = {
  enable = lib.mkEnableOption "cooling management";

  thermalGuard = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable thermal guard monitoring";
    };
    highThreshold = lib.mkOption {
      type = lib.types.int;
      default = 75;
      description = "CPU temp to start throttling";
    };
  };

  fanControl = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable custom fan curves";
    };
  };
};
```

## Adding Systemd Services to a Module

Services are the most common implementation inside NixOS modules.

### Oneshot Service (runs once at boot)

```nix
config = lib.mkIf cfg.enable {
  systemd.services.my-oneshot = lib.mkIf cfg.subFeature.enable {
    description = "Run one-time setup";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig.Type = "oneshot";
    # No RemainAfterExit — runs once on every boot
    path = with pkgs; [pkgs.my-pkg pkgs.bash pkgs.coreutils];
    script = ''
      ${pkgs.my-pkg}/bin/my-binary --flag
    '';
  };
};
```

### Persistent Service (keeps running)

```nix
systemd.services.my-daemon = lib.mkIf cfg.sub.enable {
  description = "My Long-Running Service";
  wantedBy = ["multi-user.target"];
  after = ["sysinit.target"];
  serviceConfig = {
    Type = "simple";
    Restart = "always";
    RestartSec = "10";
    User = "root";
  };
  path = with pkgs; [pkgs.my-pkg pkgs.bash pkgs.coreutils];
  script = ''
    ${pkgs.my-pkg}/bin/my-daemon
  '';
};
```

### Timer-Triggered Service

```nix
# The service unit
systemd.services.my-periodic-task = {
  description = "Periodic task";
  path = with pkgs; [pkgs.my-pkg pkgs.bash pkgs.coreutils];
  serviceConfig.Type = "oneshot";
  script = ''
    ${pkgs.my-pkg}/bin/my-task
  '';
};

# The timer that triggers it
systemd.timers.my-periodic-task = {
  wantedBy = ["timers.target"];
  timerConfig = {
    OnBootSec = "1m";
    OnUnitActiveSec = "30m";  # Repeat every 30 minutes
  };
};
```

**Important**: Always use `${pkgs.<pkg>}/bin/<binary>` in the `script` block — see `.opencode/rules/nix-service-scripts.md` for the full rules.

### Temporary Files (State Directories)

When a service needs a writable state directory:

```nix
systemd.tmpfiles.rules = [
  "d /var/run/my-service 0755 root root -"
];
```

## Conditional Config Patterns

### mkIf chaining (sub-features within mkIf)

```nix
config = lib.mkIf cfg.enable {
  # Always enabled when cfg.enable is true
  environment.systemPackages = [pkgs.my-core];

  # Only enabled when sub-feature is also enabled
  systemd.services.my-daemon = lib.mkIf cfg.daemon.enable {
    ...
  };
};
```

### Conditional package inclusion

```nix
environment.systemPackages = with pkgs; []
  ++ lib.optionals cfg.guiSupport [ qt5.qtwayland qt6.qtwayland ]
  ++ lib.optionals cfg.cliTools [ ripgrep fd ];
```

## Cross-Module Dependencies

### Assertions (required dependency)

```nix
config = lib.mkIf cfg.enable {
  assertions = [{
    assertion = config.modules.base.services.enable;
    message = "My module requires base.services to be enabled";
  }];
};
```

### Reading from other modules

```nix
config = lib.mkIf cfg.enable {
  services.my-app.settings.theme = {
    # Reference Stylix theme colors from another module
    bg = config.stylix.base16Scheme.base00;
    fg = config.stylix.base16Scheme.base05;
  };
};
```

## Category Placement

### NixOS Modules

| Category | Path | Typical Contents |
|----------|------|-----------------|
| base | `modules/nixos/base/` | Core system: nix, fhs, fonts, services, shell, variables |
| hardware | `modules/nixos/hardware/` | GPU drivers, bluetooth, keyboard, sound, lenovo, devices |
| stylix | `modules/nixos/stylix/` | System theme integration |
| system | `modules/nixos/system/` | Boot, cron, networking, security, desktop, apps, performance, virtualization (Docker, LXC, virt-manager, waydroid, quickemu) |
| users | `modules/nixos/users/` | Per-user account modules (import per-host only) |

### Home-Manager Modules

| Category | Path | Typical Contents |
|----------|------|-----------------|
| core | `modules/home-manager/core/` | Home, environment, xdg, nix |
| desktop | `modules/home-manager/desktop/` | Compositors, theming |
| packages | `modules/home-manager/packages/` | Essential, permitted-insecure |
| programs | `modules/home-manager/programs/` | Browsers, editors, file-managers, misc, security, terminals |
| services | `modules/home-manager/services/` | Picom, xscreensaver, gnome-keyring, ssh-agent |
| shell | `modules/home-manager/shell/` | Zsh, starship, cli-tools, scripts |
| stylix | `modules/home-manager/stylix/` | User theme integration |

## Registration

### 1. Create the module file

```bash
# modules/nixos/<category>/<name>.nix
```

### 2. Register in the category's default.nix

```nix
# modules/nixos/<category>/default.nix
{
  imports = [
    ./existing-module.nix
    ./new-module.nix
  ];
}
```

### 3. Git add (required for Nix flakes)

```bash
git add modules/nixos/<category>/<name>.nix
```

### 4. Enable on the host

```nix
# hosts/<host>/default.nix
{
  modules.<category>.<name>.enable = true;
}
```

## Updating Existing Modules

When modifying an existing module, follow these steps:

1. **Read the current file** — understand the existing options and config
2. **Add new options** in the `options` block (alphabetical order by name)
3. **Add config** in the `config = lib.mkIf cfg.enable { ... }` block
4. **Preserve existing options** — don't rename or remove without a deprecation path
5. **Follow comment style** — explain what code does, not how it changed (see `.opencode/rules/comment-style.md`)
6. **Keep mkIf guards** — never move config outside the `mkIf cfg.enable` guard

### Adding a new option to an existing module

```nix
# Add alongside existing options
options.modules.hardware.lenovo.power = {
  # ... existing options ...
  
  # NEW: Conservation mode
  conservationMode = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable battery conservation mode via legion_cli";
  };
};
```

## Verification

After creating or modifying a module:

1. **Format** with alejandra:
   ```bash
   alejandra <file>
   # or use the nix-format tool
   ```

2. **Build test** on the VM host:
   ```bash
   nixos-rebuild build --flake .#bhairavi
   # or use the nix-build tool
   ```

3. **Check evaluation**:
   ```bash
   nix flake check
   # or use the nix-flake tool
   ```

4. **`git add` new files** before building — Nix flakes only see tracked files

5. **Host-specific builds**: for changes that only affect specific hardware (e.g., Lenovo, NVIDIA), build for that specific host:
   ```bash
   nixos-rebuild build --flake .#bagalamukhi
   ```

## Best Practices

- **One module per file** — don't combine unrelated features
- **File name matches option name** — `power.nix` → `modules.hardware.lenovo.power`
- **Use `mkIf cfg.enable`** for all config — never put config outside the guard
- **Default to false** for optional features — hosts opt in explicitly
- **Default to true** for essential sub-features (e.g., `thermalGuard.enable`)
- **Annotate all options** with `description` — future maintainers need context
- **Reference related rules**: `.opencode/rules/nix-module-patterns.md` for patterns reference, `.opencode/rules/nix-service-scripts.md` for service script conventions, `.opencode/rules/comment-style.md` for comment conventions
