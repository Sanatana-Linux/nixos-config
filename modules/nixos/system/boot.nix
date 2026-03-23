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

    development = {
      enable = mkEnableOption "UEFI development packages for working with and modifying UEFI firmware";
    };

    zfs = {
      enable = mkEnableOption "ZFS filesystem support";
    };
  };

  config = mkMerge [
    (mkIf config.modules.system.boot.enable {
      boot = {
        tmp.cleanOnBoot = true;

        kernelPackages = mkDefault pkgs.linuxPackages;

        blacklistedKernelModules = ["nouveau"];

        extraModulePackages = [
        ];

        kernelParams = [
          "fbcon=nodefer"
          "splash"
          "quiet"
          "usbcore.autosuspend=-1"
          "rd.udev.log_priority=3"
          "nvme_core.default_ps_max_latency_us=0"
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
            menuentry 'Advanced UEFI Firmware Settings' --class efi --class uefi {
              insmod fat
              insmod chain
              chainloader @bootRoot@/EFI/Boot/BootX64.efi
            }
          '';
        };
      };
    })

    (mkIf config.modules.system.boot.zfs.enable {
      boot.supportedFilesystems = ["zfs"];
      boot.zfs.devNodes = "/dev/disk/by-id";
      boot.kernelPackages = pkgs.linuxPackages;
      boot.kernelParams = [
        "zfs.zfs_arc_max=12884901888" # 12GB Max ARC value
        "zfs.zfs_arc_min=4294967296" # 4GB Min ARC value
      ];
      boot.zfs.forceImportAll = false;
      boot.zfs.forceImportRoot = false;
      boot.zfs.package = pkgs.zfs_unstable;
      services.zfs.autoScrub.enable = true;
      services.zfs.trim.enable = true;
      systemd.services.zfs-mount.enable = false;
      environment.etc."machine-id".source = "/state/etc/machine-id";
      environment.etc."zfs/zpool.cache".source = "/state/etc/zfs/zpool.cache";

      boot.loader = {
        generationsDir.copyKernels = true;
        # for problematic UEFI firmware
        grub.efiInstallAsRemovable = true;
        grub.enable = true;
        grub.copyKernels = true;
        grub.efiSupport = true;
        grub.zfsSupport = true;
        # for systemd-autofs
        grub.extraPrepareConfig = ''
          ${pkgs.coreutils}/bin/mkdir -p /boot/efis
          for i in /boot/efis/*; do ${pkgs.util-linux}/bin/mount $i ; done
        '';
        grub.extraInstallCommands = ''
          export ESP_MIRROR=$(${pkgs.coreutils}/bin/mktemp -d -p /tmp)
          ${pkgs.coreutils}/bin/cp -r /boot/efis/nvme-SKHynix_HFS001TEJ9X115N_AMD1N001811901C38_1-part1/EFI $ESP_MIRROR
          for i in /boot/efis/*; do
          ${pkgs.coreutils}/bin/cp -r $ESP_MIRROR/EFI $i
          done
          ${pkgs.coreutils}/bin/rm -rf $ESP_MIRROR
        '';
      };
    })
  ];
}
