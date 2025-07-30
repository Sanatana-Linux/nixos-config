{
  inputs,
  lib,
  config,
  modulesPath,
  pkgs,
  bhairava-grub-theme,
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

    inputs.home-manager.nixosModules.home-manager
    # Shared configuration across all machines
    ../shared/default.nix

    # Select the user configuration
    ../shared/users/tlh.nix

    # AwesomeWM
    ../shared/desktop/default.nix
    ../shared/desktop/awesomewm.nix

    # Packages
    ./pkgs.nix
  ];

  services.xserver.enable = true;
  boot.plymouth.enable = true;

  environment.systemPackages = with pkgs; [
    cpufrequtils
    dbus
    grub2_full
    plymouth
    dbus-broker
    dbus-glib
    i2c-tools
    peakperf
    libdbusmenu
    libdbusmenu-gtk3
    linuxHeaders
    luajitPackages.ldbus
    polkit_gnome
    xss-lock
    xssproxy
  ];
  boot = {
    # early boot settings
    initrd = {
      systemd.enable = true; # enable systemd in initrd
      verbose = false; # disable verbose mode in initrd
      compressor = "zstd"; # use zstd as initrd compressor
      # pass arguments to zstd compressor
      compressorArgs = ["-19"];
      # specify the kernel modules to be included in early in boot process
      kernelModules = [];
    };

    blacklistedKernelModules = []; # blacklisted kernel modules

    kernelModules = []; # specify the regular kernel modules to be loaded at boot

    tmp.cleanOnBoot = true; # clean the /tmp directory on boot

    kernelPackages = pkgs.linuxPackages_xanmod_latest; # use the latest xanmod kernel

    kernelParams = [
      # `I too like living dangerously`
      # check if vulnerable with: grep . /sys/devices/system/cpu/vulnerabilities/*
      "mitigations=off"
      # Rudest Kernel Interrupt for Priority Processes
      "preempt=full"
      # prevent the kernel from blanking plymouth out of the fb
      "fbcon=nodefer"
      # Plymouth, because apparently you can't turn it off
      "splash"
      # So we can see the kernel errors more clearly
      "quiet"
      # disable usb autosuspend
      "usbcore.autosuspend=-1"
      # No hanging on reboot due to something I don't need on my laptop
      "watchdog=0"
    ];

    # loader = {
    #   timeout = null;
    #   systemd-boot.enable = false;
    #   efi = {
    #     canTouchEfiVariables = true;
    #     efiSysMountPoint = "/boot/";
    #   };
    #
    #   # grub = {
    #   #   enable = true;
    #   #   device = "nodev";
    #   #   efiSupport = true;
    #   #   timeoutStyle = "hidden";
    #   #   configurationLimit = 5;
    #   #   useOSProber = false; # Scan for Windows/Other Installs
    #   #   bhairava-grub-theme.enable = true;
    #   # };
    # };
  };
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  networking = {
    hostName = "chhinamasta";
    networkmanager.enable = true;
  };
  services = {
    # TODO autologin for VMN/ISO
    # For desktop environment selection
    displayManager = {
      defaultSession = "none+awesome";
    };
  };

  # EFI booting
  isoImage.makeEfiBootable = true;

  # USB booting
  isoImage.makeUsbBootable = true;

  services.qemuGuest.enable = mkDefault true;
  nixpkgs.hostPlatform = "x86_64-linux"; # Set the host platform for Nixpkgs
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
