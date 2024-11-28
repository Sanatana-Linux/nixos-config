{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  bhairava-grub-theme,
  ...
}: {
  disabledModules = [
    # Disable the default Awesome WM module
    "services/x11/window-managers/awesome.nix"
  ];

  imports = [
    # Shared configuration across all machines
    ../shared

    # Select the user configuration
    ../shared/users/tlh.nix

    # Specific configuration
    ./hardware-configuration.nix
  ];

  boot = {
    initrd = {
      systemd.enable = true;
      verbose = false;

      kernelModules = ["nvidia"];
    };
    blacklistedKernelModules = ["nouveau"];

    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [config.boot.kernelPackages.nvidia_x11];

    kernelParams = [
      # # https://en.wikipedia.org/wiki/Kernel_page-table_isolation
      # "pti=on"
      # # make stack-based attacks on the kernel harder
      # "randomize_kstack_offset=on"
      # # https://tails.boum.org/contribute/design/kernel_hardening/
      # "slab_nomerge"
      # # needs to be on for powertop
      # "debugfs=on"
      # # only allow signed modules
      # "module.sig_enforce=1"
      # # enable buddy allocator free poisoning
      # "page_poison=1"
      # # performance improvement for direct-mapped memory-side-cache utilization, reduces the predictability of page allocations
      # "page_alloc.shuffle=1"
      # # for debugging kernel-level slab issues
      # "slub_debug=FZP"
      # #  always-enable sysrq keys. Useful for debugging
      # "sysrq_always_enabled=1"

      # ignore access time (atime) updates on files, except when they coincide with updates to the ctime or mtime
      "rootflags=noatime"

      # enable IOMMU for devices used in passthrough and provide better host performance
      "iommu=pt"

      # disable usb autosuspend
      "usbcore.autosuspend=-1"

      # # linux security modules
      # "lsm=landlock,lockdown,yama,apparmor,bpf"

      # prevent the kernel from blanking plymouth out of the fb
      "fbcon=nodefer"

      # tell the kernel to not be verbose
      "quiet"

      # disable systemd status messages
      # rd prefix means systemd-udev will be used instead of initrd
      "rd.systemd.show_status=auto"

      # Intel iGPU settings
      "i915.force_probe=7d55"

      # Nvidia dGPU settings
      "nvidia_drm.fbdev=1"
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
        useOSProber = true;
        bhairava-grub-theme.enable = true;
      };
    };
  };

  environment = {
    #   variables = {
    #     GDK_SCALE = "1";
    #     GDK_DPI_SCALE = "1";
    #     QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    #   };

    systemPackages = with pkgs; [
      acpi
      acpid
      acpilight
      acpitool
      intel-undervolt
      inteltool
      libva
      wirelesstools
      networkmanagerapplet
      libdbusmenu
      libdbusmenu-gtk3
      dbus-broker
      dbus-glib
      dbus
      lua53Packages.ldbus
      lua54Packages.ldbus
      luajitPackages.ldbus
      polkit_gnome
      xssproxy
      xss-lock
    ];
  };

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      powerManagement.enable = true;
      prime = {
        reverseSync.enable = true;
        # sync.enable = true;
        #        offload = {
        #   enable = true;
        #   enableOffloadCmd = true;
        # };
        # Multiple uses are available, check the NVIDIA NixOS wiki
        # Use "lspci | grep -E 'VGA|3D'" to get PCI-bus IDs
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        config.boot.kernelPackages.nvidiaPackages.beta
        vaapiVdpau
        libvdpau-va-gl
        libva-utils
        libva1
        intel-media-driver
        vpl-gpu-rt
        # intel-vaapi-driver
        nvidia-vaapi-driver
      ];
    };
  };

  networking = {
    hostName = "macbook-air";
    networkmanager.enable = true;
  };

  services = {
    logind = {
      lidSwitch = "suspend";
      powerKeyLongPress = "suspend";
    };
    thermald.enable = true;

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "balanced";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    # Power Management
    upower = {
      enable = true;
      # Adjusts the action taken at the point of the battery being critical and adjusts when that is
      criticalPowerAction = "Hibernate";
      percentageLow = 15;
      percentageCritical = 8;
      percentageAction = 5;
      usePercentageForPolicy = true;
    };
    # handle ACPI events
    acpid.enable = true;

    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = false;
        disableWhileTyping = true;
      };
    };
  };

  services.xserver.videoDrivers = ["nvidia"]; # got problems with nouveau, would give it another try
  services.xserver.enable = true;
  # Use custom Awesome WM module
  services.xserver.windowManager.awesome.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
