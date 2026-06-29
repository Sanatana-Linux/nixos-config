---
name: nix-service-scripts
description: Create and update NixOS systemd service scripts within Nix modules. Use when adding, modifying, or debugging systemd services defined in NixOS module config blocks. Covers service structure, store path conventions, environment variables, timer services, tmpfiles, and troubleshooting.
tags: [nix, nixos, systemd, service, script, module]
---

# Nix Service Scripts Skill

Create and manage systemd service scripts defined inside NixOS modules.

## When to Use

- Adding a new systemd service to a NixOS module
- Converting a bare-name binary reference to a store path
- Adding a timer-based service (periodic task)
- Creating a service that reads secrets from sops-nix
- Debugging a service that fails silently
- Adding tmpfiles for service state directories

## Core Concepts

### Service Scripts in NixOS Modules

In ShizNix, systemd services are defined inside NixOS modules using `systemd.services.<name>`. The service's executable logic goes in the `script` attribute, which is written as a shell script string:

```nix
{ config, lib, pkgs, ... }:
let
  cfg = config.modules.my-category.my-module;
in {
  options.modules.my-category.my-module = {
    enable = lib.mkEnableOption "my feature";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.my-service = {
      description = "What this service does";
      wantedBy = ["multi-user.target"];
      path = with pkgs; [pkgs.my-pkg pkgs.bash pkgs.coreutils];
      script = ''
        ${pkgs.my-pkg}/bin/my-binary --flag
      '';
    };
  };
}
```

### The Store Path Rule

**Always use `${pkgs.<pkg>}/bin/<binary>` in `script = ''...''` blocks.**

Rationale:
- systemd services run with a restricted `$PATH` by default
- Putting packages in `path = with pkgs; [...]` adds their `bin/` to `$PATH`, but `writeShellScriptBin` wrappers may still need `bash` or other interpreters
- `${pkgs.<pkg>}/bin/<binary>` guarantees the exact store path regardless of `$PATH`

## Service Types

### Oneshot (runs once and exits)

```nix
systemd.services.my-oneshot = {
  description = "Apply configuration at boot";
  wantedBy = ["multi-user.target"];
  after = ["network.target"];
  serviceConfig.Type = "oneshot";
  path = with pkgs; [pkgs.my-pkg pkgs.bash pkgs.coreutils];
  script = ''
    ${pkgs.my-pkg}/bin/my-binary apply
  '';
};
```

For services that should persist state across reboots (not re-run):

```nix
serviceConfig = {
  Type = "oneshot";
  RemainAfterExit = true;
};
```

### Simple (long-running)

```nix
systemd.services.my-daemon = {
  description = "My long-running daemon";
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
    ${pkgs.my-pkg}/bin/my-daemon --config /etc/my-daemon/config.yaml
  '';
};
```

### Periodic (timer-triggered)

The service unit (what runs):

```nix
systemd.services.my-periodic-task = {
  description = "Periodic maintenance task";
  path = with pkgs; [pkgs.my-pkg pkgs.bash pkgs.coreutils];
  serviceConfig.Type = "oneshot";
  script = ''
    ${pkgs.my-pkg}/bin/my-task
  '';
};
```

The timer (when it runs):

```nix
systemd.timers.my-periodic-task = {
  wantedBy = ["timers.target"];
  timerConfig = {
    OnBootSec = "1m";
    OnUnitActiveSec = "30m";  # Repeat every 30m
  };
};
```

**Common timer patterns:**

| Config | Behavior |
|--------|----------|
| `OnBootSec = "5m"; OnUnitActiveSec = "1h";` | Start 5m after boot, repeat hourly |
| `OnCalendar = "daily";` | Run once per day |
| `OnCalendar = "Mon-Fri 09:00:00";` | Weekdays at 9 AM |
| `FixedRandomDelay = true;` | Add random delay to prevent thundering herd |

## Environment Variables

### Setting fixed variables

```nix
systemd.services.my-service = {
  environment = {
    LOG_LEVEL = "debug";
    CONFIG_PATH = "/etc/my-app/config.toml";
  };
  script = ''
    ${pkgs.my-pkg}/bin/my-app
  '';
};
```

### Using host config variables in service scripts

```nix
systemd.services.my-service = {
  script = ''
    HIGH=${toString cfg.highThreshold}
    LOW=${toString cfg.lowThreshold}
    # Use $HIGH and $LOW in the script logic
    if [ "$TEMP" -ge "$HIGH" ]; then
      echo "Throttling..."
    fi
  '';
};
```

Use `${toString value}` to convert Nix integers to shell strings.

## Service Dependencies

### Ordering

