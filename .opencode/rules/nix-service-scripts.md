# Nix Service Script Rules

> Always use absolute store paths for binaries in systemd service scripts.

## Rule

In NixOS module `script = ''...''` blocks inside `systemd.services`, always reference binaries by their full store path via `${pkgs.<pkg>}/bin/<binary>`, never by bare name.

### Bad (bare name — fails when PATH is restricted)
```nix
script = ''
  legion_cli --donotexpecthwmon set-feature BatteryConservation 1
'';
```

### Good (absolute store path)
```nix
path = with pkgs; [pkgs.lenovo-legion pkgs.bash pkgs.coreutils];
script = ''
  ${pkgs.lenovo-legion}/bin/legion_cli --donotexpecthwmon set-feature BatteryConservation 1
'';
```

## Why

- systemd services run with a restricted PATH by default
- `path = with pkgs; [...]` adds the package's `bin/` to PATH, but `writeShellScriptBin` wrappers and Python entry points may still fail if they depend on `bash` or other interpreters not in the service PATH
- Using `${pkgs.<pkg>}/bin/<binary>` guarantees the exact store path is used regardless of PATH

## Exceptions

- `writeShellScriptBin` wrappers (like `legion-fan-apply`) can be called by bare name IF their package is in `path = with pkgs; [...]` — the wrapper script itself is a shell script that will use the PATH
- Direct Python entry points (like `legion_cli`) should always use the full store path because they need `bash` to resolve the wrapper
