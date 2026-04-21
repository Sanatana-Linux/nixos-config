{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_blk" "sr_mod" "virtio_net"];
  boot.initrd.kernelModules = ["virtio_pci" "virtio_blk" "virtio_net" "virtio_console"];
  boot.kernelModules = ["kvm-intel" "virtio_balloon" "virtio_console" "virtio_rng"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = ["noatime" "nodiratime" "discard"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [
    {device = "/dev/disk/by-label/swap";}
  ];

  nixpkgs.system = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  virtualisation.hypervGuest.enable = lib.mkDefault false;
  virtualisation.vmware.guest.enable = lib.mkDefault false;
  virtualisation.podman.enable = lib.mkDefault false;
}
