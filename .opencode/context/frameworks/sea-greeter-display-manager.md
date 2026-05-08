# Sea-Greeter Display Manager Architecture

## Overview

Sea-greeter is a LightDM webkit greeter used in this NixOS config. It uses WebKitGTK to render HTML/CSS/JS themes for the login screen.

## Key Architecture Details

### Theme Directory Paths

The sea-greeter C source code hardcodes path `/usr/share/web-greeter/themes/` for theme loading. The `data/web-greeter.yml` config file has its own `/usr/share/` paths for branding/background images.

**Nix build substitution** (`pkgs/sea-greeter-configurable.nix`): The `configurePhase` must use `substituteInPlace` to rewrite the C source paths from `/usr/share/web-greeter/themes/` to `$out/usr/share/web-greeter/themes/`. Previously these substitutions used the wrong string `greeterThemes/` instead of `themes/`, meaning they silently failed to match, and the binary kept absolute `/usr/share/` paths.

### Known Bugs (Upstream)

1. **NULL file assertion crash in `load_theme_config()` (theme.c)**: When a theme lacks `index.yml`, `fopen()` returns NULL, but the code calls `yaml_parser_set_input_file(&parser, file)` with the NULL handle, causing `yaml_parser_set_input_file: Assertion 'file' failed.` This is patched in the Nix package via `substituteInPlace` to return early when the config file is missing.

2. **Case sensitivity in theme directory names**: The theme directory must exactly match `selectedTheme` in `web-greeter.yml`.

### Performance Optimizations

The `lightdm-webkit2-sanatana` package (in `pkgs/lightdm-webkit2-sanatana.nix`) applies build-time optimizations:

1. **Material Icons stripped**: The full 4.1MB Material Design Icons library (7000+ icon classes) is replaced with a hand-crafted 2KB CSS containing only the 4 used icon classes (`mdi-account-switch`, `mdi-cog`, `mdi-desktop-classic`, `mdi-power`). Only the woff2 font format is kept; eot/ttf/woff variants (2.5MB) are removed.
2. **TTF→WOFF2 conversion**: BlackHanSans-Regular goes from 962KB TTF to 187KB woff2; `@font-face` in `styles.css` is updated.
3. **60fps→1fps clock**: The `requestAnimationFrame` update loop is replaced with `setTimeout(updateTime, 1000)` — the clock only needs once-per-second updates.
4. **Unused font removal**: BodoniModa.ttf (162KB) and Knewave-Regular.ttf (31KB) are removed; they were shipped but never referenced in CSS.

**Result**: Package size reduced from ~8.9MB to ~2.0MB (77% reduction).

### Configurable Options

The `modules/nixos/desktop/lightdm.nix` module supports these performance-related options:
- `debug` (bool, default: false) — enables sea-greeter debug mode (was previously unwired — set this to have no effect before ADR-005)
- `detectThemeErrors` (bool, default: false) — if true, sea-greeter scans themes for errors on startup (adds latency); disabled by default to speed up loading
- `enableHWAcceleration` (bool, default: false) — if true, removes `WEBKIT_DISABLE_DMABUF_RENDERER=1` wrapper, allowing GPU acceleration (may improve or hurt performance depending on GPU drivers)

### Theme Installation

Themes are symlinked into `$out/usr/share/web-greeter/themes/` during the install phase. Each theme must have at minimum an `index.html` at its root (the sea-greeter default `primary_html`).

### Config File

`web-greeter.yml` is the main configuration, installed to `$out/etc/lightdm/web-greeter.yml`. It controls:
- `greeter.theme` — selected theme name
- `branding.background_images_dir` — wallpaper directory
- Layouts, features (battery, backlight)

## Custom Package: lightdm-webkit2-sanatana

A static HTML/CSS/JS theme (no build step) for sea-greeter. Defined as a flake input (`flake = false`) because GitHub's archive URL was unavailable for the brand-new repo. Installed by simply copying the source tree.

## Host Configuration

In `hosts/<name>/default.nix`:
```nix
desktop.lightdm = {
  enable = true;
  theme = pkgs.lightdm-webkit2-sanatana;  # theme package
  selectedTheme = "lightdm-webkit2-sanatana";  # directory name in themes/
  defaultWallpaper = "wallpaper.png";
};
```

The `theme` package must be passed via `pkgs.*` (available through the overlay in `overlays/default.nix` which imports from `pkgs/default.nix`).
