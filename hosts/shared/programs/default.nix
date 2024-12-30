{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [./nix-ld.nix ./thunar.nix];
  ## Terminfo for all!
  environment.enableAllTerminfo = true;
  # Logitech for My Trackball Mouse Cause Its Ergonomic
  hardware = {
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
  programs = {
    java = {
      enable = true;
      package = pkgs.jre;
    };
    # gnome's keyring manager
    seahorse.enable = true;

    # help manage android devices via command line
    adb.enable = true;
    # networkmanager tray uility
    nm-applet.enable = false;

    # ------------------------------------------------- #
  };

  # for nux search
}
