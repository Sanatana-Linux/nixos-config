{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.materiaStylix;
in {
  options.modules.desktop.materiaStylix = {
    enable = mkEnableOption "Materia GTK theme (dark compact variant)";
  };

  config = mkIf cfg.enable {
    # Install cursor theme package
    home.packages = [
      pkgs.phinger-cursors
    ];

    gtk = {
      enable = true;
      theme = {
        name = lib.mkForce "Materia-dark-compact";
        package = lib.mkForce pkgs.materia-theme;
      };
      # Force cursor theme configuration in GTK
      cursorTheme = {
        name = lib.mkForce "phinger-cursors-light";
        package = lib.mkForce pkgs.phinger-cursors;
        size = lib.mkForce 32;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-cursor-theme-name = "phinger-cursors-light";
        gtk-cursor-theme-size = 32;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    # Force Home Manager pointer cursor configuration
    home.pointerCursor = {
      package = lib.mkForce pkgs.phinger-cursors;
      name = lib.mkForce "phinger-cursors-light";
      size = lib.mkForce 32;
      gtk.enable = lib.mkForce true;
      x11.enable = lib.mkForce true;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Materia-dark-compact";
        cursor-theme = "phinger-cursors-light";
        cursor-size = 32;
      };
    };

    home.sessionVariables = {
      GTK_THEME = "Materia-dark-compact";
      # Force X11 cursor theme environment variables for persistence
      XCURSOR_THEME = "phinger-cursors-light";
      XCURSOR_SIZE = "32";
    };

    # Create .Xdefaults file for additional X11 cursor persistence
    home.file.".Xdefaults".text = ''
      Xcursor.theme: phinger-cursors-light
      Xcursor.size: 32
    '';
  };
}
