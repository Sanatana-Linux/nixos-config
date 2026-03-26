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

      theme = {
        name = lib.mkDefault "Materia-dark-compact";
        package = lib.mkDefault pkgs.materia-theme-transparent;
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
      gtk4.theme = config.gtk.theme;
      # GTK4 specific configurations
      gtk4.extraConfig = {
        # gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "menu:";
      };
    };

    # nixCraftHome configuration
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
    };
    
    
    # QT Configuration
    qt = {
      enable = true;

      style = {
        name = lib.mkForce "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    # Add extra XDG portal for GTK support.
    xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };
}
