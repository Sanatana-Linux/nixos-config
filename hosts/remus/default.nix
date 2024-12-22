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

    # Select the user configuration inputs.nsearch.packages.${pkgs.system}.default
    ../shared/users/tlh.nix

    # Ollama's configuration
    ../shared/services/ollama.nix

    # Virtualization configuration
    ../shared/virtualization/default.nix

    #  laptop power management
    ../shared/power/default.nix

    # performance tweaks
    ../shared/performance/default.nix

    # bluetooth support
    ../shared/hardware/bluetooth.nix

    # Nvidia Driver Support
    ../shared/hardware/nvidia.nix

    # xfce4 
    ../shared/desktop/xfce.nix

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
        kernelModules = ["nvidia" "ideapad_laptop" "lenovo_legion"];
    };
  blacklistedKernelModules = ["nouveau"];
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    extraModulePackages = [config.boot.kernelPackages.acpi_call  config.boot.kernelPackages.lenovo-legion-module config.boot.kernelPackages.nvidia_x11];

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
    acpilight.enable = true;
  };

  networking = {
    hostName = "remus";
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
  #  services.xserver.windowManager.awesome.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
