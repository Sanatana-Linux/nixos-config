{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.system.desktop.lightdm;
in {
  options.modules.system.desktop.lightdm = {
    enable = mkEnableOption "LightDM display manager";

    greeter = mkOption {
      type = types.enum ["slick" "ganapati"];
      default = "slick";
      description = ''
        Which LightDM greeter to use. "slick" is lightdm-slick-greeter, a
        lightweight GTK login screen. "ganapati" is the Go-native
        lightdm-greeter-ganapati (libadwaita-styled, Wayland/X11 aware).
        Both read the active session from the desktop manager, so this only
        changes the login screen itself.
      '';
    };

    autoNumlock = mkOption {
      type = types.bool;
      default = false;
      description = "Enable numlock automatically";
    };

    autostart = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether LightDM is pulled in at boot. Disable it on a host that runs
        headless and reaches a graphical session only with a display attached:
        LightDM stays installed and configured, and is started from a console
        with `systemctl start display-manager`.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.lightdm = {
      enable = true;
      background = ./assets/wallpaper.png;
    };

    # The display manager is wanted by graphical.target, so leaving
    # multi-user.target as the boot unit keeps the console in front and starts
    # LightDM only when something asks for the graphical target.
    systemd.defaultUnit = mkIf (!cfg.autostart) (mkForce "multi-user.target");

    # Exactly one greeter may own lightdm.conf's greeter-session, and each
    # greeter module registers the `greeter` option. Guard each on cfg.greeter
    # so the unselected module never competes for it.
    services.xserver.displayManager.lightdm.greeters.slick = mkIf (cfg.greeter == "slick") {
      enable = true;
      theme.name = "sharabha-gtk-theme";
    };

    services.xserver.displayManager.lightdm.greeters.ganapati = mkIf (cfg.greeter == "ganapati") {
      enable = true;
      themeName = "sharabha-gtk-theme";
      # Ganapati would otherwise inherit stylix.image; pin the same asset
      # the slick greeter uses so the login screen is unchanged.
      wallpaper = ./assets/wallpaper.png;
    };

    # Install sharabha-gtk-theme system-wide so the greeter can find it
    environment.systemPackages = [
      inputs.sharabha-gtk.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # Configure LightDM settings if numlock is enabled
    services.xserver.displayManager.lightdm.extraConfig = mkIf cfg.autoNumlock ''
      [Seat:*]
      greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
    '';
  };
}
