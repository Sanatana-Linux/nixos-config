{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./pipewire.nix
  ];
  hardware.bluetooth.enable = true;
  services = {
    blueman.enable = true;
    udisks2.enable = true;
    # monitor and control temparature
    thermald.enable = true;
    # handle ACPI events
    acpid.enable = true;
    # discard blocks that are not in use by the filesystem, good for SSDs
    fstrim.enable = true;
    # firmware updater for machine hardware
    fwupd.enable = true;
    # "nix-shell replacement for project development"
    lorri.enable = true;
    # limit systemd journal size
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    dbus = {
      enable = true;
      packages = with pkgs; [dconf gcr];
    };

    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };

    gvfs.enable = true;

    #   openssh = {
    #     enable = true;
    #     settings = {
    #       PasswordAuthentication = lib.mkForce false;
    #       PermitRootLogin = lib.mkForce "no";
    #     };
    #   };

    udev.packages = [pkgs.gnome.gnome-settings-daemon];
  };

  virtualisation = {
    docker = {
      enable = true;
      #      enableOnBoot = true;
    };
    appvm = {
      enable = true;
      user = "tlh";
    };
    libvirtd.enable = true;
  };
}
