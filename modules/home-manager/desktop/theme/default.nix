{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.theme;
in {
  options.modules.theme = {
    enable = mkEnableOption "user theme configuration with GTK, Qt, cursor, and font theming";

    fonts = {
      packages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "List of font packages to install";
      };
      serif = mkOption {
        type = types.listOf types.str;
        default = ["FreeSerif"];
        description = "Serif font families";
      };
      sansSerif = mkOption {
        type = types.listOf types.str;
        default = ["Ubuntu Nerd Font Medium"];
        description = "Sans-serif font families";
      };
      monospace = mkOption {
        type = types.listOf types.str;
        default = ["Ubuntu Nerd Font Mono"];
        description = "Monospace font families";
      };
      sizes = {
        applications = mkOption {
          type = types.int;
          default = 12;
          description = "Font size for applications";
        };
        terminal = mkOption {
          type = types.int;
          default = 12;
          description = "Font size for terminal";
        };
        desktop = mkOption {
          type = types.int;
          default = 12;
          description = "Font size for desktop";
        };
      };
    };

    gtk = {
      theme = {
        name = mkOption {
          type = types.str;
          description = "GTK theme name";
        };
        package = mkOption {
          type = types.package;
          description = "GTK theme package";
        };
      };
      iconTheme = {
        name = mkOption {
          type = types.str;
          description = "GTK icon theme name";
        };
        package = mkOption {
          type = types.package;
          description = "GTK icon theme package";
        };
      };
    };

    cursor = {
      name = mkOption {
        type = types.str;
        default = "phinger-cursors-light";
        description = "Cursor theme name";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.phinger-cursors;
        description = "Cursor theme package";
      };
      size = mkOption {
        type = types.int;
        default = 48;
        description = "Cursor size";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      cfg.fonts.packages
      ++ [
        cfg.gtk.theme.package
        cfg.gtk.iconTheme.package
        cfg.cursor.package
        pkgs.adwaita-qt
        pkgs.adwaita-qt6
      ];

    gtk = {
      enable = true;
      theme = {
        name = cfg.gtk.theme.name;
        package = cfg.gtk.theme.package;
      };
      iconTheme = {
        name = cfg.gtk.iconTheme.name;
        package = cfg.gtk.iconTheme.package;
      };
      cursorTheme = {
        name = cfg.cursor.name;
        package = cfg.cursor.package;
        size = cfg.cursor.size;
      };
      font = {
        name = head cfg.fonts.sansSerif;
        size = cfg.fonts.sizes.applications;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "menu:";
        gtk-button-images = 1;
        gtk-menu-images = 1;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgba";
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "menu:";
      };
    };

    home.pointerCursor = {
      package = cfg.cursor.package;
      name = cfg.cursor.name;
      size = cfg.cursor.size;
      gtk.enable = true;
      x11.enable = true;
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "adwaita-dark";
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    home.sessionVariables = {
      GTK_THEME = cfg.gtk.theme.name;
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = cfg.fonts.serif;
        sansSerif = cfg.fonts.sansSerif;
        monospace = cfg.fonts.monospace;
      };
    };
  };
}
