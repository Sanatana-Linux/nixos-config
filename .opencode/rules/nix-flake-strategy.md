# Nix Flake Strategy

> Project-specific rules for ShizNix — NixOS flake configuration

## Build & Switch by Host

```bash
sudo nixos-rebuild switch --flake .#<host>
```

Available hosts: bagalamukhi, matangi, bhairavi, chhinamasta

## Testing

```bash
nixos-rebuild vm --flake .#bhairavi       # VM test
nixos-rebuild build --flake .#chhinamasta  # ISO build
nix flake check                             # Validate flake
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
nix flake update                    # update all inputs
nix flake lock --update-input <name>  # update one input
```