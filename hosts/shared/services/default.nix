{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./pipewire.nix
  ];
  hardware.bluetooth.enable = true;
  xdg.portal.enable = true;
  xdg.portal.config.common.default = "*";
  services = {
    # For Bluetooth
    blueman.enable = true;
    # Mounting Removable Drives
    udisks2.enable = true;
    # monitor and control temparature
    thermald.enable = true;

    # discard blocks that are not in use by the filesystem, good for SSDs
    fstrim.enable = true;
    # firmware updater for machine hardware
    fwupd.enable = true;
    # limit systemd journal size
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    dbus = {
      enable = true;
      packages = with pkgs; [dconf gcr dbus-broker polkit_gnome];
      implementation = "broker"; # lock dbus impl to dbus-broker
    };

    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
    # thumbnails
    tumbler.enable = true;
    # drive mounting
    gvfs.enable = true;

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = lib.mkForce false;
        PermitRootLogin = lib.mkForce "no";
      };
    };

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
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
    libvirtd.enable = true;
  };
}
