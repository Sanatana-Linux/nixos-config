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

      base16Scheme = "${./../../../external/base16_monokai_pro/base16-spectrum.yaml}";

      polarity = "dark";

      fonts = {
        sizes = {
          terminal = 14;
          desktop = 14;
        };
        serif = {
          package = pkgs.emptyDirectory;
          name = "Operator SSm";
        };
        sansSerif = {
          package = pkgs.emptyDirectory;
          name = "OperatorUltraNerdFontComplete Nerd Font Propo";
        };
        monospace = {
          package = pkgs.emptyDirectory;
          name = "OperatorMono Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
      icons = {
        enable = true;
        package = pkgs.honor-icon-theme;
        light = "Honor-grey";
        dark = "Honor-grey-dark";
      };

      # System-level targets
      targets.grub.enable = mkForce false;
      targets.plymouth.enable = mkForce false; # Disabled in favor of custom theme
      targets.console.enable = true;

      # Desktop environment targets - just enable GTK, theme will be overridden by home-manager
      targets.gtk.enable = true;

      targets.qt.enable = true;
      targets.qt.platform = "qtct";
      targets.fontconfig.enable = true;

      # Icon theme
      targets.nixos-icons.enable = true;
    };

    # Ensure materia-theme is available system-wide
    environment.systemPackages = with pkgs; [
      materia-theme
      honor-icon-theme
    ];
  };
}
