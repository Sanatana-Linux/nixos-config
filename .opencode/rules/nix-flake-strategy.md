# Nix Flake Strategy

> Project-specific rules for ShizNix — NixOS flake configuration

## Build & Switch by Host

```bash
sudo nixos-rebuild switch --flake .#<host> --impure
```

Available hosts: bagalamukhi, matangi, bhairavi, chhinamasta

## Critical — `--impure` Is Always Required

Every build, rebuild, and evaluation in this repo must pass `--impure`:

```bash
nixos-rebuild build --flake .#<host> --impure
nixos-rebuild switch --flake .#<host> --impure
nixos-rebuild vm --flake .#<host> --impure
nix flake check . --impure
```

sops-nix sets `sops.defaultSopsFile` to the absolute path
`/etc/nixos/external/secrets/secrets.yaml`, and pure evaluation mode refuses to
read absolute paths. Without the flag the build fails with:

```
error: access to absolute path '/etc/nixos/external/secrets/secrets.yaml'
is forbidden in pure evaluation mode (use '--impure' to override)
```

`nixos-rebuild` forwards `--impure` to the `nix build` it runs internally, so
the flag must be given to `nixos-rebuild` itself, not appended afterwards.

## Testing

```bash
nixos-rebuild vm --flake .#bhairavi --impure        # VM test
nixos-rebuild build --flake .#chhinamasta --impure  # ISO build
nix flake check . --impure                          # Validate flake
```

## Formatting

Repository uses `alejandra` for nix formatting:

```bash
alejandra .  # format all .nix files
```

## Module Pattern

Every module follows the enable-by-option pattern:

```nix
options.modules.<category>.<name>.enable = mkEnableOption "...";
config = mkIf cfg.enable { ... };
```

## Key Paths

| Path | Purpose |
|------|---------|
| `modules/nixos/` | System-level NixOS modules |
| `modules/home-manager/` | User-level home-manager modules |
| `hosts/<host>/` | Per-host configuration |
| `home/<user>/` | Per-user home-manager config |
| `pkgs/` | Custom package derivations |
| `overlays/` | Nixpkgs overlays |
| `external/` | Git submodules (DO NOT modify directly) |

## Critical — External Directory

Do NOT modify files in `external/` unless explicitly instructed. They are git submodules managed in their own repos.

## Flake Maintenance

```bash
nix flake update                      # update all inputs
nix flake lock --update-input <name>  # update one input
```