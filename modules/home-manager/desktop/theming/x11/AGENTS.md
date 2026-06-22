<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-22 | Updated: 2026-04-27 -->

# x11/

## Purpose
X11 resource and theme configuration for home-manager. Provides two modules: `xresources` for raw X resource config with Monokai Pro Spectrum colors, and `desktop.x11` for structured X resource properties. Both set the same color scheme using different approaches.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports `resources.nix` and `theme.nix` via imports |
| `resources.nix` | X resources with Monokai Pro Spectrum colors using `xresources.extraConfig` raw format |
| `theme.nix` | X resources using `xresources.properties` structured format (module path: `modules.desktop.x11`) |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| *(none)* | — |

## For AI Agents

### Working In This Directory
- `resources.nix` uses `options.modules.desktop.xresources` and `theme.nix` uses `options.modules.desktop.x11` — both under the `modules.desktop.*` option path
- Both modules set Monokai Pro Spectrum colors but via different mechanisms: raw text vs. structured attribute set
- These duplicate the color values defined in `modules/nixos/stylix/` — keep them in sync when updating the palette
- `resources.nix` includes DPI setting (`Xft.dpi: 96`); `theme.nix` does not

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->