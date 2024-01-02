{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.kde;
in {
  options.tlh.kde = {enable = mkEnableOption "activate kde";};

  config = mkIf cfg.enable {
    # Enable networkmanager
    networking.networkmanager.enable = true;

    # enable the Plasma 5 Desktop Environment.
    services.xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5 = {
        enable = true;
      };
    };
    # exclude some packages from plasma5
    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      gwenview
      oxygen
      khelpcenter
      # konsole # we should not remove konsole before we have a replacement
      plasma-browser-integration
      #print-manager
    ];
    # see https://nixos.wiki/wiki/KDE#GTK_themes_are_not_applied_in_Wayland_applications
    programs.dconf.enable = true;
  };
}
