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
        pkgs.via
        pkgs.qmk-udev-rules # For QMK/Via
        pkgs.libsigrok # For pulseview
      ];
    };
    udisks2 = {
      enable = true;
      settings = {
        "mount_options.conf" = {
          defaults = {
            defaults = "noatime";
          };
        };
      };
    };
  };
  boot.supportedFilesystems = ["ntfs"];
  programs.udevil.enable = true;
}
