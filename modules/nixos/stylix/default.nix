{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.stylix;
  base16SchemePath = "/home/tlh/nixos/modules/base16/base16-spectrum.yaml";
in
{
  options.modules.stylix = {
    enable = mkEnableOption "Stylix theming at NixOS level";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = base16SchemePath;
      polarity = "dark";

      fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        monospace = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans Mono";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };

      targets.grub.enable = true;
      targets.plymouth.enable = true;
    };
  };
}
