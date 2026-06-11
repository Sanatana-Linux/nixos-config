<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-06-09 -->

# overlays/

## Purpose
Nixpkgs overlays for modifying or extending packages from nixpkgs. Overrides, patches, and version pins that don't warrant a full custom package in `pkgs/`.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Aggregates and exports all overlays — torch removals, pipx test override, custom packages |
| `opencode.nix` | Source-built opencode 1.17.3 with bun-based npm dependency resolution |

## For AI Agents

### Working In This Directory
- Overlays are applied globally via `nixpkgs.overlays` in the flake
- Use overlays for patching existing nixpkgs packages (e.g., version bumps, fix commits)
- For entirely new packages, use `pkgs/` instead
- Keep overlays minimal — complex logic belongs in `pkgs/`
- `opencode.nix` uses `stdenvNoCC.mkDerivation` with bun `--frozen-lockfile` for npm deps, with pre-built `node_modules` derivation for purity
- `default.nix` also disables pipx tests (`doCheck = false`) and removes torch/python-ml packages from python312/313 to force torch-bin usage

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->