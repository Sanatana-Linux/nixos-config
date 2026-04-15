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
      default = "lightdm-webkit-theme-litarvan-sanatana";
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
    # Determine effective theme - fallback to gruvbox if custom theme not available
    effectiveTheme =
      if
        (config.modules.desktop.lightdm.selectedTheme
          == "lightdm-webkit-theme-litarvan-sanatana"
          && !(builtins.hasAttr "lightdm-webkit-theme-litarvan-sanatana" pkgs))
      then "gruvbox"
      else config.modules.desktop.lightdm.selectedTheme;
  in {
    # Build sea-greeter with the specified configuration
    environment.systemPackages = with pkgs; let
      # Use backgrounds package or create one from local path
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

      # Determine themes to install - handle case where custom theme isn't available
      defaultSanatanaTheme =
        if (builtins.hasAttr "lightdm-webkit-theme-litarvan-sanatana" pkgs)
        then pkgs.lightdm-webkit-theme-litarvan-sanatana
        else null;
      allThemes =
        (lib.optional (defaultSanatanaTheme != null) defaultSanatanaTheme)
        ++ (lib.optional (config.modules.desktop.lightdm.theme != null) config.modules.desktop.lightdm.theme)
        ++ config.modules.desktop.lightdm.themes;

      # Build configured sea-greeter
      configuredSeaGreeter = pkgs.callPackage ../../../pkgs/sea-greeter-configurable.nix {
        themes = allThemes;
        selectedTheme = effectiveTheme;
        backgrounds = effectiveBackgrounds;
        enableHWAcceleration = config.modules.desktop.lightdm.enableHWAcceleration;
        defaultWallpaper = config.modules.desktop.lightdm.defaultWallpaper;
      };
    in
      [
        configuredSeaGreeter
      ]
      ++ allThemes;

    services.xserver.displayManager.lightdm = {
      enable = true;
      greeter = {
        enable = true;
        package = pkgs.callPackage ../../../pkgs/sea-greeter-configurable.nix {
          themes =
            (lib.optional (builtins.hasAttr "lightdm-webkit-theme-litarvan-sanatana" pkgs) pkgs.lightdm-webkit-theme-litarvan-sanatana)
            ++ (lib.optional (config.modules.desktop.lightdm.theme != null) config.modules.desktop.lightdm.theme)
            ++ config.modules.desktop.lightdm.themes;
          selectedTheme = effectiveTheme;
          backgrounds =
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
          enableHWAcceleration = config.modules.desktop.lightdm.enableHWAcceleration;
          defaultWallpaper = config.modules.desktop.lightdm.defaultWallpaper;
        };
        name = "sea-greeter";
      };
    };

    # Configure LightDM settings if numlock is enabled
    services.xserver.displayManager.lightdm.extraConfig = lib.mkIf config.modules.desktop.lightdm.autoNumlock ''
      [Seat:*]
      greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
    '';
  });
}
