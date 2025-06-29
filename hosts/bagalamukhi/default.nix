{
  inputs,
  lib,
  config,
  pkgs,
  bhairava-grub-theme,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    # Shared configuration across all machines
    ../shared/default.nix

    # Select the user configuration
    ../shared/users/tlh.nix

    # Ollama's configuration
    ../shared/ai/ollama.nix
    ../shared/ai/default.nix

    # Virtualization configuration
    ../shared/virtualization/default.nix

    #  laptop power management
    ../shared/power/laptop.nix

    # performance tweaks
    ../shared/performance/default.nix

    # Android
    ../shared/hardware/android.nix

    # bluetooth support
    ../shared/hardware/bluetooth.nix

    # nvidia support
    ../shared/hardware/nvidia.nix

    # common hardware support
    ../shared/hardware/common.nix

    # Intel CPU support
    ../shared/hardware/intel.nix

    # Specific configuration
    ./hardware-configuration.nix

    # AwesomeWM
    ../shared/desktop/default.nix
    ../shared/desktop/awesomewm.nix
    # ../shared/desktop/niri.nix

    # Packages
    ./pkgs.nix
  ];

  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.enable = true;
  boot.plymouth.enable = true;
  # boot.plymouth.logo = "https://github.com/Thomashighbaugh/Thomashighbaugh/blob/main/src/resources/images/icon.png"; # use a custom logo for plymouth
  # boot.plymouth.theme = "loader";
  # boot.plymouth.themePackages = [pkgs.adi1090x-plymouth-themes];

  environment.systemPackages = with pkgs; [
    cpufrequtils
    config.boot.kernelPackages.acpi_call # acpi_call kernel module
    nvme-cli
    dbus
    grub2_full
    mesa
    plymouth
    kdePackages.plymouth-kcm
    dbus-broker
    dbus-glib
    lenovo-legion
    i2c-tools
    peakperf
    intel-media-driver
    libdbusmenu
    libdbusmenu-gtk3
    linuxHeaders
    luajitPackages.ldbus
    polkit_gnome
    wirelesstools
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
      kernelModules = [
        "nvidia" # nvidia driver
        "nvidiafb" # nvidia framebuffer
        "nvidia-drm" # nvidia drm
        "nvidia-uvm" # nvidia uvm
        "nvidia-modeset" # modesetting nvidia driver
      ];
    };

    blacklistedKernelModules = ["nouveau"]; # blacklisted kernel modules

    kernelModules = ["lenovo_legion" "phc-intel" "kvm-intel" "ideapad" "apci_call" "cpupower"]; # specify the regular kernel modules to be loaded at boot

    tmp.cleanOnBoot = true; # clean the /tmp directory on boot

    kernelPackages = pkgs.linuxPackages_xanmod_latest; # use the latest xanmod kernel

    # specify the extra kernel modules to be included
    extraModulePackages = [
      config.boot.kernelPackages.acpi_call # acpi_call kernel module
      config.boot.kernelPackages.cpupower #  Tool to examine and tune power saving features
      config.boot.kernelPackages.lenovo-legion-module # lenovo legion kernel module
      config.boot.kernelPackages.nvidiaPackages.production # nvidia x11 kernel module
    ];

    kernelParams = [
      # `I too like living dangerously`
      # check if vulnerable with: grep . /sys/devices/system/cpu/vulnerabilities/*
      "mitigations=off"
      # Rudest Kernel Interrupt for Priority Processes
      "preempt=full"
      # Hardware I/O Interface
      "acpi_call"
      # prevent the kernel from blanking plymouth out of the fb
      "fbcon=nodefer"
      # Plymouth, because apparently you can't turn it off
      "splash"
      # So we can see the kernel errors more clearly
      "quiet"
      # disable usb autosuspend
      "usbcore.autosuspend=-1"
      # Nvidia dGPU settings
      "nvidia_drm.fbdev=1" # enable Framebuffer driver
      "nvidia-drm.modeset=1" # enable Modesetting Kernel Module
      # Potentially useful for hanging or shutdown
      "reboot=acpi"
      # No hanging on reboot due to something I don't need on my laptop
      "watchdog=0"
      # Lenovo Legion Module force enable
      "lenovo-legion.force=1"
    ];

    loader = {
      timeout = null;
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/";
      };

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        timeoutStyle = "hidden";
        configurationLimit = 5;
        useOSProber = true; # Scan for Windows/Other Installs
        bhairava-grub-theme.enable = true;
        # Files needed to enter Advanced BIOS
        extraFiles = {
          "DisplayEngine.efi" = ../shared/bios/DisplayEngine.efi;
          "EFI/Boot/Bootx64.efi" = ../shared/bios/Bootx64.efi;
          "Loader.efi" = ../shared/bios/Loader.efi;
          "SREP_Config.cfg" = ../shared/bios/SREP_Config.cfg;
          "SetupBrowser.efi" = ../shared/bios/SetupBrowser.efi;
          "SuppressIFPatcher.efi" = ../shared/bios/SuppressIFPatcher.efi;
          "UiApp.efi" = ../shared/bios/UiApp.efi;
        };
        # Add in advanced BIOS entry (works for lenovo legion 16irx9, YMMV)
        extraEntries = ''
          menuentry 'Advanced UEFI Firmware Settings' --class efi --class uefi {
            insmod fat
            insmod chain
            chainloader @bootRoot@/EFI/Boot/Bootx64.efi
          }
        '';
      };
    };
  };
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  networking = {
    hostName = "bagalamukhi";
    networkmanager.enable = true;
  };
  services = {
    logind = {
      lidSwitch = "suspend";
      powerKeyLongPress = "suspend";
    };
    # -------------------------------------------------------------------------- #
    # For desktop environment selection (since the display manager is generalized)
    displayManager = {
      defaultSession = "none+awesome";
    };
  };

  services.xserver.dpi = 189;
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
