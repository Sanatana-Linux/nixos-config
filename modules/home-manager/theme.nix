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
    home.packages = with pkgs; [
      colloid-icon-theme
      emacs-all-the-icons-fonts
      nerd-fonts.agave # Retain existing font just in case
      # Note: Operator fonts are assumed to be available or manually installed if not in nixpkgs
    ];

    gtk = {
      enable = true;
      theme = {
        name = "Skeuos-Grey-Dark";
        package = pkgs.skeuos-gtk;
      };
      iconTheme = {
        name = "Colloid-Dark";
        package = pkgs.colloid-icon-theme;
      };
      cursorTheme = {
        name = "phinger-cursors-light";
        package = pkgs.phinger-cursors;
        size = 48;
      };
      font = {
        name = "OperatorUltra Nerd Font Propo";
        size = 12;
      };
      gtk2.extraConfig = ''
        gtk-application-prefer-dark-theme=1
        gtk-font-name="OperatorUltra Nerd Font Propo 12"
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
        gtk-application-prefer-dark-theme = 1;
        gtk-font-name = "OperatorUltra Nerd Font Propo 12";
        gtk-decoration-layout = "menu:";
        gtk-button-images = 1;
        gtk-menu-images = 1;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgba";
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-font-name = "OperatorUltra Nerd Font Propo 12";
        gtk-decoration-layout = "menu:";
      };
    };

    home.pointerCursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 48;
      gtk.enable = true;
      x11.enable = true;
    };

    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
      style.name = "kvantum";
    };

    home.sessionVariables = {
      GTK_THEME = "Skeuos-Grey-Dark";
    };

    xdg.configFile."fontconfig/fonts.conf".text = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <match target="pattern">
          <test qual="any" name="family">
            <string>serif</string>
          </test>
          <edit name="family" mode="prepend" binding="strong">
            <string>OperatorUltra Nerd Font Propo</string>
          </edit>
        </match>
        <match target="pattern">
          <test qual="any" name="family">
            <string>sans-serif</string>
          </test>
          <edit name="family" mode="prepend" binding="strong">
            <string>OperatorUltra Nerd Font Propo</string>
          </edit>
        </match>
        <match target="pattern">
          <test qual="any" name="family">
            <string>monospace</string>
          </test>
          <edit name="family" mode="prepend" binding="strong">
            <string>Operator Mono Lig</string>
            <string>all-the-icons</string>
          </edit>
        </match>
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
