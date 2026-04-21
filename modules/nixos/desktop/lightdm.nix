{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.desktop.lightdm = {
    enable = mkEnableOption "LightDM display manager with Sea greeter (webkit)";

    theme = mkOption {
      type = types.nullOr types.package;
      default = null; # Use built-in themes
      description = "WebKit theme package for the greeter (if null, uses built-in themes)";
    };

    themes = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "List of additional WebKit theme packages to install";
    };

    selectedTheme = mkOption {
      type = types.str;
      default = "gruvbox";
      description = "Name of the theme to use (must match theme package pname or built-in theme name)";
    };

    backgrounds = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "Package containing background images (if null, uses local assets)";
    };

    backgroundsPath = mkOption {
      type = types.nullOr types.path;
      default = ./assets;
      description = "Local path to background images directory";
    };

    debug = mkOption {
      type = types.bool;
      default = false;
      description = "Enable debug mode for sea-greeter";
    };

    autoNumlock = mkOption {
      type = types.bool;
      default = false;
      description = "Enable numlock automatically";
    };

    enableHWAcceleration = mkOption {
      type = types.bool;
      default = false;
      description = "Enable hardware acceleration for webkit";
    };

    defaultWallpaper = mkOption {
      type = types.nullOr types.str;
      default = "sanatana_topographic.png";
      description = "Default wallpaper filename from the backgrounds directory";
    };
  };

  config = mkIf config.modules.desktop.lightdm.enable (let
    effectiveTheme = config.modules.desktop.lightdm.selectedTheme;

    effectiveBackgrounds =
      if config.modules.desktop.lightdm.backgrounds != null
      then config.modules.desktop.lightdm.backgrounds
      else if config.modules.desktop.lightdm.backgroundsPath != null
      then
        pkgs.stdenv.mkDerivation {
          pname = "local-lightdm-backgrounds";
          version = "1.0";
          src = config.modules.desktop.lightdm.backgroundsPath;
          installPhase = ''
            mkdir -p $out
            cp -r $src/* $out/ 2>/dev/null || true
          '';
        }
      else null;

    allThemes =
      (lib.optional (config.modules.desktop.lightdm.theme != null) config.modules.desktop.lightdm.theme)
      ++ config.modules.desktop.lightdm.themes;

    configuredSeaGreeter = pkgs.callPackage ../../../pkgs/sea-greeter-configurable.nix {
      themes = allThemes;
      selectedTheme = effectiveTheme;
      backgrounds = effectiveBackgrounds;
      enableHWAcceleration = config.modules.desktop.lightdm.enableHWAcceleration;
      defaultWallpaper = config.modules.desktop.lightdm.defaultWallpaper;
    };
  in {
    environment.systemPackages = [
      configuredSeaGreeter
      pkgs.phinger-cursors
    ] ++ allThemes;

    services.xserver.displayManager.lightdm = {
      enable = true;
      greeter = {
        enable = true;
        package = configuredSeaGreeter;
        name = "sea-greeter";
      };
    };

    # Cursor theme for the display manager (login screen)
    environment.etc."X11/Xsession.d/00-cursor-theme" = {
      text = ''
        export XCURSOR_THEME=phinger-cursors-light
        export XCURSOR_SIZE=32
        if command -v xrdb >/dev/null 2>&1; then
          xrdb -merge <<EOF
      Xcursor.theme: phinger-cursors-light
      Xcursor.size: 32
      EOF
        fi
        if command -v xsetroot >/dev/null 2>&1; then
          xsetroot -cursor_name left_ptr
        fi
      '';
      mode = "0755";
    };

    # Configure LightDM settings if numlock is enabled
    services.xserver.displayManager.lightdm.extraConfig = lib.mkIf config.modules.desktop.lightdm.autoNumlock ''
      [Seat:*]
      greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
    '';
  });
}
