{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  bhairava-grub-theme,
  ...
}: let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.latest; # stable, beta, etc.
in {
  disabledModules = [
    # Disable the default Awesome WM module
    "services/x11/window-managers/awesome.nix"
  ];

  imports = [
    # Shared configuration across all machines
    ../shared

    # Select the user configuration
    ../shared/users/tlh.nix

    # Ollama's configuration
    ../shared/services/ollama.nix

    # Virtualization configuration
    ../shared/virtualization/default.nix


    # Specific configuration
    ./hardware-configuration.nix

    # Packages
    ./pkgs.nix
  ];

  boot = {
    initrd = {
      systemd.enable = true;
      verbose = false;
      compressor = "zstd";
      compressorArgs = ["-19"];
      kernelModules = ["nvidia" "ideapad_laptop"];
    };
    blacklistedKernelModules = ["nouveau"];
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    extraModulePackages = [config.boot.kernelPackages.nvidia_x11 config.boot.kernelPackages.acpi_call config.boot.kernelPackages.lenovo-legion-module config.boot.kernelPackages.acpi_call];

    kernelParams = [
      # ignore access time (atime) updates on files, except when they coincide with updates to the ctime or mtime
      "rootflags=noatime"

      # So we can see the kernel errors more clearly
      "quiet"
      # disable usb autosuspend
      "usbcore.autosuspend=-1"

      # Nvidia dGPU settings
      "nvidia_drm.fbdev=1"
      "nvidia-drm.modeset=1"
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
        configurationLimit = 4;
        useOSProber = true;
        bhairava-grub-theme.enable = true;
      };
    };
  };

  environment = {
    variables = {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "0.75";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia"; # hardware acceleration
      #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    systemPackages = with pkgs; [
      cudatoolkit
      nvme-cli
      dbus
      dbus-broker
      dbus-glib
      intel-compute-runtime
      intel-gmmlib
      intel-gpu-tools
      intel-media-sdk
      intel-ocl
      intel-undervolt
      intelmetool
      inteltool
      inxi
      lenovo-legion
      libGL
      libdbusmenu
      libdbusmenu-gtk3
      libva
      libva-utils
      libvdpau
      linuxHeaders
      luajitPackages.ldbus
      mesa
      nvidia-texture-tools
      polkit_gnome
      undervolt
      wirelesstools
      xss-lock
      xssproxy
    ];
  };
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    nvidia.acceptLicense = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "cudatoolkit"
        "nvidia-persistenced"
        "nvidia-settings"
        "nvidia-x11"
      ];
  };
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    acpilight.enable = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      #  nvidiaPersistenced = true;
      open = false;
      package = nvidiaDriverChannel;
      prime = {
        reverseSync.enable = true;
        allowExternalGpu = false;
        # sync.enable = true;
        # offload = {
        #   enable = true;
        #   enableOffloadCmd = true;
        # };
        # Multiple uses are available, check the NVIDIA NixOS wiki
        # Use "lspci | grep -E 'VGA|3D'" to get PCI-bus IDs
        intelBusId = "PCI:00:02:0";
        nvidiaBusId = "PCI:01:00:0";
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidiaDriverChannel
        intel-vaapi-driver
        xorg_sys_opengl
        mlx42
        glfw
        vaapiVdpau
        mesa
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
    };
  };

  networking = {
    hostName = "imperator";
    networkmanager.enable = true;
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "performance";
  };

  services = {
    # Prefer doing this in advanced bios
    # undervolt={
    #     enable = true;
    #  coreOffset = -100;
    #   };

    logind = {
      lidSwitch = "suspend";
      powerKeyLongPress = "suspend";
    };
    thermald.enable = true;

    # Power Management
    #     tlp.enable = true;
    # upower = {
    #   enable = true;
    #   # Adjusts the action taken at the point of the battery being critical and adjusts when that is
    #   criticalPowerAction = "HybridSleep";
    #   percentageLow = 15;
    #   percentageCritical = 8;
    #   percentageAction = 5;
    #   usePercentageForPolicy = true;
    # };
    # handle ACPI events
    acpid.enable = true;
    power-profiles-daemon.enable = true;
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
  services.xserver.dpi = 189;
  # Use custom Awesome WM module
  services.xserver.windowManager.awesome.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
