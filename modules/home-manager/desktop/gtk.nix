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
    home.packages = with pkgs; [
      adwaita-qt
      adwaita-qt6
      libsForQt5.qtstyleplugins
      qadwaitadecorations
      qadwaitadecorations-qt6
    ];
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

      # Custom CSS for theme color customization
      # This allows overriding theme colors to match Stylix/base16-spectrum
      css = {
        enable = lib.mkDefault true;
        # If set to true, generates a CSS file to override theme colors
        # using the base16-spectrum color palette
        # Colors from base16-spectrum.yaml:
        # base00: "#131313"  # Default Background
        # base01: "#191919"  # Lighter Background
        # base02: "#222222"  # Selection Background
        # base03: "#69676c"  # Comments, Invisible
        # base04: "#8b888f"  # Light Foreground
        # base05: "#bab6c0"  # Default Foreground
        # base06: "#f7f1ff"  # Light Accent Foreground
        # base07: "#f7f1ff"  # Bright Accent Foreground
        # base08: "#fc618d"  # Red
        # base09: "#fd9353"  # Orange
        # base0A: "#fce566"  # Yellow
        # base0B: "#7bd88f"  # Green
        # base0C: "#5ad4e6"  # Cyan
        # base0D: "#948ae3"  # Blue
        # base0E: "#948ae3"  # Magenta
        # base0F: "#fd9353"  # Brown
      };
    };

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

      file = let
        base = {
          "awesome/lib/liblua_pam.so" = { source = "${inputs.lemonake.packages.${pkgs.stdenv.hostPlatform.system}.lua-pam-git}/lib/liblua_pam.so"; };
        };
        cssFiles = if gtk.css.enable then {
          ".config/gtk-3.0/gtk.css" = {
            text = ''
              /* Generated by nixos-config to match base16-spectrum */
              :root {
                color-scheme: dark;
                background-color: #131313;
                color: #bab6c0;
              }
            '';
          };
          ".config/gtk-4.0/gtk.css" = {
            text = ''
              /* Generated by nixos-config to match base16-spectrum */
              :root {
                color-scheme: dark;
                background-color: #131313;
                color: #bab6c0;
              }
            '';
          };
        } else { };
      in
        base // cssFiles;
    };

    # QT Configuration
    qt = {
      enable = true;

      # Set GTK3 as the platform theme for QT
      platformTheme.name = "gtk";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    # Add extra XDG portal for GTK support.
    xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };
}