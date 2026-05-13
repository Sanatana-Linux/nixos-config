{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.desktop.lightdm = {
    enable = mkEnableOption "LightDM display manager with slick-greeter";

    autoNumlock = mkOption {
      type = types.bool;
      default = false;
      description = "Enable numlock automatically";
    };
  };

  config = mkIf config.modules.desktop.lightdm.enable {
    services.xserver.displayManager.lightdm = {
      enable = true;
      background = ./assets/wallpaper.png;

      greeters.slick = {
        enable = true;
        theme = {
          package = pkgs.materia-theme-transparent;
          name = "Materia-dark-compact";
        };
        iconTheme = {
          package = pkgs.colloid-icon-theme;
          name = "Colloid-dark";
        };
        cursorTheme = {
          package = pkgs.phinger-cursors;
          name = "phinger-cursors-light";
          size = 32;
        };
        draw-user-backgrounds = false;
      };
    };

    # Configure LightDM settings if numlock is enabled
    services.xserver.displayManager.lightdm.extraConfig = lib.mkIf config.modules.desktop.lightdm.autoNumlock ''
      [Seat:*]
      greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
    '';
  };
}
