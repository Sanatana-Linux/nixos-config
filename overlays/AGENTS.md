<!-- Parent: ../.opencode/AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# overlays/

## Purpose
Nixpkgs overlays for modifying or extending packages from nixpkgs. Overrides, patches, and version pins that don't warrant a full custom package in `pkgs/`.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Aggregates and exports all overlays |

## For AI Agents

### Working In This Directory
- Overlays are applied globally via `nixpkgs.overlays` in the flake
- Use overlays for patching existing nixpkgs packages (e.g., version bumps, fix commits)
- For entirely new packages, use `pkgs/` instead
- Keep overlays minimal — complex logic belongs in `pkgs/`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->