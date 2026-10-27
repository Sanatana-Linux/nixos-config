{
  inputs,
  lib,
  modulesPath,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
    (modulesPath + "/profiles/all-hardware.nix")
    (modulesPath + "/profiles/base.nix")
    (modulesPath + "/installer/scan/detected.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
    ./sops.nix
    ../../modules/nixos/system/users/user.nix
  ];

  # Overlays stay declared because modules resolve attributes through them;
  # they add nothing to the closure unless something actually uses them.
  nixpkgs.overlays = [
    inputs.nur.overlays.default
    # llm-agents packages under the llm-agents namespace, built against this
    # repo's pinned nixpkgs (binaries substitute from cache.numtide.com).
    inputs.llm-agents.overlays.shared-nixpkgs
  ];

  nixpkgs.config.allowUnfree = true;

  # A live installer, not a desktop: the awesome configuration, zsh, and the
  # tooling needed to partition and install. Everything else is left out so the
  # image stays small and boots quickly.
  modules = {
    system = {
      systemd.enable = true;
      boot = {
        enable = true;
        theme.enable = true;
      };
      networking = {
        enable = true;
        hostName = "chhinamasta";
      };
      desktop.awesomewm.enable = true;
      security.sudo.enable = true;
    };

    base = {
      enable = true;
      fonts.enable = true;
      timezone = "America/New_York";
      nix.enable = true;
      services = {
        enable = true;
        fstrim.enable = false;
        fwupd.enable = false;
      };
      shell = {
        enable = true;
        zsh = true;
        variables.enable = true;
      };
    };

    users.user.enable = true;

    hardware.udev.enable = true;

    stylix.enable = true;
  };

  services.xserver.enable = true;
  services.displayManager.defaultSession = "none+awesome";

  # disko drives the partitioning; the rest are the userspace halves of the
  # filesystems and volume stacks the hosts use, plus nixos-install itself.
  environment.systemPackages = with pkgs; [
    disko
    nixos-install-tools
    parted
    gptfdisk
    dosfstools
    e2fsprogs
    btrfs-progs
    xfsprogs
    f2fs-tools
    cryptsetup
    lvm2
    mdadm
    util-linux
    rsync
    git
    sops
    age
    ssh-to-age
    curl
    wget
    vim
  ];

  boot = {
    # early boot settings
    initrd = {
      compressor = "zstd";
      compressorArgs = ["-19"];
      kernelModules = [];
    };

    blacklistedKernelModules = [];
    kernelModules = [];
    tmp.cleanOnBoot = true;

    kernelParams = [
      "mitigations=off"
      "preempt=full"
      "fbcon=nodefer"
      "splash"
      "quiet"
      "usbcore.autosuspend=-1"
      "watchdog=0"
    ];
  };

  # The live image does not need ZFS; keep it out of the ISO closure.
  boot.supportedFilesystems = lib.mkForce [];

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "chhinamasta";
    networkmanager.enable = true;
  };

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  services.qemuGuest.enable = mkDefault true;
  nixpkgs.system = "x86_64-linux";
  system.stateVersion = "24.11";
}
