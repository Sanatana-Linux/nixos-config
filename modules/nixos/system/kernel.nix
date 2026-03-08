{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.kernel;
in {
  options.modules.system.kernel = {
    enable = mkEnableOption "Kernel configuration";

    lenovo-legion = {
      enable = mkEnableOption "Lenovo Legion laptop hardware profile (shared kernel/hardware config for bagalamukhi and matangi)";
    };

    useLatest = mkOption {
      type = types.bool;
      default = false;
      description = "Use the latest kernel packages";
    };

    plymouth.enable = mkEnableOption "Plymouth boot splash";

    initrd = {
      systemd = mkOption {
        type = types.bool;
        default = true;
        description = "Use systemd in initrd";
      };
      verbose = mkOption {
        type = types.bool;
        default = false;
        description = "Verbose initrd output";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # Base kernel configuration
    {
      boot = {
        kernelPackages = mkIf cfg.useLatest pkgs.linuxPackages_latest;
        initrd = {
          systemd.enable = cfg.initrd.systemd;
          verbose = cfg.initrd.verbose;
          compressor = "zstd";
          compressorArgs = ["-19"];
        };
        tmp.cleanOnBoot = true;
        plymouth.enable = cfg.plymouth.enable;
      };

      hardware = {
        enableAllFirmware = true;
        enableRedistributableFirmware = true;
      };

      environment.systemPackages = with pkgs;
        [
          linuxHeaders
        ]
        ++ optionals cfg.plymouth.enable [
          plymouth
          kdePackages.plymouth-kcm
        ];
    }

    # Lenovo Legion profile - enables all shared hardware config for both laptops
    (mkIf cfg.lenovo-legion.enable {
      boot = {
        kernelPackages = pkgs.linuxPackages_latest;

        initrd.kernelModules = [
          # NVIDIA modules
          "nvidia"
          "nvidiafb"
          "nvidia-drm"
          "nvidia-uvm"
          "nvidia-modeset"
          # Intel modules
          "intel_cstate"
          "aesni_intel"
          "intel_uncore"
          "intel_uncore_frequency"
          "intel_powerclamp"
        ];

        blacklistedKernelModules = ["nouveau"];

        kernelModules = [
          # Legion-specific
          "lenovo_legion"
          "ideapad"
          # Intel CPU
          "phc-intel"
          "cpupower"
          # ACPI
          "acpi_call"
        ];

        extraModulePackages = [
          config.boot.kernelPackages.acpi_call
          config.boot.kernelPackages.cpupower
          config.boot.kernelPackages.lenovo-legion-module
          config.boot.kernelPackages.nvidiaPackages.stable
        ];

        kernelParams = [
          # Base optimizations
          "mitigations=off"
          "preempt=full"
          "acpi_call"
          "fbcon=nodefer"
          "splash"
          "quiet"
          "rd.udev.log_priority=3"
          # NVIDIA parameters
          "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
          "nvidia-drm.modeset=1"
          # NVMe parameters
          "nvme_core.default_ps_max_latency_us=0"
          # Legion parameters
          "lenovo-legion.force=1"
        ];
      };

      environment.systemPackages = with pkgs; [
        cpufrequtils
        config.boot.kernelPackages.acpi_call
        nvme-cli
        lenovo-legion
      ];
    })
  ]);
}
