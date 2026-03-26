{ config, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.xfce.enable = mkEnableOption "XFCE desktop environment";

  config = mkIf config.modules.desktop.xfce.enable {
    services = {
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = false;
          disableWhileTyping = true;
        };
      };

      xserver = {
        enable = true;
        autorun = true;
        exportConfiguration = true;
        updateDbusEnvironment = true;
        desktopManager.runXdgAutostartIfNone = true;
        desktopManager.xfce.enable = true;

        displayManager.lightdm = {
          enable = true;
          background = ./assets/monokaiprospectrum.png;
          greeters.gtk = {
            enable = true;
            theme = {
              package = pkgs.materia-theme;
              name = "Materia-dark-compact";
            };
            cursorTheme = {
              package = pkgs.phinger-cursors;
              name = "Phinger Cursors (light)";
              size = 48;
            };
            iconTheme = {
              package = pkgs.papirus-icon-theme;
              name = "Papirus-Dark";
            };
            indicators = ["~session" "~spacer" "~power"];
          };
        };
      };

      devmon.enable = true;
      udisks2.enable = true;
      acpid.enable = true;
    };

    environment.variables = {
      GDK_BACKEND = "x11";
      QT_QPA_PLATFORM = mkForce "xcb";
      SDL_VIDEODRIVER = "x11";
      _JAVA_AWT_WM_NONREPENTING = "1";
    };
  };
}
