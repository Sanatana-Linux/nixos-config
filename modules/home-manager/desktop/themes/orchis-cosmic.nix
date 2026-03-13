{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.orchisCosmic;
in {
  options.modules.desktop.orchisCosmic = {
    enable = mkEnableOption "Orchis-Cosmic desktop theming";
  };

  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    gtk = {
      enable = true;

      font = {
        name = "Agave Nerd Font,  Bold  ";
        size = 10;
      };

      theme = {
        name = "Orchis-Dark";
        package = pkgs.orchis-theme;
      };

      iconTheme = {
        name = "Cosmic";
        package = pkgs.cosmic-icons;
      };

      cursorTheme = {
        name = "Cosmic";
        package = pkgs.cosmic-icons;
        size = 24;
      };

      gtk2.extraConfig = ''
        gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=1
        gtk-menu-images=1
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=1
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgba"
      '';

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "menu:";
        gtk-button-images = "1";
        gtk-menu-images = "1";
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgba";
      };

      gtk4.extraConfig = {
        gtk-decoration-layout = "menu:";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
    };

    home = {
      sessionVariables = {
        GTK_THEME = "Orchis-Grey-Dark-Compact";
      };

      pointerCursor = {
        package = pkgs.cosmic-icons;
        name = "Cosmic";
        size = 24;
        gtk.enable = true;
      };

      packages = with pkgs; [
        nerd-fonts.agave
      ];
    };

    fonts.fontconfig = {
      enable = true;
    };
  };
}
