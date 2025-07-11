{
  pkgs,
  config,
  ...
}: {
  # GTK Configuration
  gtk = {
    enable = true;

    # Font settings for GTK
    font = {
      name = "Agave Nerd Font Propo";
      size = 12;
    };

    # GTK theme configuration
    theme = {
      name = "Materia-dark-compact";
      package = pkgs.materia-theme;
    };

    # GTK icon theme configuration
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    # GTK cursor theme configuration
    cursorTheme = {
      name = "Phinger Cursors (light)";
      package = pkgs.phinger-cursors;
      size = 48;
    };

    # GTK2 specific configurations
    gtk2 = {
      extraConfig = ''
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
    };

    # GTK3 specific configurations
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

    # GTK4 specific configurations
    gtk4.extraConfig = {
      # gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
    };
  };

  # QT Configuration
  qt = {
    enable = true;

    # Set GTK3 as the platform theme for QT
    platformTheme.name = "qt6ct";
  };

  # ─────────────────────────────────────────────────────────────────

  # Home configuration
  home = {
    # Environment variables for session
    sessionVariables = {
      GTK_THEME = "Materia-dark-compact";
      #  GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache";
      # XDG_DATA_DIRS = "${pkgs.materia-theme-transparent}/share:$XDG_DATA_DIRS";
    };

    # Pointer cursor configuration
    pointerCursor = {
      package = pkgs.phinger-cursors;
      name = "Phinger Cursors (light)";
      size = 48;
      gtk.enable = true;
    };

    # File configuration for icon theme
    file = {
      ".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors-light";
    };
  };

  fonts.fontconfig = {
    enable = true;
  };
}
