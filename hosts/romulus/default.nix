{ inputs
, outputs
, lib
, config
, pkgs
, bhairava-grub-theme
, ...
}: {
  imports = [
    # Shared configuration across all machines
    ../shared

    # Select the user configuration
    ../shared/users/tlh.nix

    # Ollama's configuration
    ../shared/services/ollama.nix

    # Virtualization configuration
    ../shared/virtualization/default.nix

    #  laptop power management
    ../shared/power/laptop.nix

    # performance tweaks
    ../shared/performance/default.nix

    # bluetooth support
    ../shared/hardware/bluetooth.nix

    # Nvidia Driver Support
    ./nvidia.nix

    # Specific configuration
    ./hardware-configuration.nix

    # AwesomeWM
    ../shared/desktop/awesomewm.nix

    # Packages
    ./pkgs.nix
  ];

  boot = {
    initrd = {
      systemd.enable = true;
      verbose = false;
      compressor = "zstd";
      compressorArgs = [ "-19" ];
    };
    #     kernelPatches = [
    # {
    #   name = "legion-laptop";
    #   patch = ./0001-Add-legion-laptop-v0.0.11.patch;
    # }
    # ];

    blacklistedKernelModules = [ "nouveau" ];
    kernelModules = [ "nvidia" "lenovo_legion" "apci_call" "ideapad" ];
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_lqx;
    extraModulePackages = [ config.boot.kernelPackages.acpi_call config.boot.kernelPackages.lenovo-legion-module config.boot.kernelPackages.nvidia_x11 ];

    kernelParams = [
      # I too enjoy living dangerously
      # check if vulnerable with: grep . /sys/devices/system/cpu/vulnerabilities/*
      "mitigations=off"

      # ignore access time (atime) updates on files, except when they coincide with updates to the ctime or mtime
      "rootflags=noatime"

      # So we can see the kernel errors more clearly
      "quiet"

      # disable usb autosuspend
      "usbcore.autosuspend=-1"

      # Nvidia dGPU settings

      "nvidia_drm.fbdev=1" # Framebuffer driver
      "nvidia-drm.modeset=1" # Modesetting Kernel Module 
      "lenovo-legion.force=1" # Force the module to load
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
        memtest86.enable = true;
        efiSupport = true;
        configurationLimit = 4;
        useOSProber = true;
        bhairava-grub-theme.enable = true;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      cpufrequtils
      nvme-cli
      dbus
      dbus-broker
      dbus-glib
      intel-compute-runtime
      intel-gmmlib
      intel-gpu-tools
      intel-ocl
      intel-undervolt
      intelmetool
      inteltool
      inxi
      lenovo-legion
      libdbusmenu
      libdbusmenu-gtk3
      linuxHeaders
      luajitPackages.ldbus
      polkit_gnome
      undervolt
      wirelesstools
      xss-lock
      xssproxy
    ];
  };
  nixpkgs.config = {
    allowUnfree = true;
  };
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  networking = {
    hostName = "romulus";
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
  };

  services.xserver.dpi = 189;
  services.displayManager.defaultSession = "none+awesome";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
