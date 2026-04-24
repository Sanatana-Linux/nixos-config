<!-- Parent: ../.opencode/AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# pkgs/

## Purpose
Custom Nix package definitions (derivations) not available in nixpkgs or needing patches/overrides. All packages are re-exported via `default.nix` using `callPackage`.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports all packages via `callPackage` |
| `sea-greeter.nix` | Sea-greeter display manager package |
| `sea-greeter-configurable.nix` | Configurable sea-greeter wrapper with theme/font options |
| `lightdm-webkit-theme-litarvan.nix` | Litarvan webkit theme for sea-greeter/LightDM |
| `lightdm-webkit-theme-litarvan-sanatana.nix` | Sanatana-themed litarvan variant |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `legion-rgb-control/` | Lenovo Legion RGB keyboard control tool |
| `material-symbols/` | Material Symbols icon font package |

## For AI Agents

### Working In This Directory
- New packages must be added to `default.nix` using `callPackage`
- Always `git add` new `.nix` files before building — Nix flake only sees tracked files
- Use `pkgs/` for packages that need custom build steps, patches, or are not in nixpkgs
- For simple overrides, prefer `overlays/` instead

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->