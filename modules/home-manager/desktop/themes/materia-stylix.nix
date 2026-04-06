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
    gtk = {
      enable = true;
      theme = {
        name = lib.mkForce "Materia-dark-compact";
        package = lib.mkForce pkgs.materia-theme;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Materia-dark-compact";
      };
    };

    home.sessionVariables = {
      GTK_THEME = "Materia-dark-compact";
    };
  };
}
