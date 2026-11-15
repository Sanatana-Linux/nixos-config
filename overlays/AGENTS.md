<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-06-09 -->

# overlays/

## Purpose
Nixpkgs overlays for modifying or extending packages from nixpkgs. Overrides, patches, and version pins that don't warrant a full custom package in `pkgs/`.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Aggregates and exports all overlays — additions, modifications, stable-packages |
| `modifications/` | Per-package override modules, combined into a single `modifications` overlay |

## For AI Agents

### Working In This Directory
- Overlays are applied globally via `nixpkgs.overlays` in each host config
- Use overlays for patching existing nixpkgs packages (e.g., version bumps, fix commits)
- For entirely new packages, use `pkgs/` instead
- Keep overlays minimal — complex logic belongs in `pkgs/`
- `default.nix` exports 3 overlays: `additions` (custom pkgs + firefox-nightly-bin + ollama-pascal), `modifications` (pipx, lenovo-legion module signing for the XanMod kernel, etc.), `stable-packages` (pinned from nixos-26.05)
- `nps` was removed from `modifications` — it is now packaged directly in nixpkgs
- `ollama` overrides moved from `modifications/` to `pkgs/ollama-pascal` (exposed via `additions`) — kamala (Pascal GPU) uses the pinned `ollama-pascal`, while bagalamukhi and matangi use the unpinned upstream `ollama-cuda`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->