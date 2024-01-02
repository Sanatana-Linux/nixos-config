{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.wayland;
in {
  options.tlh.wayland = {
    enable = mkEnableOption "activate wayland";
  };

  config = mkIf cfg.enable {
    # xdg-desktop-portal works by exposing a series of D-Bus interfaces
    # known as portals under a well-known name
    # (org.freedesktop.portal.Desktop) and object path
    # (/org/freedesktop/portal/desktop).
    # The portal interfaces include APIs for file access, opening URIs,
    # printing and others.
    services.dbus.enable = true;
    xdg = {
      mime.enable = true;
      icons.enable = true;
      portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
      };
    };

    programs.light.enable = true;

    security = {
      # Allow swaylock to unlock the computer for us
      pam.services.swaylock.text = "auth include login";
      polkit.enable = true;
      rtkit.enable = true;
    };

    users.extraUsers.tlh.extraGroups = ["video" "audio"];

    hardware = {
      # fixes'ÈGL_EXT_platform_base not supported'
      opengl.enable = true;
      # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
      # Dont have nvidia lol
    };
  };
}
