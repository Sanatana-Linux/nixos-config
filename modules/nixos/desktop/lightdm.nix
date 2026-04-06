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
      type = types.str;
      default = "lightdm-webkit-theme-litarvan";
      description = "WebKit theme for the greeter";
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
  };

  config = mkIf config.modules.desktop.lightdm.enable {
    services.xserver.displayManager.lightdm = {
      enable = true;
      greeter = {
        enable = true;
        package = pkgs.sea-greeter-litarvan;
        name = "sea-greeter";
      };
    };

    # Configure sea-greeter settings
    environment.etc."lightdm/web-greeter.yml".text = ''
      branding:
        background_images_dir: /usr/share/backgrounds
        logo_image: ""
        user_image: ""
      greeter:
        debug_mode: ${if config.modules.desktop.lightdm.debug then "true" else "false"}
        detect_theme_errors: true
        screensaver_timeout: 300
        secure_mode: true
        time_format: "%H:%M"
        time_language: ""
        theme: ${config.modules.desktop.lightdm.theme}
      layouts:
        - name: "us"
          short_name: "en"
      features:
        battery: false
        backlight:
          enabled: false
          value: 10
          steps: 0
    '';

    # Additional packages needed for sea-greeter with litarvan theme
    environment.systemPackages = with pkgs; [
      sea-greeter-litarvan
      lightdm-webkit-theme-litarvan
      various-nature-images
    ];
  };
}