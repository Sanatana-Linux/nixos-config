{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  options.modules.system.desktop.lightdm = {
    enable = mkEnableOption "LightDM display manager with slick-greeter";

    autoNumlock = mkOption {
      type = types.bool;
      default = false;
      description = "Enable numlock automatically";
    };
  };

  config = mkIf config.modules.system.desktop.lightdm.enable {
    services.xserver.displayManager.lightdm = {
      enable = true;
      background = ./assets/wallpaper.png;

      greeters.ganapati = {
        enable = true;
        themeName = "sharabha-gtk-theme";
      };
    };

    # Install sharabha-gtk-theme system-wide so the greeter can find it
    environment.systemPackages = [
      inputs.sharabha-gtk.packages.${pkgs.system}.default
    ];

    # Configure LightDM settings if numlock is enabled
    services.xserver.displayManager.lightdm.extraConfig = lib.mkIf config.modules.system.desktop.lightdm.autoNumlock ''
      [Seat:*]
      greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
    '';
  };
}
