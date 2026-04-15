{pkgs}: let
  litarvan-theme = pkgs.callPackage ./lightdm-webkit-theme-litarvan.nix {};
  # Use local assets from modules/nixos/desktop/assets instead of external package
  local-assets = pkgs.stdenv.mkDerivation {
    pname = "local-desktop-assets";
    version = "1.0";

    src = ../modules/nixos/desktop/assets;

    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out/ 2>/dev/null || true
    '';
  };
in
  pkgs.callPackage ./sea-greeter.nix {
    theme = litarvan-theme;
    backgrounds = local-assets;
    enableHWAcceleration = false;
  }
