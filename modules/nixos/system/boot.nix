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
      enable = mkEnableOption "UEFI firmware settings entry in the GRUB boot menu";
    };

    development = {
      enable = mkEnableOption "UEFI development packages for working with and modifying UEFI firmware";
    };
  };

  config = mkIf config.modules.system.boot.enable {
    boot = {
      tmp.cleanOnBoot = true;

      kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;

      blacklistedKernelModules = ["nouveau"];

      kernelModules = [
      ];

      extraModulePackages = [
      ];

      kernelParams =
        [
          "fbcon=nodefer"
          "splash"
          "quiet"
          "rd.udev.log_priority=3"
          # reboot=acpi prevents hangs on reboot by using ACPI reset instead of
          # the default EFI/PCI reset mechanisms, which can hang on some hardware
          "reboot=acpi"
          # 0 DISABLES NVMe autonomous power-state transitions (APST) entirely:
          # the NVMe never sleeps, so an I/O never waits on a power-state
          # wakeup. This is the lowest-latency setting (a value like 5500
          # permits PS3-level sleep and adds microseconds-to-milliseconds of
          # wakeup latency on idle->busy transitions). Trade-off: the drive and
          # PCIe root port stay in L0, so idle power and heat rise — the reason
          # this was previously 5500.
          "nvme_core.default_ps_max_latency_us=0"
          # Thread hard-IRQ handlers (CONFIG_IRQ_FORCED_THREADING=y) so their
          # bottom halves are preemptible — lowers input/audio jitter.
          "threadirqs"
          # Batch RCU callbacks and flush after a delay instead of executing
          # immediately (kernel has CONFIG_RCU_LAZY=y, default off). Fewer
          # wakeups -> less idle jitter and lower power on a laptop.
          "rcutree.enable_rcu_lazy=1"
          # PCIe ASPM for the whole bus, including the PCH-attached CNVi WiFi.
          # policy=default caps links at L1.1; policy=powersave additionally
          # permits L1.2, which is a known cause of periodic CNVi disconnects —
          # the link drops on an idle timer and recovers on the next
          # association. Note pcie_aspm=force does NOT override the firmware
          # here; it defers to whatever the BIOS advertises.
          "pcie_aspm=on"
          "pcie_aspm.policy=default"
        ]
        # Intel-only: prefer the acpi-cpufreq governor over intel_pstate. On
        # Intel 14th-gen mobile (i9-14900HX) the passive governor sometimes
        # reaches better idle power states than intel_pstate active mode.
        # Gated on the Intel module so it is not emitted on AMD/other hosts,
        # where intel_pstate does not exist.
        ++ optionals config.modules.hardware.intel.enable [
          "intel_pstate=passive"
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
          menuentry 'UEFI Firmware Settings' --class efi --class uefi  {
            fwsetup
          }
        '';
      };
    };
  };
}
