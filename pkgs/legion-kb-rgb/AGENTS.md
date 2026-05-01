<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# legion-kb-rgb

## Purpose
Python CLI and GTK4/libadwaita GUI application for controlling Lenovo Legion Spectrum keyboard RGB backlighting. Fetched from GitHub (andershfranzen/legion-kb-rgb v1.0.2), it installs a command-line tool (`legion-kb-rgb`) and a graphical front-end (`legion-kb-rgb-gui`) along with a .desktop entry and hicolor icon.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Python application derivation — fetches from GitHub, uses `wrapGAppsHook3` for GTK4/libadwaita, manually installs Python modules + CLI/GUI wrappers + .desktop file + SVG icon. Licensed MIT. |

## For AI Agents

### Working In This Directory
- Custom packages defined here are exposed via `pkgs/` in flake outputs
- Use overlays for patches/overrides to existing packages, not pkgs/

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->