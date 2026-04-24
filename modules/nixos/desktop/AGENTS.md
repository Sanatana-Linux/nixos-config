<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/nixos/desktop/

## Purpose
Desktop environment and display manager configuration. Controls the greeter, window manager, and visual assets for the login session.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports desktop submodules |
| `awesomewm.nix` | AwesomeWM window manager config |
| `lightdm.nix` | LightDM display manager with sea-greeter and theme support |
| `xfce.nix` | XFCE desktop environment (alternate) |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `assets/` | Wallpapers and visual assets (wallpaper.png, monokaiprospectrum.png, sanatana_topographic.png) |

## For AI Agents

### Working In This Directory
- `lightdm.nix` uses sea-greeter (NOT lightdm-gtk-greeter) — the litarvan theme must be explicitly passed via the `theme` option
- The `configuredSeaGreeter` and related `let` bindings must be in the outer module scope (not inside `environment.systemPackages`'s let block)
- Cursor theme on the greeter requires phinger-cursors in systemPackages + Xsession.d script
- `defaultWallpaper` option sets the background image; wallpapers live in `assets/`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->