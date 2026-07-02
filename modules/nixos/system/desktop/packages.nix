{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.desktop.packages;
in {
  options.modules.system.desktop.packages = {
    x11 = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "X11 display server utilities and tools";
      };
    };
    wayland = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Wayland display server utilities and tools";
      };
    };
  };

  config = {
    environment.systemPackages = with pkgs;
      optionals cfg.x11.enable [
        xinit
        xrdb
        xhost
        xscreensaver
        xsecurelock
        xss-lock
        xsuspender
        xprop
        xwininfo
        xev
        xfontsel
        xrandr
        arandr
        xclip
        xdotool
        xbacklight
        xkill
      ]
      ++ optionals cfg.wayland.enable [
        wlr-randr
        wdisplays
        waypipe
        xdg-desktop-portal-wlr
        wl-mirror
        wlroots
        waybar
        wofi
        fuzzel
        wlogout
        grim
        slurp
        gpick
        cliphist
        brightnessctl
        libinput
        libinput-gestures
        wtype
        wev
      ];
  };
}
