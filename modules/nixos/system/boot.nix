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

    advancedBios = {
      enable = mkEnableOption "Advanced BIOS setup configuration";
    };
  };

  config = mkIf config.modules.system.boot.enable {
    boot = {
      tmp.cleanOnBoot = true;

      kernelPackages = pkgs.linuxPackages_latest;

      blacklistedKernelModules = ["nouveau"];

      kernelModules = [
        "i2c-dev" # Userspace I2C access (often needed by DDC/CI tools)
        "i2c-i801" # Intel SMBus driver (common motherboard controller)
      ];

      extraModulePackages = [
      ];

      kernelParams = [
        "fbcon=nodefer" # Prevent framebuffer console deferral (faster boot display)
        "splash" # Show splash screen during boot
        "quiet" # Reduce kernel log verbosity
        "usbcore.autosuspend=-1" # Disable USB autosuspend (fixes issues with some peripherals)
        "rd.udev.log_priority=3" # Reduce udev log verbosity in initrd
        "nvme_core.default_ps_max_latency_us=0" # Prevent NVMe power saving latency issues
      ];

      plymouth.enable = true;

      initrd = {
        systemd.enable = true;
        verbose = false;
        compressor = "zstd";
        compressorArgs = ["-19"];
        kernelModules = [
        ];
      };
    };

    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };

    environment.systemPackages = with pkgs; [
      cpufrequtils
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

        extraEntries = optionalString config.modules.system.boot.advancedBios.enable ''
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
