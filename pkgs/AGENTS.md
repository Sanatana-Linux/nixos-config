<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-27 -->

# pkgs/

## Purpose
Custom Nix package definitions (derivations) not available in nixpkgs or needing patches/overrides. All packages are re-exported via `default.nix` using `callPackage`.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports all packages via `callPackage` |


## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `legion-kb-rgb/` | Lenovo Legion keyboard RGB backlight control (see `legion-kb-rgb/AGENTS.md`) |
| `legion-rgb-control/` | Lenovo Legion RGB keyboard control tool (see `legion-rgb-control/AGENTS.md`) |
| `material-symbols/` | Material Symbols icon font package (see `material-symbols/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- New packages must be added to `default.nix` using `callPackage`
- Always `git add` new `.nix` files before building — Nix flake only sees tracked files
- Use `pkgs/` for packages that need custom build steps, patches, or are not in nixpkgs
- For simple overrides, prefer `overlays/` instead

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->