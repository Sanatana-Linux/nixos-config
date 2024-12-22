{
  pkgs,
  config,
  ...
}: {
  services = {
    udev = {
      enable = true;
      packages = [
        pkgs.gnome-settings-daemon
        pkgs.xsettingsd
        pkgs.xfce.xfce4-settings
        pkgs.logitech-udev-rules # for logitech
        pkgs.android-udev-rules
      ];
    };
    udiskie = {
      enable = true;
      automount = true;
      tray = "never";
      notify = true;
    };
  };
  programs.udevil.enable = true;
}
