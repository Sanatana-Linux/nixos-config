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
  ];

  # Enable modules using the "activate by enable option" paradigm
  # Trimmed for live ISO — no hardware-specific drivers or unnecessary packages
  modules = {
    base = {
      enable = true;
      timezone = "America/New_York";
      nix.enable = true;
    };
    shell = {
      enable = true;
      zsh = true;
    };
    stylix.enable = true;
    users.user.enable = true;
    packages = {
      core.enable = true;
      development = {
        enable = true;
        minimal = true;
      };
      fonts = {
        enable = true;
        nerdFonts = true;
        iconFonts = true;
        systemFonts = true;
      };
      gui = {
        enable = true;
        minimal = true;
        libs.enable = true;
      };
      multimedia = {
        enable = true;
        minimal = true;
      };
      network = {
        enable = true;
        wirelessTools = true;
        downloadTools = true;
      };
      python.enable = true;
      shell = {
        enable = true;
        modernTools = true;
        systemUtils = true;
        fileManagement = true;
      };
      system = {
        enable = true;
        minimal = true;
      };
    };
    hardware = {
      sound = {
        enable = true;
        pipewire = true;
      };
    };
    desktop = {
      awesomewm.enable = true;
      xorg.enable = true;
    };
  };

  # services.xserver.enable = true;
  boot.plymouth.enable = true;

  environment.systemPackages = with pkgs; [
    dbus
    grub2
    plymouth
    dbus-broker
    dbus-glib
    libdbusmenu
    libdbusmenu-gtk3
    polkit_gnome
    xss-lock
    xssproxy
  ];

  boot = {
    # early boot settings
    initrd = {
      systemd.enable = true;
      verbose = false;
      compressor = "zstd";
      compressorArgs = ["-19"];
      kernelModules = [];
    };

    blacklistedKernelModules = [];
    kernelModules = [];
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

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

  hardware = {
    enableRedistributableFirmware = true;
  };

  networking = {
    hostName = "shodashi";
    networkmanager.enable = true;
  };

  services = {
    displayManager = {
      defaultSession = "none+awesome";
    };
  };

  # EFI booting
  isoImage.makeEfiBootable = true;

  # USB booting
  isoImage.makeUsbBootable = true;

  services.qemuGuest.enable = mkDefault true;
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
