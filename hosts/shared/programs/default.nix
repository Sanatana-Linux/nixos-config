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
      enableGraphical = false;
    };
  };
  programs = {
    java = {
      enable = true;
      package = pkgs.jre;
    };

    nm-applet.enable = false;

    # enable appimage support
    appimage.enable = true;
    appimage.binfmt = true;
    # ------------------------------------------------- #
  };
}
