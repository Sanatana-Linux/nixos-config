{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.stylix;
in {
  options.modules.stylix = {
    enable = mkEnableOption "Stylix theming at NixOS level";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;

      # Define the Monokai Pro Spectrum theme inline
      base16Scheme = {
        scheme = "Monokai Pro Spectrum";
        author = "Monokai";
        base00 = "#131313";
        base01 = "#191919";
        base02 = "#222222";
        base03 = "#69676c";
        base04 = "#8b888f";
        base05 = "#bab6c0";
        base06 = "#f7f1ff";
        base07 = "#f7f1ff";
        base08 = "#fc618d";
        base09 = "#fd9353";
        base0A = "#fce566";
        base0B = "#7bd88f";
        base0C = "#5ad4e6";
        base0D = "#948ae3";
        base0E = "#948ae3";
        base0F = "#fd9353";
      };

      polarityL = "dark";

      fonts = {
       sizes ={
           terminal = 14;
           desktop = 14;
       };
        serif = {
          package = pkgs.nerd-fonts.agave;
          name = "Agave Nerd Font";
        };
        sansSerif = {
          package = pkgs.nerd-fonts.agave;
          name = "Agave Nerd Font Propo";
        };
        monospace = {
          package = pkgs.nerd-fonts.agave;
          name = "Agave Nerd Font Mono";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
       iconTheme = {
		enable = true;
 		package = pkgs.reversal-icon-theme;
 		light = "Reversal";
 		dark = "Reversal";
	};
      # System-level targets
       targets.grub.enable = mkForce false;  
      targets.plymouth.enable = true;
      targets.console.enable = true;

      # Desktop environment targets
      targets.gtk.enable = true;
      targets.qt.enable = true;
      targets.fontconfig.enable = true;

      # Icon theme
      targets.nixos-icons.enable = true;
    };
  };
}
