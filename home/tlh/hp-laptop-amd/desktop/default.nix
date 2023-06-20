{
  inputs,
  lib,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "Asap Condensed, Semi-Bold Condensed";
      size = 10;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Phinger Cursors (light)";
      package = pkgs.phinger-cursors;
      size = 38;
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
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
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
  # maybe the below is more elegant, but it doesn't include the necessary `.git` directory so I can't do any work on the repo, that's useless
  # xdg.configFile."awesome".source = "${inputs.awesome-config}";

  # Enable AwesomeWM Configuration
  home.activation.installAwesomeWMConfig = ''
    if [ ! -d "$HOME/.config/awesome" ]; then
     ${pkgs.git}/bin/git clone https://github.com/Sanatana-Linux/nixos-awesomewm "$HOME/.config/awesome"
      chmod -R +w "$HOME/.config/awesome"
    fi
  '';
  home.file = {".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors";};
}
