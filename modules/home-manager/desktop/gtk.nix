{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.gtk;
in {
  options.modules.desktop.gtk = {
    enable = mkEnableOption "Desktop GTK configuration and Qt integration (use with Stylix for theming)";

    # Allow overriding cursor theme even with stylix enabled
    cursor = {
      name = mkOption {
        type = types.str;
        default = "phinger-cursors-light";
        description = "Cursor theme name (forced override even with Stylix)";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.phinger-cursors;
        description = "Cursor theme package (forced override even with Stylix)";
      };
      size = mkOption {
        type = types.int;
        default = 32;
        description = "Cursor size (forced override even with Stylix)";
      };
    };
  };

  config = mkIf cfg.enable {
    # Essential GTK and Qt packages for proper theming support
    home.packages = with pkgs; [
      # Theme packages
      gnome-themes-extra
      colloid-icon-theme

      # Libadwaita and schema support packages
      libadwaita
      gsettings-desktop-schemas
      adwaita-icon-theme # Essential for libadwaita apps
      hicolor-icon-theme # Icon theme fallback
      kdePackages.breeze-icons # Colloid fallback icons

      # Qt theme integration packages
      adwaita-qt
      adwaita-qt6
      libsForQt5.qtstyleplugins
      qadwaitadecorations
      qadwaitadecorations-qt6

      # Cursor theme package (always install, used by stylix or fallback)
      cfg.cursor.package
    ];

    # GTK Configuration - sharabha-gtk-theme (skeuomorphic dark, matches Sanatana palette)
    gtk = {
      enable = true;

      # sharabha-gtk-theme - matches the Sanatana Linux base16 palette used by Stylix
      theme = mkForce {
        name = "sharabha-gtk-theme";
        package = inputs.sharabha-gtk.packages.${pkgs.system}.default;
      };

      # Force icon theme
      iconTheme = mkForce {
        name = "Colloid-dark";
        package = pkgs.colloid-icon-theme;
      };

      # Force cursor theme (override stylix)
      cursorTheme = mkForce {
        name = cfg.cursor.name;
        package = cfg.cursor.package;
        size = cfg.cursor.size;
      };

      # Explicitly set GTK4 theme preference but allow libadwaita override
      gtk4.theme = mkDefault {
        name = "sharabha-gtk-theme";
        package = inputs.sharabha-gtk.packages.${pkgs.system}.default;
      };

      # GTK2 configuration
      gtk2.extraConfig = ''
        gtk-theme-name="sharabha-gtk-theme"
        gtk-icon-theme-name="Colloid-dark"
        gtk-cursor-theme-name="${cfg.cursor.name}"
            gtk-cursor-theme-size=${toString cfg.cursor.size}
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

      # GTK3 configuration
      gtk3.extraConfig = {
        gtk-theme-name = mkForce "sharabha-gtk-theme";
        gtk-icon-theme-name = mkForce "Colloid-dark";
        gtk-cursor-theme-name = mkForce cfg.cursor.name;
        gtk-cursor-theme-size = mkForce cfg.cursor.size;
        gtk-decoration-layout = mkDefault "menu:";
        gtk-button-images = mkDefault "1";
        gtk-menu-images = mkDefault "1";
        gtk-xft-antialias = mkDefault 1;
        gtk-xft-hinting = mkDefault 1;
        gtk-xft-hintstyle = mkDefault "hintslight";
        gtk-xft-rgba = mkDefault "rgba";
      };

      # GTK4 configuration - allow libadwaita apps to use native theming
      gtk4.extraConfig = {
        # Use default for libadwaita apps, Materia for others
        gtk-decoration-layout = mkDefault "menu:";
        gtk-enable-animations = mkDefault true;
      };
    };

    # Environment variables for GTK theme and cursor theme
    home.sessionVariables = {
      # Use sharabha-gtk-theme for most GTK apps, but allow libadwaita apps to override
      GTK_THEME = mkDefault "sharabha-gtk-theme";
      # Ensure proper schema loading for GSettings/dconf
      GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
      # Allow libadwaita apps to use native theming
      ADW_DISABLE_PORTAL = "0";
    };

    # Force cursor theme environment variables (override stylix)
    home.sessionVariables.XCURSOR_THEME = mkForce cfg.cursor.name;
    home.sessionVariables.XCURSOR_SIZE = mkForce (toString cfg.cursor.size);

    # Force pointer cursor configuration (override stylix cursor handling)
    home.pointerCursor = mkForce {
      enable = true;
      package = cfg.cursor.package;
      name = cfg.cursor.name;
      size = cfg.cursor.size;
      gtk.enable = true;
      x11.enable = true;
    };

    # Ensure X11 can find cursor files — Xcursor doesn't reliably follow Inherits=
    # in index.theme, so we symlink the cursors directory into the default theme
    home.activation.fixCursorSymlinks = hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD ln -sfn ${cfg.cursor.package}/share/icons/${cfg.cursor.name}/cursors $VERBOSE_ARG \
        ~/.icons/default/cursors
    '';

    # Qt Configuration - force consistent theming
    qt = {
      enable = true;
      # Use GTK theme for Qt when Stylix is not handling it
      platformTheme.name = mkIf (!config.stylix.enable or false) "gtk";
      style = mkIf (!config.stylix.enable or false) {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    # Desktop integration - ensure GTK portal is available
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    # dconf settings for dark theme preference and cursor theme
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = mkDefault "sharabha-gtk-theme";
        icon-theme = mkDefault "Colloid-dark";
        color-scheme = mkForce "prefer-dark";
        # Force cursor theme in GNOME/GTK settings
        cursor-theme = mkForce cfg.cursor.name;
        cursor-size = mkForce cfg.cursor.size;
        # Ensure icon theme fallbacks work properly
        gtk-enable-animations = mkDefault true;
      };

      # Ensure libadwaita apps can access their styling
      "org/gnome/desktop/wm/preferences" = {
        button-layout = mkDefault "appmenu:minimize,maximize,close";
      };
    };
  };
}
