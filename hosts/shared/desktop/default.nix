{pkgs, ...}: {
  gtk.iconCache.enable = true;
  services = {
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = false;
        disableWhileTyping = true;
      };
    }; #ends libinput

    xserver = {
      enable = true;
      autorun = true;
      exportConfiguration = true;
      updateDbusEnvironment = true;
      desktopManager.runXdgAutostartIfNone = true; # Without this earlyoom won't start but is not documented anywhere
      displayManager = {
        lightdm = {
          enable = true;
          background = ../wallpaper/monokaiprospectrum.png;
          greeters.gtk = {
            enable = false; # Disabled in favor of sea-greeter
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
            indicators = ["~session" "--spacer" "~power"];
          };
          # Sea-greeter configuration - webkit2gtk-based greeter themed with web technologies
          greeters.sea = {
            enable = true;
            background = "${../wallpaper/monokaiprospectrum.png}";
            theme.name = "gruvbox";
            debug = false;
            detectThemeErrors = true;
            screensaverTimeout = 300;
            secureMode = true;
          };
        };
      }; # ends displayManager not xserver
    }; # ends xserver
  }; # ends services
}
