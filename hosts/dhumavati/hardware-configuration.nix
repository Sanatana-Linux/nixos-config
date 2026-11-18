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
  # smsc95xx is the Pi 3's onboard LAN9514 Ethernet (a USB-attached chip).
  # Loading it explicitly means the interface shows up even if udev's
  # modalias autoload misses it on a cold boot.
  boot.kernelModules = ["bcm2708_rng" "snd_bcm2835" "smsc95xx"];
  boot.extraModulePackages = [];

  # Root filesystem — ext4 on the SD card. The label is the one the image
  # actually writes: the SD-image module labels partitions from
  # sdImage.rootVolumeLabel / sdImage.firmwarePartitionName, whose defaults are
  # NIXOS_SD and FIRMWARE, and it defines fileSystems at normal priority (which
  # beats mkDefault). Naming the same values here keeps a generation built on the
  # device bootable against the card the image produced — a different label here
  # means initrd waits for a device that does not exist and drops to emergency.
  fileSystems."/" = {
    device = lib.mkDefault "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = ["noatime" "commit=120"];
  };

  # Firmware partition — FAT32, holds Raspberry Pi boot files, U-Boot, and
  # extlinux.conf. Mounted at /boot/firmware for the rpi firmware module.
  fileSystems."/boot/firmware" = {
    device = lib.mkDefault "/dev/disk/by-label/FIRMWARE";
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
