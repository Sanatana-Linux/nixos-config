{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [];

  # Raspberry Pi 3 boot modules — the BCM2837 needs these early for storage/USB.
  boot.initrd.availableKernelModules = ["dwc2" "usbhid" "usb_storage" "bcm2708_rng"];
  boot.initrd.kernelModules = ["dwc2" "usbhid" "usb_storage" "bcm2708_rng"];
  boot.kernelModules = ["bcm2708_rng" "snd_bcm2835"];
  boot.extraModulePackages = [];

  # Root filesystem — ext4 on the SD card. UUID/label to be regenerated on
  # the target machine with `nixos-generate-config --show-hardware-config`.
  fileSystems."/" = {
    device = "/dev/disk/by-label/rpi3-root";
    fsType = "ext4";
    options = ["noatime" "commit=120"];
  };

  # Firmware partition — FAT32, holds Raspberry Pi boot files, U-Boot, and
  # extlinux.conf. Mounted at /boot/firmware for the rpi firmware module.
  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-label/rpi3-firmware";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  # zram is enabled in default.nix; no swap partition on a 32GB SD card.
  swapDevices = [];

  nixpkgs.system = lib.mkDefault "aarch64-linux";

  # No CPU microcode on the Pi — Broadcom BCM2837, not Intel/AMD.
  hardware.cpu.intel.updateMicrocode = lib.mkDefault false;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault false;

  virtualisation.hypervGuest.enable = lib.mkDefault false;
  virtualisation.vmware.guest.enable = lib.mkDefault false;
  virtualisation.podman.enable = lib.mkDefault false;
}
