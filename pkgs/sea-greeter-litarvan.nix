{ pkgs }:

let
  litarvan-theme = pkgs.callPackage ./lightdm-webkit-theme-litarvan.nix {};
  nature-images = pkgs.callPackage ./various-nature-images.nix {};
in
  pkgs.callPackage ./sea-greeter.nix {
    theme = litarvan-theme;
    backgrounds = nature-images;
    enableHWAcceleration = false;
  }