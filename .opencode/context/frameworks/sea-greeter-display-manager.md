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
