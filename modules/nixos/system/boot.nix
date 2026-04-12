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
    # Copy EFI files to ESP for UEFI firmware access
    system.activationScripts.advancedBiosFiles = mkIf config.modules.system.boot.advancedBios.enable ''
      mkdir -p /boot/efi/EFI/Boot
      cp ${./assets/BootX64.efi} /boot/efi/EFI/Boot/BootX64.efi
      cp ${./assets/DisplayEngine.efi} /boot/efi/DisplayEngine.efi
      cp ${./assets/Loader.efi} /boot/efi/Loader.efi
      cp ${./assets/SREP_Config.cfg} /boot/efi/SREP_Config.cfg
      cp ${./assets/SetupBrowser.efi} /boot/efi/SetupBrowser.efi
      cp ${./assets/SuppressIFPatcher.efi} /boot/efi/SuppressIFPatcher.efi
      cp ${./assets/UiApp.efi} /boot/efi/UiApp.efi
      chmod 644 /boot/efi/EFI/Boot/BootX64.efi
      chmod 644 /boot/efi/*.efi /boot/efi/*.cfg
    '';

    boot = {
      tmp.cleanOnBoot = true;

      kernelPackages = pkgs.linuxPackages_xanmod_latest;

      blacklistedKernelModules = ["nouveau"];

      kernelModules = [
      ];

      extraModulePackages = [
      ];

      kernelParams = [
        "fbcon=nodefer"
        "splash"
        "quiet"
        "usbcore.autosuspend=-1"
        "rd.udev.log_priority=3"
        "nvme_core.default_ps_max_latency_us=0"
        "nmi_watchdog=0"
        "nowatchdog"
        "nosoftlockup"
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

        extraEntries = optionalString config.modules.system.boot.advancedBios.enable ''
          menuentry 'Advanced UEFI Firmware Settings' --class efi --class uefi  {
            insmod fat
            insmod chain
            chainloader @bootRoot@/EFI/Boot/BootX64.efi
          }
        '';
      };
    };
  };
}
