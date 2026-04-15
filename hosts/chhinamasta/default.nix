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

  # Overlays - same as bagalamukhi but limited to what's needed for live ISO
  nixpkgs.overlays = [
    # outputs.overlays.additions  # Not adding these to keep ISO size manageable
    # outputs.overlays.modifications
    # outputs.overlays.stable-packages
    inputs.nur.overlays.default
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };

  # Enable modules using the "activate by enable option" paradigm
  # Live ISO configuration with essential features
  modules = {
    # System
    system = {
      systemd.enable = true;
      boot = {
        enable = true;
        theme.enable = true;
        development.enable = true;
      };
      plymouth.enable = true; # Enable Sanatana Plymouth theme
    };

    base = {
      enable = true;
      timezone = "America/New_York";
      nix.enable = true;
      permittedPackages.enable = true;
      services.enable = true;
    };

    # User
    users.user.enable = true;
    shell = {
      enable = true;
      zsh = true;
    };

    # Programs - essential for live ISO
    programs = {
      nix-ld.enable = true;
      appimage.enable = true;
      thunar.enable = true;
    };

    # Environment
    environment.variables.enable = true;

    # Performance - basic for live environment
    performance = {
      default.enable = true;
      zram.enable = true; # Good for live ISO with limited RAM
    };

    # Packages - configured for live ISO use
    packages = {
      core.enable = true;
      development = {
        enable = true;
        minimal = true; # Keep minimal for ISO size
      };
      fonts = {
        enable = true;
        nerdFonts = true;
        iconFonts = true;
        systemFonts = true;
      };
      gui = {
        enable = true;
        minimal = true; # Keep minimal for ISO size
        libs.enable = true;
      };
      multimedia = {
        enable = true;
        minimal = true; # Keep minimal for ISO size
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
        zshPlugins = true;
        inputSupport = true;
      };
      system = {
        enable = true;
        minimal = true; # Keep minimal for ISO size
      };
      x11.enable = true;
    };

    # Hardware - essential for live ISO
    hardware = {
      bluetooth.enable = true; # Common hardware support
      sound.enable = true;
      udev.enable = true;
      tpm.enable = true; # Modern hardware support
      intel.enable = true; # Intel graphics/CPU support (common)
      networking = {
        enable = true;
        hostName = "chhinamasta";
        wifi.rtl88x2bu.enable = true; # Same WiFi support as bagalamukhi
      };
      android.enable = true; # Mobile device support
      # Note: Not adding NVIDIA, Logitech, or Lenovo as these are too specific for a live ISO
    };

    # Stylix
    stylix.enable = true;

    # Desktop
    desktop = {
      awesomewm.enable = true;
    };

    # Security - essential
    security = {
      doas = {
        enable = true;
        adminUser = "user"; # Note: user instead of tlh
      };
      sudo.enable = true;
    };

    # AI - optional but good for demonstration
    ai = {
      ollama.enable = true;
      core.enable = true;
    };
  };

  services.xserver.enable = true;
  services.displayManager.defaultSession = "none+awesome";

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
    kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod_latest;

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
    hostName = "chhinamasta";
    networkmanager.enable = true;
  };

  services = {
    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
  };

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  services.qemuGuest.enable = mkDefault true;
  nixpkgs.system = "x86_64-linux";
  system.stateVersion = "24.11";
}
