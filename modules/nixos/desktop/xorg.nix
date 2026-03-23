{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  isWayland = builtins.any (
    var:
      builtins.getEnv var != "" && builtins.getEnv var != "x11"
  ) ["WAYLAND_DISPLAY" "XDG_SESSION_TYPE"];
in {
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
    # Set up X11 services only if we are using an X11 session
    services =
      if !isWayland
      then {
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

          displayManager = {
            lightdm = mkIf config.modules.desktop.xorg.displayManager.lightdm.enable {
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
        };
      }
      else null;

    # Set environment variables only if the wayland module is not enabled
    environment.variables = let
      waylandEnabled = config.modules.desktop.wayland.enable;
    in
      if !waylandEnabled
      then
        if isWayland
        then {
          # Wayland session without wayland module
          GDK_BACKEND = "wayland";
          QT_QPA_PLATFORM = "wayland";
          SDL_VIDEODRIVER = "wayland";
          _JAVA_AWT_WM_NONREPETITIVE = "1";
          # Enable Ozone Wayland for Electron/Chromium
          NIXOS_OZONE_WL = "1";
        }
        else {
          # X11 session without wayland module
          GDK_BACKEND = "x11";
          QT_QPA_PLATFORM = "xcb";
          SDL_VIDEODRIVER = "x11";
          _JAVA_AWT_WM_NONREPETITIVE = "1";
        }
      else null;
  };
}
