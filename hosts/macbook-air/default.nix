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
    };
    blacklistedKernelModules = [ "b43" "bcma" ];

    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    extraModulePackages = with config.boot.kernelPackages; [acpi_call broadcom_sta];

    kernelParams = [
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
      # disable usb autosuspend
      "usbcore.autosuspend=-1"
      # linux security modules
      "lsm=landlock,lockdown,yama,apparmor,bpf"
      # KERN_DEBUG for debugging
      "loglevel=7"
      # disables resume and restores original swap space
      "noresume"
      # prevent the kernel from blanking plymouth out of the fb
      "fbcon=nodefer"
      # disable boot logo if any
      # "logo.nologo"
      # tell the kernel to not be verbose
      "quiet"
      # disable systemd status messages
      # rd prefix means systemd-udev will be used instead of initrd
      "rd.systemd.show_status=auto"
      # lower the udev log level to show only errors or worse
      "rd.udev.log_level=3"
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
    variables = {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    };

    systemPackages = with pkgs; [
      acpi
      acpid
      acpilight
      acpitool
      broadcom-bt-firmware
      intel-compute-runtime
      intel-gmmlib
      intel-gpu-tools
      intel-graphics-compiler
      intel-media-driver
      intel-media-sdk
      intel-ocl
      intel-vaapi-driver
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
      libva-utils
      xssproxy
      xss-lock
    ];
  };

powerManagement.enable = true;
  hardware = {
enableAllFirmware = true;
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
        mesa-demos
        glfw
        xorg.xf86videointel
      ];
    };
  };

  networking = {
    hostName = "macbook-air";
    networkmanager.enable = true;
  };

  services = {
    logind = {
      extraConfig = ''
        # don’t shutdown when power button is short-pressed
        IdleAction=lock
        IdleActionSec=1m
      '';
      lidSwitch = "suspend";
      powerKeyLongPress = "suspend";
      powerKey = "ignore";
    };
    thermald.enable = true;

auto-cpufreq={enable = true;
settings = {
  battery = {
     governor = "powersave";
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

  # Use custom Awesome WM module
  services.xserver.windowManager.awesome.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
