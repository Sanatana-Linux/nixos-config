{ inputs
, lib
, pkgs
, ...
}: {
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "Rounded Mplus 1c ExtraBold";
      size = 11;
    };
    iconTheme = {
      name = "Fluent-Dark";
      package = pkgs.fluent-icon-theme;
    };
    cursorTheme = {
      name = "Phinger Cursors (light)";
      package = pkgs.phinger-cursors;
      size = 24;
    };

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

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
    };
    theme = {
      name = "Phocus";
      package = pkgs.phocus;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
  home = {
    # maybe the below is more elegant, but it doesn't include the necessary `.git` directory so I can't do any work on the repo, that's useless
    # xdg.configFile."awesome".source = "${inputs.awesome-config}";

    # Enable AwesomeWM Configuration
    activation.installAwesomeWMConfig = ''
      if [ ! -d "$HOME/.config/awesome" ]; then
       ${pkgs.git}/bin/git clone https://github.com/Sanatana-Linux/nixos-awesomewm "$HOME/.config/awesome"
        chmod -R +w "$HOME/.config/awesome"
      fi
    '';
    activation.installNvimConfig = ''
      if [ ! -d "$HOME/.config/nvim" ]; then
       ${pkgs.git}/bin/git clone https://github.com/Thomashighbaugh/nvim-forge "$HOME/.config/nvim"
        chmod -R +w "$HOME/.config/nvim"
      fi
    '';

    file = { ".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors-light"; };
  };
}
