{
  config,
  lib,
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
  };

  config = mkIf config.modules.system.boot.enable {
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
          "DisplayEngine.efi" = ../../../assets/bios/DisplayEngine.efi;
          "EFI/Boot/Bootx64.efi" = ../../../assets/bios/Bootx64.efi;
          "Loader.efi" = ../../../assets/bios/Loader.efi;
          "SREP_Config.cfg" = ../../../assets/bios/SREP_Config.cfg;
          "SetupBrowser.efi" = ../../../assets/bios/SetupBrowser.efi;
          "SuppressIFPatcher.efi" = ../../../assets/bios/SuppressIFPatcher.efi;
          "UiApp.efi" = ../../../assets/bios/UiApp.efi;
        };

        # Combined extra entries for Windows Dual Boot and Advanced BIOS
        extraEntries = 
          optionalString config.modules.system.boot.windowsDualBoot.enable ''
            menuentry "Windows 11" --class windows --class os {
              insmod part_gpt
              insmod fat
              search --no-floppy --fs-uuid --set=root 7443-B072
              chainloader /EFI/Microsoft/Boot/bootmgfw.efi
            }
            menuentry "System Setup" {
              fwsetup
            }
            menuentry "Recovery" {
              search --no-floppy --fs-uuid --set=root 7443-B072
              chainloader /EFI/Boot/Bootx64.efi
            }
          '' +
          optionalString config.modules.system.boot.advancedBios.enable ''
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
