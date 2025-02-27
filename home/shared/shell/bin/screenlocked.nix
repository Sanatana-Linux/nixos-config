{pkgs}:
with pkgs;
  writeScriptBin "screenlocked" ''
        #!/usr/bin/env bash
      # Creates the lock screen, with the necessar
      # commands to set the wallpaper

    ${pkgs.betterlockscreen}/bin/betterlockscreen -l /etc/nixos/hosts/shared/wallpaper/monokaiprospectrum.png
  ''
