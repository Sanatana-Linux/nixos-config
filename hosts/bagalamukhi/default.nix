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
    # ../shared/ai/ollama.nix
    ../shared/ai/default.nix

    # Virtualization configuration
    ../shared/virtualization/default.nix

    #  laptop power management
    ../shared/power/laptop.nix

    # performance tweaks
    ../shared/performance/default.nix

    # bluetooth support
    ../shared/hardware/bluetooth.nix

    # common hardware support
    ../shared/hardware/common.nix

    # Intel CPU support
    ../shared/hardware/intel.nix

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
    # disable plymouth (splash screen) because it's not working with proprietary nvidia driver
    plymouth.enable = false;

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

        "i915" # i915 driver for Intel graphics

        # nvidia modeset driver
        "nvidia_modeset"

        # nvidia uvm driver
        "nvidia_uvm"

        # nvidia drm driver
        "nvidia_drm"
      ];
    };

    blacklistedKernelModules = ["nouveau"]; # blacklisted kernel modules

    kernelModules = ["lenovo_legion" "ideapad" "apci_call"]; # specify the regukar kernel modules to be loaded at boot

    tmp.cleanOnBoot = true; # clean the /tmp directory on boot

    kernelPackages = pkgs.linuxPackages; # use the xanmod kernel

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

      "preempt=full"
      "acpi_call"
      # https://en.wikipedia.org/wiki/Kernel_page-table_isolation
      "pti=on"
      # make stack-based attacks on the kernel harder
      "randomize_kstack_offset=on"
      # https://tails.boum.org/contribute/design/kernel_hardening/
      "slab_nomerge"
      # needs to be on for powertop
      "debugfs=on"
      # only allow signed modules
      "module.sig_enforce=1"
      # enable buddy allocator free poisoning
      "page_poison=1"
      # performance improvement for direct-mapped memory-side-cache utilization, reduces the predictability of page allocations
      "page_alloc.shuffle=1"
      # for debugging kernel-level slab issues
      "slub_debug=FZP"
      #  always-enable sysrq keys. Useful for debugging
      "sysrq_always_enabled=1"
      # save power on idle by limiting c-states
      # https://gist.github.com/wmealing/2dd2b543c4d3cff6cab7
      "processor.max_cstate=5"
      # disable the intel_idle driver and use acpi_idle instead
      "idle=nomwait"
      # ignore access time (atime) updates on files, except when they coincide with updates to the ctime or mtime
      "rootflags=noatime"
      # enable IOMMU for devices used in passthrough and provide better host performance
      "iommu=pt"
      # rd prefix means systemd-udev will be used instead of initrd
      "rd.systemd.show_status=auto"
      # lower the udev log level to show only errors or worse
      "rd.udev.log_level=3"
      # prevent the kernel from blanking plymouth out of the fb
      "fbcon=nodefer"
      # So we can see the kernel errors more clearly
      "quiet"
      # disable usb autosuspend
      "usbcore.autosuspend=-1"
      # Nvidia dGPU settings
      "nvidia_drm.fbdev=1" # Framebuffer driver
      "nvidia-drm.modeset=1" # Modesetting Kernel Module
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
  environment = {
    systemPackages = with pkgs; [
      cpufrequtils
      nvme-cli
      dbus
      dbus-broker
      dbus-glib
      lenovo-legion
      libdbusmenu
      libdbusmenu-gtk3
      linuxHeaders
      luajitPackages.ldbus
      polkit_gnome
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
  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.awesome.enable = true;
  services.xserver.dpi = 189;
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
