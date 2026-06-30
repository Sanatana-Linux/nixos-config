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
      default = false;
      description = "Whether to use OS prober to discover other operating systems";
    };

    theme = {
      enable = mkEnableOption "Bhairava custom GRUB theme";
    };

    advancedBios = {
      enable = mkEnableOption "Advanced BIOS setup configuration";
    };

    development = {
      enable = mkEnableOption "UEFI development packages for working with and modifying UEFI firmware";
    };
  };

  config = mkIf config.modules.system.boot.enable {
    boot = {
      tmp.cleanOnBoot = true;

      kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore;

      blacklistedKernelModules = ["nouveau"];

      kernelModules = [
      ];

      extraModulePackages = [
      ];

    kernelParams = [
      "fbcon=nodefer"
      "splash"
      "quiet"
      "rd.udev.log_priority=3"
      # reboot=acpi prevents hangs on reboot by using ACPI reset instead of
      # the default EFI/PCI reset mechanisms, which can hang on some hardware
      "reboot=acpi"
      # Allow NVMe autonomous power state transitions up to 5500µs
      # (PS3-level sleep).  0 DISABLES APST entirely — the NVMe never
      # sleeps, PCIe root port stays in L0, PCH can't enter deep C-states.
      "nvme_core.default_ps_max_latency_us=5500"
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
      enableAllHardware = true;
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };

    environment.systemPackages = with pkgs;
      [
        nvme-cli
        grub2
        mesa
        mesa-demos
        plymouth
        kdePackages.plymouth-kcm
        linuxHeaders
        luajitPackages.ldbus
        xssproxy
      ]
      ++ optionals config.modules.system.boot.development.enable [
        efibootmgr
        efivar
        efitools
        uefi-run
        uefi-firmware-parser
        fiano
        efibooteditor
        edk2-uefi-shell
      ];

    boot.loader = {
      timeout = mkIf (config.modules.system.boot.timeoutStyle == "hidden") null;

      efi = {
        canTouchEfiVariables = true;

        efiSysMountPoint = "/boot/efi";
      };

      systemd-boot.enable = config.modules.system.boot.loader == "systemd-boot";

      grub = mkIf (config.modules.system.boot.loader == "grub") {
        enable = true;
        device = "nodev";
        efiSupport = true;
        timeoutStyle = config.modules.system.boot.timeoutStyle;
        configurationLimit = config.modules.system.boot.configurationLimit;
        useOSProber = false;
        bhairava-grub-theme.enable = config.modules.system.boot.theme.enable;

        extraFiles = mkIf config.modules.system.boot.advancedBios.enable {
          "DisplayEngine.efi" = ./assets/DisplayEngine.efi;
          "EFI/Boot/BootX64.efi" = ./assets/BootX64.efi;
          "Loader.efi" = ./assets/Loader.efi;
          "SREP_Config.cfg" = ./assets/SREP_Config.cfg;
          "SetupBrowser.efi" = ./assets/SetupBrowser.efi;
          "SuppressIFPatcher.efi" = ./assets/SuppressIFPatcher.efi;
          "UiApp.efi" = ./assets/UiApp.efi;
        };

        extraEntries = optionalString config.modules.system.boot.advancedBios.enable ''
          menuentry 'Advanced UEFI Firmware Settings' --class efi --class uefi  {
            insmod fat
            insmod chain
            search --no-floppy --set=root --file /EFI/Boot/BootX64.efi
            chainloader /EFI/Boot/BootX64.efi
          }
        '';
      };
    };
  };
}
