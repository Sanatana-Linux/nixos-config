{
  inputs,
  lib,
  config,
  pkgs,
  bhairava-grub-theme,
  ...
}: {
  imports = [
    # Hardware-specific configuration
    ./hardware-configuration.nix
  ];

  # Enable modules using the new "activate by enable option" paradigm
  modules = {
    system.boot = {
      enable = true;
      theme.enable = true;
      windowsDualBoot.enable = true;
      advancedBios.enable = true;
    };
    base = {
      enable = true;
      timezone = "America/New_York";
      nix.enable = true;
    };

    shell = {
      enable = true;
      zsh = true;
    };
    users.tlh.enable = true;

    # Programs
    programs = {
      nix-ld.enable = true; # Allow running dynamically linked binaries like opencode
    };

    # Virtualization
    virtualization = {
      virt-manager.enable = true; # QEMU, libvirt, KVM
      waydroid.enable = true; # Waydroid Android Apps
      lxc.enable = true; # LXC containers + ethertypes
    };

    # Performance optimizations
    performance = {
      default.enable = true;
      undervolt.enable = true; # Intel CPU undervolting + P-State limits
    };

    # Services
    services = {
      core.enable = true; # FWUPD, fstrim, journald, dbus
      ssh.enable = true; # OpenSSH server
      udev.enable = true; # udisks2 and hardware udev rules
    };

    # Power management for laptop
    power.laptop.enable = true;

    packages = {
      archives.enable = true;
      core.enable = true;
      devtools.enable = true;
      fonts.enable = true;
      gui.enable = true;
      multimedia = {
        enable = true;
        creators = true; # gimp, olive-editor, etc.
      };
      network.enable = true;
      shell.enable = true;
      system.enable = true;
    };
    hardware = {
      nvidia = {
        enable = true;
        cudaSupport = true;
        gamingOptimizations = false;
      };
      intel.enable = true;
      bluetooth.enable = true;
      openrgb = {
        enable = true;
        motherboard = "intel";
      };
      sound = {
        enable = true;
        pipewire = true;
      };
    };
    desktop = {
      xorg.enable = true;
      awesomewm = {
        enable = true;
        useGitVersion = true;
      };
    };
    virtualization.docker = {
      enable = true;
      rootless = true;
      nvidia = true;
    };
    ai.ollama = {
      enable = true;
    };
    security.doas.enable = true;
  };

  # Host-specific display configuration
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    dpi = lib.mkForce 96;
  };

  # OpenGL configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Boot configuration
  boot = {
    # early boot settings
    initrd = {
      systemd.enable = true;
      verbose = false;
      compressor = "zstd";
      compressorArgs = ["-19"];
      kernelModules = [
        "nvidia"
        "nvidiafb"
        "nvidia-drm"
        "nvidia-uvm"
        "nvidia-modeset"
        "intel_cstate"
        "aesni_intel"
        "intel_uncore"
        "intel_uncore_frequency"
        "intel_powerclamp"
      ];
    };

    blacklistedKernelModules = ["nouveau"];
    kernelModules = ["lenovo_legion" "phc-intel" "kvm-intel" "ideapad" "apci_call" "cpupower"];
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest;

    extraModulePackages = [
      config.boot.kernelPackages.acpi_call
      config.boot.kernelPackages.cpupower
      config.boot.kernelPackages.lenovo-legion-module
      config.boot.kernelPackages.nvidiaPackages.stable
    ];

    kernelParams = [
      "mitigations=off"
      "dev.i915.perf_stream_paranoid=0"
      "preempt=full"
      "acpi_call"
      "fbcon=nodefer"
      "splash"
      "quiet"
      "rd.udev.log_priority=3"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia-drm.modeset=1"
      "nvme_core.default_ps_max_latency_us=0"
      "lenovo-legion.force=1"
    ];
  };

  # Boot Plymouth configuration
  boot.plymouth.enable = true;

  # Hardware support
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  # Networking
  networking = {
    hostName = "bagalamukhi";
    networkmanager.enable = true;
  };

  # Service configuration
  services = {
    logind = {
      settings.Login.HandleLidSwitch = "suspend";
      settings.Login.HandlePowerKey = "ignore";
      settings.Login.HandlePowerKeyLongPress = "suspend";
    };
    displayManager = {
      defaultSession = "none+awesome";
    };
  };

  # Host-specific packages
  environment = {
    pathsToLink = ["/share/zsh"];
    systemPackages = with pkgs; [
      cpufrequtils
      config.boot.kernelPackages.acpi_call
      nvme-cli
      grub2
      mesa
      mesa-demos
      plymouth
      kdePackages.plymouth-kcm
      lenovo-legion
      i2c-tools
      peakperf
      intel-media-driver
      linuxHeaders
      luajitPackages.ldbus
      xssproxy
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
