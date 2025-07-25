{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./pipewire.nix
    ./udev.nix
    ./systemd.nix
  ];

  services = {
    # discard blocks that are not in use by the filesystem, good for SSDs
    fstrim.enable = true;
    # firmware updater for machine hardware
    fwupd.enable = true;
    # limit systemd journal size
    journald.extraConfig = ''
      SystemMaxUse=80M
      RuntimeMaxUse=30M
      MaxRetentionSec=7d
    '';

    dbus = {
      enable = true;
      packages = with pkgs; [dconf gcr dbus-broker polkit_gnome];
      implementation = "dbus"; # lock dbus impl to dbus-broker
    };

    # because both gnome-keyring and gnome.gnome-keyring exist
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
  };
}
