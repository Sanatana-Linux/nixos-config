# Sea-Greeter Setup Guide

Sea-greeter is now fully integrated into your NixOS configuration as a LightDM greeter you can theme with web technologies (HTML/CSS/JavaScript).

## What Was Done

1. **Package**: Fixed `/etc/nixos/pkgs/sea-greeter.nix` to properly build sea-greeter with all dependencies
2. **Module**: Created `/etc/nixos/modules/nixos/sea-greeter.nix` with full configuration options
3. **Integration**: Added the module to your flake.nix for bagalamukhi
4. **Example**: Created `/etc/nixos/hosts/shared/desktop/sea-greeter-example.nix` showing usage

## How to Use

### Option 1: Replace Current Greeter in bagalamukhi

Edit `/etc/nixos/hosts/bagalamukhi/default.nix` or `/etc/nixos/hosts/shared/desktop/default.nix`:

```nix
services.xserver.displayManager.lightdm = {
  enable = true;
  greeters.gtk.enable = false;  # Disable gtk greeter
  greeters.sea.enable = true;   # Enable sea-greeter
  greeters.sea.background = "/path/to/your/background.png";
};
```

### Option 2: Import the Example Config

In your host config, add:

```nix
imports = [
  ../shared/desktop/sea-greeter-example.nix
];
```

Then edit the example file to customize.

## Configuration Options

All options are under `services.xserver.displayManager.lightdm.greeters.sea`:

- `enable` - Enable sea-greeter
- `package` - Override the sea-greeter package
- `theme.name` - Theme name (default: "gruvbox")
- `theme.package` - Package containing custom theme
- `background` - Path to background image
- `logo` - Path to logo image
- `debug` - Enable debug mode
- `screensaverTimeout` - Timeout in seconds
- `extraConfig` - Additional configuration

## Creating Custom Themes

Sea-greeter themes are web-based (HTML/CSS/JS). To create a custom theme:

1. **Create theme directory structure:**
   ```
   my-theme/
   ├── index.html
   ├── style.css
   ├── script.js
   └── theme.conf
   ```

2. **Package it in Nix:**
   ```nix
   # In pkgs/my-sea-greeter-theme.nix
   { stdenv, ... }:
   stdenv.mkDerivation {
     pname = "my-sea-greeter-theme";
     version = "1.0";
     src = ./my-theme;
     installPhase = ''
       mkdir -p $out
       cp -r * $out/
     '';
   }
   ```

3. **Use it in configuration:**
   ```nix
   services.xserver.displayManager.lightdm.greeters.sea = {
     theme = {
       name = "my-theme";
       package = pkgs.callPackage ./pkgs/my-sea-greeter-theme.nix {};
     };
   };
   ```

## Theming Resources

- Official docs: https://web-greeter-page.vercel.app
- GitHub repo: https://github.com/JezerM/sea-greeter
- Example themes: Check the repo's themes directory

## Troubleshooting

If sea-greeter doesn't start:

1. Check logs: `journalctl -u display-manager.service`
2. Enable debug mode: `services.xserver.displayManager.lightdm.greeters.sea.debug = true;`
3. Test the package builds: `nix build .#packages.x86_64-linux.sea-greeter`

## Web Technologies You Can Use

- **HTML5** for structure
- **CSS3** for styling (including animations, flexbox, grid)
- **JavaScript** for interactivity
- **LightDM API** for login functionality (provided by sea-greeter)

This gives you full control with the web skills you already have!
