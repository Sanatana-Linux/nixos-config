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
      name = "Liga SFMono Nerd Font Semibold";
      size = 11;
    };

    # GTK theme configuration
    theme = {
      name = "Orchis-Grey-Dark-Compact";
      package = pkgs.orchis-theme;
    };

    # GTK icon theme configuration
    iconTheme = {
      name = "Reversal";
      package = pkgs.reversal-icon-theme;
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
      package = pkgs.phinger-cursors;
      name = "Phinger Cursors (light)";
      size = 48;
      gtk.enable = true;
    };

    # Installation of AwesomeWM configuration if not present
    activation.installAwesomeWMConfig = ''
      if [ ! -d "${config.home.homeDirectory}/.config/awesome" ]; then
        ${pkgs.git}/bin/git clone https://github.com/Sanatana-Linux/nixos-awesomewm "${config.home.homeDirectory}/.config/awesome"
        chmod -R +w "${config.home.homeDirectory}/.config/awesome"
        chown -R tlh "${config.home.homeDirectory}/.config/awesome"
      fi
    '';

    # Installation of Neovim configuration if not present
    activation.installNvimConfig = ''
      if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
        ${pkgs.git}/bin/git clone https://github.com/Thomashighbaugh/nvim-forge "${config.home.homeDirectory}/.config/nvim"
        chmod -R +w "$HOME/.config/nvim"
        chown -R tlh "${config.home.homeDirectory}/.config/nvim"
      fi
    '';

    # File configuration for icon theme
    file = {
      ".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors-light";
    };
  };
}
