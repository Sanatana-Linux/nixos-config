{
  pkgs,
  lib,
  ...
}: {
  services.xserver.displayManager = {
    setupCommands = ''
      ${pkgs.xss-lock}/bin/xss-lock -l ${pkgs.multilockscreen} --lock dimblur --span
    '';
    lightdm = {
      enable = true;
      background = ../wallpaper/monokaiprospectrum.png;
      greeters.gtk = {
        enable = true;
        theme = {
          package = lib.mkForce pkgs.orchis-theme;
          name = "Orchis-Grey-Dark-Compact";
        };
        cursorTheme = {
          package = lib.mkForce pkgs.phinger-cursors;
          name = "Phinger Cursors (light)";
          size = 48;
        };
        iconTheme = {
          package = lib.mkForce pkgs.reversal-icon-theme;
          name = "Reversal";
        };
        indicators = ["~session" "~spacer"];
      };
    };
  };
}
