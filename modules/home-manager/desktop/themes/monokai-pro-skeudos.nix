{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.monokaiProSkeudos;
in {
  options.modules.desktop.monokaiProSkeudos = {
    enable = mkEnableOption "Monokai Pro Skeuos desktop theming";
  };

  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    home.packages = with pkgs; [
      colloid-icon-theme
      emacs-all-the-icons-fonts
      pkgs.skeuos-gtk
    ];

    gtk = {
      enable = true;
      theme = {
        name = "Skeuos-Grey-Dark";
        package = pkgs.skeuos-gtk;
      };
      iconTheme = {
        name = "Colloid-Dark";
        package = pkgs.colloid-icon-theme;
      };
    };

    home.pointerCursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 48;
      gtk.enable = true;
      x11.enable = true;
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["OperatorUltra Nerd Font Propo" "FreeSerif"];
        sansSerif = ["OperatorUltra Nerd Font Propo" "Ubuntu Nerd Font Medium"];
        monospace = ["Operator Mono Lig" "Ubuntu Nerd Font Mono"];
      };
    };
  };
}
