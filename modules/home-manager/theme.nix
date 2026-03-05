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
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name = "Materia-dark-compact";
        package = pkgs.materia-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "phinger-cursors-light";
        package = pkgs.phinger-cursors;
        size = 48;
      };
      font = {
        name = "Agave Nerd Font";
        size = 12;
      };
      gtk2.extraConfig = ''
        gtk-application-prefer-dark-theme=1
      '';
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
      style.name = "qt6ct";
    };

    home.sessionVariables = {
      GTK_THEME = "Materia-dark-compact";
    };

    xdg.configFile."fontconfig/fonts.conf".text = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <match target="font">
          <edit name="antialias" mode="assign">
            <bool>true</bool>
          </edit>
          <edit name="hinting" mode="assign">
            <bool>true</bool>
          </edit>
          <edit name="hintstyle" mode="assign">
            <const>hintslight</const>
          </edit>
          <edit name="lcdfilter" mode="assign">
            <const>lcddefault</const>
          </edit>
          <edit name="rgba" mode="assign">
            <const>rgb</const>
          </edit>
        </match>
      </fontconfig>
    '';

    home.file.".icons/default/index.theme".text = ''
      [Icon Theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=phinger-cursors-light
    '';
  };
}
