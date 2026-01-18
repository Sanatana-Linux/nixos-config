{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [./nix-ld.nix ./affinity.nix ./thunar.nix];
  ## Terminfo - disabled due to contour build failure (termbench-pro/glaze issue)
  # environment.enableAllTerminfo = true;
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
