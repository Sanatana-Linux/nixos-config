
{inputs, outputs, pkgs, config}:{     
  service.xserver.displayManager = {
        setupCommands = ''
          ${pkgs.xss-lock}/bin/xss-lock -l ${pkgs.multilockscreen} --lock dimblur --span
        '';
    defaultSession = "none+awesome";
        lightdm = {
          enable = true;
          background = ../../hosts/shared/wallpaper/monokaiprospectrum.png;
          greeters.gtk = {
            enable = true;
            theme = {
              package = pkgs.orchis-theme;
              name = "Orchis-Grey-Dark-Compact";
            };
            cursorTheme = {
              package = pkgs.phinger-cursors;
              name = "Phinger Cursors (light)";
              size = 48;
            };
            iconTheme = {
              package = pkgs.reversal-icon-theme;
              name = "Reversal";
            };
            indicators = ["~session" "~spacer"];

      };
            windowManager.session =
        singleton
        {
          name = "awesome";
          start = ''
            ${pkgs.awesome-git-luajit}/bin/awesome ${makeSearchPath luaModules} &
            waitPID=$!
          '';
        };

        };
      };
}
