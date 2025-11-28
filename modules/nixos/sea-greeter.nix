{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.xserver.displayManager.lightdm.greeters.sea;
  
  # Sea-greeter configuration file
  seaGreeterConf = pkgs.writeText "sea-greeter.conf" ''
    [greeter]
    debug_mode = ${if cfg.debug then "true" else "false"}
    detect_theme_errors = ${if cfg.detectThemeErrors then "true" else "false"}
    screensaver_timeout = ${toString cfg.screensaverTimeout}
    secure_mode = ${if cfg.secureMode then "true" else "false"}
    time_language = ${cfg.timeLanguage}
    
    [branding]
    background_images = ${cfg.background}
    logo = ${cfg.logo}
    user_image = ${cfg.userImage}
    
    [theme]
    theme = ${cfg.theme.name}
    
    ${cfg.extraConfig}
  '';

in {
  options = {
    services.xserver.displayManager.lightdm.greeters.sea = {
      enable = mkEnableOption "sea-greeter, a webkit2gtk-based LightDM greeter";

      package = mkOption {
        type = types.package;
        default = pkgs.sea-greeter;
        defaultText = literalExpression "pkgs.sea-greeter";
        description = "The sea-greeter package to use";
      };

      theme = {
        name = mkOption {
          type = types.str;
          default = "gruvbox";
          description = "Theme to use for the greeter";
        };

        package = mkOption {
          type = types.nullOr types.package;
          default = null;
          description = "Package containing the theme";
        };
      };

      background = mkOption {
        type = types.str;
        default = "";
        description = "Path to background image or directory of images";
      };

      logo = mkOption {
        type = types.str;
        default = "";
        description = "Path to logo image";
      };

      userImage = mkOption {
        type = types.str;
        default = "";
        description = "Default user image path";
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Enable debug mode";
      };

      detectThemeErrors = mkOption {
        type = types.bool;
        default = true;
        description = "Detect theme errors";
      };

      screensaverTimeout = mkOption {
        type = types.int;
        default = 300;
        description = "Screensaver timeout in seconds";
      };

      secureMode = mkOption {
        type = types.bool;
        default = true;
        description = "Enable secure mode";
      };

      timeLanguage = mkOption {
        type = types.str;
        default = "";
        description = "Language for time display (empty for system default)";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional configuration to append to sea-greeter.conf";
      };
    };
  };

  config = mkIf (config.services.xserver.displayManager.lightdm.enable && cfg.enable) {
    services.xserver.displayManager.lightdm.greeters.gtk.enable = false;
    
    services.xserver.displayManager.lightdm = {
      extraSeatDefaults = ''
        greeter-session=sea-greeter
      '';
    };

    environment.systemPackages = [cfg.package];

    # Install configuration
    environment.etc."lightdm/sea-greeter.conf".source = seaGreeterConf;

    # Install themes if provided
    environment.etc = mkIf (cfg.theme.package != null) {
      "sea-greeter/themes/${cfg.theme.name}".source = "${cfg.theme.package}";
    };

    # Create desktop entry for LightDM
    environment.etc."lightdm/greeters.d/sea-greeter.desktop".text = ''
      [Desktop Entry]
      Name=Sea Greeter
      Comment=LightDM greeter made with WebKit2GTK
      Exec=${cfg.package}/bin/sea-greeter
      Type=Application
      X-Ubuntu-Gettext-Domain=sea-greeter
    '';
  };
}
