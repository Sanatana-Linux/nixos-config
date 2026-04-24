<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/nixos/stylix/

## Purpose
System-wide theming via stylix — base16 color scheme, fonts, cursor theme, and wallpaper. Stylix propagates settings to most installed applications automatically.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Stylix configuration (Monokai Pro Spectrum palette) |

## For AI Agents

### Working In This Directory
- Stylix applies theme to most apps automatically — avoid duplicating color/font config in individual program modules
- Never set `home-manager.users.<name>.stylix` for users not on the current host
- The color palette is defined as a base16 scheme; `base00`-`base0F` follow base16 conventions

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->