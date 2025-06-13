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

      displayManager = {
        lightdm = {
          enable = true;
          background = ../wallpaper/monokaiprospectrum.png;
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
            indicators = ["~session" "--spacer" "~power"];
          };
        };
      }; # ends displayManager not xserver
    }; # ends xserver
  }; # ends services
}
