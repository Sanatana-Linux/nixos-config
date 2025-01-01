{
  inputs,
  outputs,
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

    # bluetooth support
    ../shared/hardware/bluetooth.nix

    # nvidia support

    # common hardware support
    ../shared/hardware/common.nix

    # Intel CPU support
    ../shared/hardware/intel.nix

    # Specific configuration
    ./hardware-configuration.nix

    # AwesomeWM
    ../shared/desktop/awesomewm.nix

    # Packages
    ./pkgs.nix
  ];

  services.xserver.videoDrivers = ["nvidia" "i915"];
  services.xserver.enable = true;
  boot.plymouth.enable = true;
  # boot.plymouth.theme = "loader";
  # boot.plymouth.themePackages = [pkgs.adi1090x-plymouth-themes];

  environment.systemPackages = with pkgs; [
    cpufrequtils
    config.boot.kernelPackages.nvidia_x11 # nvidia x11 kernel module
    config.boot.kernelPackages.acpi_call # acpi_call kernel module
    nvme-cli
    dbus
    mesa
    plymouth
    kdePackages.plymouth-kcm
    adi1090x-plymouth-themes
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
    # initrd settings
    initrd = {
      systemd.enable = true; # enable systemd in initrd
      verbose = false; # disable verbose mode in initrd
      compressor = "zstd"; # use zstd as initrd compressor
      # pass arguments to zstd compressor
      compressorArgs = ["-19"];
      # specify the kernel modules to be included in early in boot process
      kernelModules = [
        "nvidia" # nvidia drivers
        "nvidiafb"
        "nvidia-drm"
        "nvidia-uvm"
        "nvidia-modeset"
        "i915"
      ];
    };

    blacklistedKernelModules = ["nouveau"]; # blacklisted kernel modules

    kernelModules = ["lenovo_legion" "kvm-intel" "ideapad" "apci_call"]; # specify the regukar kernel modules to be loaded at boot

    tmp.cleanOnBoot = true; # clean the /tmp directory on boot

    kernelPackages = pkgs.linuxPackages_zen; # use the xanmod kernel

    # specify the extra kernel modules to be included
    extraModulePackages = [
      config.boot.kernelPackages.acpi_call # acpi_call kernel module
      config.boot.kernelPackages.lenovo-legion-module # lenovo legion kernel module
      config.boot.kernelPackages.nvidia_x11 # nvidia x11 kernel module
    ];

    kernelParams = [
      # I too enjoy living dangerously
      # check if vulnerable with: grep . /sys/devices/system/cpu/vulnerabilities/*
      "mitigations=off"
      #      "preempt=full"
      # "acpi_call"
      # prevent the kernel from blanking plymouth out of the fb
      "fbcon=nodefer"
      # Plymouth, because apparently you can't turn it off
      "splash"
      # So we can see the kernel errors more clearly
      "quiet"
      # disable usb autosuspend
      "usbcore.autosuspend=-1"
      # Nvidia dGPU settings
      "nvidia_drm.fbdev=1" # Framebuffer driver
      "nvidia-drm.modeset=1" # Modesetting Kernel Module
      # Potentially useful for hanging or shutdown
      "reboot=acpi" 
      
    ];

    loader = {
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/";
      };

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        configurationLimit = 3;
        useOSProber = true;
        bhairava-grub-theme.enable = true;
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
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = false;
        disableWhileTyping = true;
      };
    };
  }; # enable systemd in initrd

  services.xserver.dpi = 189;
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
