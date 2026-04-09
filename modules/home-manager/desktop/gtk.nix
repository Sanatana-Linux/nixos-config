{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.gtk;
in {
  options.modules.desktop.gtk = {
    enable = mkEnableOption "Desktop GTK configuration and Qt integration (use with Stylix for theming)";
    
    # Allow overriding cursor when not using stylix
    cursor = {
      name = mkOption {
        type = types.str;
        default = "phinger-cursors-light";
        description = "Cursor theme name (only used when Stylix is disabled)";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.phinger-cursors;
        description = "Cursor theme package (only used when Stylix is disabled)";
      };
      size = mkOption {
        type = types.int;
        default = 32;
        description = "Cursor size (only used when Stylix is disabled)";
      };
    };
  };

  config = mkIf cfg.enable {
    # Essential GTK and Qt packages for proper theming support
    home.packages = with pkgs; [
      # Qt theme integration packages
      adwaita-qt
      adwaita-qt6
      libsForQt5.qtstyleplugins
      qadwaitadecorations
      qadwaitadecorations-qt6
      
      # Cursor theme package (always install, used by stylix or fallback)
      cfg.cursor.package
    ];

    # GTK Configuration - only settings not handled by Stylix
    gtk = {
      enable = true;

      # GTK2/3/4 specific configurations that Stylix doesn't handle
      gtk2.extraConfig = ''
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

      gtk3.extraConfig = {
        # These settings are typically not handled by Stylix
        gtk-decoration-layout = mkDefault "menu:";
        gtk-button-images = mkDefault "1";
        gtk-menu-images = mkDefault "1";
        gtk-xft-antialias = mkDefault 1;
        gtk-xft-hinting = mkDefault 1;
        gtk-xft-hintstyle = mkDefault "hintslight";
        gtk-xft-rgba = mkDefault "rgba";
      };

      gtk4.extraConfig = {
        gtk-decoration-layout = mkDefault "menu:";
      };

      # Fallback cursor configuration when Stylix is not enabled
      cursorTheme = mkIf (!config.stylix.enable or false) {
        name = cfg.cursor.name;
        package = cfg.cursor.package;
        size = cfg.cursor.size;
      };
    };

    # Pointer cursor configuration - fallback when Stylix is not enabled
    home.pointerCursor = mkIf (!config.stylix.enable or false) {
      package = cfg.cursor.package;
      name = cfg.cursor.name;
      size = cfg.cursor.size;
      gtk.enable = true;
      x11.enable = true;
    };

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

    # Session variables for cursor persistence (when not using Stylix)
    home.sessionVariables = mkIf (!config.stylix.enable or false) {
      XCURSOR_THEME = cfg.cursor.name;
      XCURSOR_SIZE = toString cfg.cursor.size;
    };

    # dconf settings for dark theme preference
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = mkDefault "prefer-dark";
      };
    };
  };
}