```nix
systemd.services.my-service = {
  wantedBy = ["multi-user.target"];
  after = [
    "network.target"
    "systemd-modules-load.service"
    "sysinit.target"
  ];
  requires = ["network-online.target"];  # Hard dependency
};
```

### Soft dependency (recommended order but no failure if missing)

```nix
after = ["network.target"];
wants = ["network-online.target"];
```

## Secrets in Services

When a service needs an encrypted secret (API key, password, etc.):

### 1. Declare the secret in the host config

```nix
# hosts/<host>/sops.nix or default.nix
sops.secrets.my_api_key = {
  owner = config.users.users.tlh.name;
};
```

### 2. Reference in the service

```nix
systemd.services.my-service = {
  path = with pkgs; [pkgs.my-pkg pkgs.bash pkgs.coreutils];
  serviceConfig = {
    # Load secret as environment variable
    EnvironmentFile = config.sops.secrets.my_api_key.path;
  };
  script = ''
    ${pkgs.my-pkg}/bin/my-binary --key="$MY_API_KEY"
  '';
};
```

**Important**: The secret name in the YAML file becomes the environment variable name (all-caps by convention). The `sops` module stores secrets at `config.sops.secrets.<name>.path`.

## Temporary Files and State Directories

When a service needs a writable runtime directory:

```nix
config = lib.mkIf cfg.enable {
  systemd.tmpfiles.rules = [
    "d /var/run/my-service 0755 root root -"
  ];

  systemd.services.my-service = {
    # ...
    script = ''
      STATE_DIR=/var/run/my-service
      # Service can now write to $STATE_DIR
    '';
  };
};
```

Format: `d <path> <mode> <owner> <group> <age>` — creates a directory if it doesn't exist.

## Debugging Service Scripts

### Check if the service file was created correctly

```bash
systemctl cat my-service
```

### View service logs

```bash
journalctl -u my-service -n 50 --no-pager
journalctl -u my-service -f  # Follow new logs
```

### Check service status

```bash
systemctl status my-service
```

### Test a oneshot service

```bash
systemctl start my-service
```

### Common issues

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Service fails with `exit code 1` | Command not found — bare name used | Use `${pkgs.<pkg>}/bin/<binary>` |
| Service shows `(null)` in description | Typo in module option path | Check `options.modules.<cat>.<name>` matches `config.modules.<cat>.<name>` |
| Timer never fires | Timer unit name must match service name | `systemd.timers.my-service` ↔ `systemd.services.my-service` |
| `Permission denied` | Binary not in service PATH | Add to `path = with pkgs; [...]` |
| Changes not applied | Need `nixos-rebuild switch` | Run build + switch, or build test first |

## Full Example: Thermal Guard Service

This is a real service from the project that combines many patterns:

```nix
systemd.services.legion-thermal-guard = lib.mkIf cfg.thermalGuard.enable {
  description = "Lenovo Legion thermal guard — throttles EPP when CPU overheats";
  wantedBy = ["multi-user.target"];
  after = ["systemd-modules-load.service" "sysinit.target"];
  serviceConfig = {
    Type = "simple";
    Restart = "always";
    RestartSec = "${toString cfg.thermalGuard.pollInterval}";
    User = "root";
  };
  path = with pkgs; [coreutils pkgs.lenovo-legion];
  script = ''
    HIGH=${toString cfg.thermalGuard.highThreshold}
    LOW=${toString cfg.thermalGuard.lowThreshold}
    INTERVAL=${toString cfg.thermalGuard.pollInterval}

    # Read CPU temperature from coretemp hwmon
    CPU_TEMP=$(( $(cat /sys/class/hwmon/hwmon*/temp1_input) / 1000 ))

    # Throttle if hot
    if [ "$CPU_TEMP" -ge "$HIGH" ]; then
      ${pkgs.lenovo-legion}/bin/legion_cli --donotexpecthwmon set-feature BatteryConservation 1
    fi
  '';
};
```

## Verification

After creating or modifying a service script:

1. **Format** the module: `alejandra <module-file>`
2. **Build test**: `nixos-rebuild build --flake .#bhairavi` (or target host)
3. **Check the generated unit**: `systemctl cat <service-name>` (after switching)
4. **Test oneshot**: `systemctl start <service-name> && journalctl -u <service-name> -n 20`
5. **Check logs**: `journalctl -u <service-name> --no-pager`

## Related Resources

- `.opencode/rules/nix-service-scripts.md` — The rule file for store path conventions
- `.opencode/rules/nix-module-patterns.md` — Module structure and option patterns
- `.opencode/skills/nixos-module/SKILL.md` — Full module creation workflow
- `.opencode/skills/nix-secrets/SKILL.md` — sops-nix secrets integration
