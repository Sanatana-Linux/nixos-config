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
      name = "Agave Nerd Font,  Bold  ";
      size = 10;
    };

    # GTK theme configuration
    theme = {
      name = "Nightfox-Dark";
      package = pkgs.nightfox-gtk-theme;
    };

    # GTK icon theme configuration
    iconTheme = {
      name = "Cosmic";
      package = pkgs.cosmic-icons;
    };

    # GTK cursor theme configuration
    cursorTheme = {
      name = "Cosmic";
      package = pkgs.cosmic-icons;
      size = 24;
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
    platformTheme.name = "gtk3";
  };

  # ─────────────────────────────────────────────────────────────────

  # Home configuration
  home = {
    # Environment variables for session
    sessionVariables = {
      GTK_THEME = "Orchis-Grey-Dark-Compact";
      QT_QPA_PLATFORMTHEME = "gtk3";
    };

    # Pointer cursor configuration
    pointerCursor = {
      package = pkgs.cosmic-icons;
      name = "Cosmic";
      size = 24;
      gtk.enable = true;
    };

    # File configuration for icon theme
    #    file = {
    #      ".icons/default".source = "${pkgs.cosmic-icons}/share/icons/cosmic-icons";
    #    };
  };

  fonts.fontconfig = {
    enable = true;
  };
}
