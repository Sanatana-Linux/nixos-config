{
  config,
  pkgs,
  ...
}: {
  boot.supportedFilesystems = ["zfs"];
  networking.hostId = "4a0aede8";
  boot.zfs.devNodes = "/dev/disk/by-id";
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  swapDevices = [
    { device = "/dev/disk/by-id/nvme-SKHynix_HFS001TEJ9X115N_AMD1N001811901C38_1-part4"; randomEncryption.enable = true; }
    { device = "/dev/disk/by-id/nvme-SKHynix_HFS001TEJ9X115N_AMD1N001812601C3I_1-part4"; randomEncryption.enable = true; }
  ];
  systemd.services.zfs-mount.enable = false;
  environment.etc."machine-id".source = "/state/etc/machine-id";
  environment.etc."zfs/zpool.cache".source = "/state/etc/zfs/zpool.cache";
  boot.loader.efi.efiSysMountPoint = "/boot/efis/nvme-SKHynix_HFS001TEJ9X115N_AMD1N001811901C38_1-part1";

  # boot loader specific config
  boot.loader.efi.canTouchEfiVariables = false;

  boot.loader = {
    generationsDir.copyKernels = true;
    # for problematic UEFI firmware
    grub.efiInstallAsRemovable = true;
    grub.enable = true;
    grub.version = 2;
    grub.copyKernels = true;
    grub.efiSupport = true;
    grub.zfsSupport = true;
    # for systemd-autofs
    grub.extraPrepareConfig = ''
      mkdir -p /boot/efis
      for i in /boot/efis/*; do mount $i ; done
    '';
    grub.extraInstallCommands = ''
      export ESP_MIRROR=$(mktemp -d -p /tmp)
      cp -r /boot/efis/nvme-SKHynix_HFS001TEJ9X115N_AMD1N001811901C38_1-part1/EFI $ESP_MIRROR
      for i in /boot/efis/*; do
        cp -r $ESP_MIRROR/EFI $i
      done
      rm -rf $ESP_MIRROR
    '';
    grub.devices = [
      "/dev/disk/by-id/nvme-SKHynix_HFS001TEJ9X115N_AMD1N001811901C38_1"
      "/dev/disk/by-id/nvme-SKHynix_HFS001TEJ9X115N_AMD1N001812601C3I_1"
    ];
  };

  users.users.root.initialHashedPassword = "$6$HufEFWjLszB/ymUM$U3Ow/ibzX7ORIjOSzAbjCz/AQ7IbQVxHnOlrPkmMdPK6b/ylW67asnPlUILiNgm6m6WKdu40Jd2fWuT4ziYcs1";
}

