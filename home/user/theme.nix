{
  pkgs,
  config,
  ...
}: {
  gtk = {
    enable = true;
    font = {
      name = "Agave Nerd Font Propo";
      size = 12;
    };
    theme = {
      name = "Materia-dark-compact";
      package = pkgs.materia-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Phinger Cursors (light)";
      package = pkgs.phinger-cursors;
      size = 48;
    };
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      extraConfig = ''
        gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=1
        gtk-menu-images=1
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintslight
        gtk-xft-rgba=rgb
      '';
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "menu:";
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-decoration-layout = "menu:";
      };
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
  };

  home.sessionVariables = {
    GTK_THEME = "Materia-dark-compact";
  };

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 48;
    gtk.enable = true;
  };

  home.file.".icons/default" = {
    source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors-light";
  };

  fonts.fontconfig.enable = true;
}
