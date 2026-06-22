<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/nixos/system/desktop/

## Purpose
Desktop environment and display manager configuration. Controls the greeter, window manager, and visual assets for the login session.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports desktop submodules |
| `awesomewm.nix` | AwesomeWM window manager config |
| `lightdm.nix` | LightDM display manager with slick-greeter |
| `xfce.nix` | XFCE desktop environment (alternate) |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `assets/` | Wallpapers and visual assets (wallpaper.png, wallpaper-branded.png, wallpaper-memphis.png) |

## For AI Agents

### Working In This Directory
- `lightdm.nix` uses lightdm-slick-greeter — background is set via `services.xserver.displayManager.lightdm.background`
- Theme/icon/cursor are configured via `greeters.slick.{theme,iconTheme,cursorTheme}`
- Wallpaper lives in `assets/wallpaper.png`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->