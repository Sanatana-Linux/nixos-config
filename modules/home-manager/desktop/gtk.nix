{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = mkEnableOption "Desktop theming and configuration (GTK, Qt, cursors, fonts)";
  };

  config = mkIf cfg.enable {
    # GTK Configuration
    gtk = {
      enable = true;

      # Font settings for GTK
      font = {
        name = lib.mkDefault "SFProText Nerd Font,  Bold  ";
        size = lib.mkDefault 10;
      };

      # GTK theme configuration
      theme = {
        name = lib.mkDefault "Materia-dark-compact";
        package = lib.mkDefault pkgs.materia-theme-transparent;
      };

      # GTK icon theme configuration
      iconTheme = {
        name = lib.mkDefault "Papirus-Dark";
        package = lib.mkDefault pkgs.papirus-icon-theme;
      };

      # GTK cursor theme configuration
      cursorTheme = {
        name = lib.mkDefault "Phinger Cursors (light)";
        package = lib.mkDefault pkgs.phinger-cursors;
        size = lib.mkDefault 48;
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
        gtk-application-prefer-dark-theme = lib.mkDefault true;
        gtk-decoration-layout = lib.mkDefault "menu:";
        gtk-button-images = lib.mkDefault "1";
        gtk-menu-images = lib.mkDefault "1";
        gtk-xft-antialias = lib.mkDefault 1;
        gtk-xft-hinting = lib.mkDefault 1;
        gtk-xft-hintstyle = lib.mkDefault "hintslight";
        gtk-xft-rgba = lib.mkDefault "rgba";
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
      platformTheme.name = "gtk";
    };

    # ─────────────────────────────────────────────────────────────────

    # Home configuration
    home = {
      # Environment variables for session
      sessionVariables = {
        GTK_THEME = lib.mkDefault "Materia-dark-compact";
      };

      # Pointer cursor configuration
      pointerCursor = {
        package = lib.mkDefault pkgs.phinger-cursors;
        name = lib.mkDefault "Phinger Cursors (light)";
        size = lib.mkDefault 48;
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

      file = {
        "awesome/lib/liblua_pam.so" = {source = "${inputs.lemonake.packages.${pkgs.stdenv.hostPlatform.system}.lua-pam-git}/lib/liblua_pam.so";};
      };
    };

    fonts.fontconfig = {
      enable = true;
    };
    # Add extra XDG portal for GTK support.
    xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };
}
