{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.system.boot = {
    enable = mkEnableOption "System bootloader configuration";

    loader = mkOption {
      type = types.enum ["grub" "systemd-boot"];
      default = "grub";
      description = "Which bootloader to use";
    };

    efiMountPoint = mkOption {
      type = types.str;
      default = "/boot/efi";
      description = "Where the EFI system partition is mounted";
    };

    timeoutStyle = mkOption {
      type = types.enum ["hidden" "menu" "countdown"];
      default = "hidden";
      description = "How the GRUB menu timeout is handled";
    };

    configurationLimit = mkOption {
      type = types.int;
      default = 5;
      description = "Maximum number of generations in the boot menu";
    };

    useOSProber = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use OS prober to discover other operating systems";
    };

    theme = {
      enable = mkEnableOption "Bhairava custom GRUB theme";
    };

    windowsDualBoot = {
      enable = mkEnableOption "Windows dual boot configuration";
    };

    advancedBios = {
      enable = mkEnableOption "Advanced BIOS setup configuration";
    };

    useLatestKernel = mkOption {
      type = types.bool;
      default = false;
      description = "Use the xanmod latest kernel packages instead of the default stable kernel";
    };
  };

  config = mkIf config.modules.system.boot.enable {
    boot = {
      tmp.cleanOnBoot = true;

      kernelPackages = mkIf config.modules.system.boot.useLatestKernel pkgs.linuxPackages_xanmod_latest;

      blacklistedKernelModules = [ "nouveau" ];

      kernelModules = [
        "lenovo_legion"
        "ideapad"
        "phc-intel"
        "cpupower"
        "acpi_call"
      ];

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
        "usbcore.autosuspend=-1"
        "nvidia_drm.fbdev=1"
        "lenovo-legion.force=1"
        "rd.udev.log_priority=3"
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        "nvidia-drm.modeset=1"
        "nvme_core.default_ps_max_latency_us=0"
      ];

      plymouth.enable = true;

      initrd = {
        systemd.enable = true;
        verbose = false;
        compressor = "zstd";
        compressorArgs = [ "-19" ];
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
    };

    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };

    environment.systemPackages = with pkgs; [
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

    boot.loader = {
      timeout = mkIf (config.modules.system.boot.timeoutStyle == "hidden") null;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = config.modules.system.boot.efiMountPoint;
      };

      systemd-boot.enable = config.modules.system.boot.loader == "systemd-boot";

      grub = mkIf (config.modules.system.boot.loader == "grub") {
        enable = true;
        device = "nodev";
        efiSupport = true;
        timeoutStyle = config.modules.system.boot.timeoutStyle;
        configurationLimit = config.modules.system.boot.configurationLimit;
        useOSProber = config.modules.system.boot.useOSProber;
        bhairava-grub-theme.enable = config.modules.system.boot.theme.enable;

        extraFiles = mkIf config.modules.system.boot.advancedBios.enable {
          "DisplayEngine.efi" = ./assets/DisplayEngine.efi;
          "EFI/Boot/Bootx64.efi" = ./assets/Bootx64.efi;
          "Loader.efi" = ./assets/Loader.efi;
          "SREP_Config.cfg" = ./assets/SREP_Config.cfg;
          "SetupBrowser.efi" = ./assets/SetupBrowser.efi;
          "SuppressIFPatcher.efi" = ./assets/SuppressIFPatcher.efi;
          "UiApp.efi" = ./assets/UiApp.efi;
        };

        extraEntries =
          optionalString config.modules.system.boot.windowsDualBoot.enable ''
            menuentry "Windows 11" --class windows --class os {
              insmod part_gpt
              insmod fat
              search --no-floppy --fs-uuid --set=root 7443-B072
              chainloader /EFI/Microsoft/Boot/bootmgfw.efi
            }
            menuentry "Windows Recovery" --class windows --class settings {
              search --no-floppy --fs-uuid --set=root 7443-B072
              chainloader /EFI/Boot/Bootx64.efi
            }
          ''
          + optionalString config.modules.system.boot.advancedBios.enable ''
            menuentry 'Advanced UEFI Firmware Settings' --class settings {
              insmod fat
              insmod chain
              chainloader @bootRoot@/EFI/Boot/Bootx64.efi
            }
          '';
      };
    };
  };
}
