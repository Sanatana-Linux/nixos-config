{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.desktop.xorg = {
    enable = mkEnableOption "X.Org Server and Input configuration";

    displayManager = {
      lightdm = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable LightDM display manager";
        };
      };
    };
  };

  config = mkIf config.modules.desktop.xorg.enable {
    gtk.iconCache.enable = true;

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

        # Without this earlyoom won't start but is not documented anywhere
        desktopManager.runXdgAutostartIfNone = true;

        displayManager = {
          lightdm = mkIf config.modules.desktop.xorg.displayManager.lightdm.enable {
            enable = true;
            background = ../../../assets/wallpaper/monokaiprospectrum.png;
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
      };
    };
  };
}
