{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.amd;
in {
  options.modules.hardware.amd = {
    enable = mkEnableOption "AMD CPU and chipset support (Zen family, AM4/X570 boards)";

    sensors = mkOption {
      type = types.bool;
      default = true;
      description = "Load AMD and board hwmon drivers (k10temp, nct6775, asus_ec_sensors) for temperature, voltage, fan RPM and PWM";
    };

    powerManagement = mkOption {
      type = types.bool;
      default = true;
      description = "Enable AMD CPU power management tooling. The amd_pstate driver itself is configured by nixos-hardware's common/cpu/amd/pstate module.";
    };

    powerProfilesDaemon = mkOption {
      type = types.bool;
      default = false;
      description = "Use power-profiles-daemon to drive platform_profile and the amd_pstate EPP hint (power-saver / balanced / performance) at runtime. Suppresses the static CPU governor.";
    };

    virtualization = mkOption {
      type = types.bool;
      default = true;
      description = "Enable AMD-V (KVM, nested virtualization) and AMD IOMMU for VFIO device passthrough";
    };

    ecc = mkOption {
      type = types.bool;
      default = true;
      description = "Load AMD64 EDAC modules for ECC memory error reporting (inert on non-ECC systems)";
    };

    tuning = mkOption {
      type = types.bool;
      default = true;
      description = "Apply Zen latency/RCU kernel tuning (RCU callback offload, tick skew, TSC trust, NMI watchdog off)";
    };

    mitigations = mkOption {
      type = types.enum ["auto" "off"];
      default = "auto";
      description = ''
        CPU side-channel mitigations. "auto" keeps the kernel default (secure).
        "off" appends mitigations=off for maximum performance at a security
        cost — only appropriate on a physically trusted, single-tenant machine.
      '';
    };
  };

  config = mkIf cfg.enable {
    # AMD CPU / chipset kernel modules.
    #   msr                  — /dev/cpu/*/msr, read by turbostat/cpupower/zenmonitor
    #   kvm-amd              — AMD-V hardware virtualization
    #   ccp                  — Cryptographic Coprocessor (AES/SHA offload)
    #   sp5100_tco           — AMD FCH watchdog timer
    #   i2c-piix4            — AMD SMBus controller (backs the Super I/O sensor chip)
    #   x86_pkg_temp_thermal — package temperature sensor
    #   k10temp              — Zen 2 (Family 17h model 70h) Tdie/Tctl, per-CCD temp,
    #                          core/SoC current and voltage
    #   nct6775              — Nuvoton NCT6798D Super I/O: motherboard temperature,
    #                          voltages, fan RPM and PWM fan control
    #   asus_ec_sensors      — ASUS embedded-controller driver (mainline >= 5.18).
    #                          The Pro WS X570-ACE is an explicitly supported board:
    #                          adds chipset/VRM/T_Sensor temps, extra fan RPM and
    #                          CPU current/voltage the Super I/O chip does not expose.
    boot.kernelModules =
      [
        "msr"
        "kvm-amd"
        "ccp"
        "sp5100_tco"
        "i2c-piix4"
        "x86_pkg_temp_thermal"
      ]
      ++ optionals cfg.sensors [
        "k10temp"
        "nct6775"
        "asus_ec_sensors"
        "i2c-dev"
      ]
      ++ optionals cfg.ecc [
        "edac_mce_amd"
        "amd64_edac"
      ]
      ++ optionals cfg.virtualization [
        "vfio-pci"
      ];

    # amd_pstate=active is supplied by nixos-hardware's asus/pro-ws-x570-ace
    # module (which imports common/cpu/amd/pstate.nix) on kernel >= 6.3, so it
    # is not repeated here.
    #
    # power-profiles-daemon drives platform_profile and the amd_pstate EPP hint
    # (power-saver / balanced / performance) at runtime. While it is enabled the
    # governor is managed by the daemon, so a static governor is only pinned
    # otherwise — setting one alongside PPD would be silently overridden.
    services.power-profiles-daemon.enable = mkIf cfg.powerProfilesDaemon true;

    powerManagement.cpuFreqGovernor =
      mkIf (cfg.powerManagement && !cfg.powerProfilesDaemon) (mkDefault "schedutil");

    boot.kernelParams =
      # AMD IOMMU and KVM tuning for the virtualization stack (Docker, virt-manager).
      optionals cfg.virtualization [
        "amd_iommu=on"
        "iommu=pt"
        "kvm.ignore_msrs=1"
        "kvm_amd.nested=1"
      ]
      # Zen latency tuning: offload RCU callbacks from every CPU and shorten the
      # idle grace period so timer/wakeup jitter does not land on the cores.
      ++ optionals cfg.tuning [
        "rcu_nocbs=all"
        "rcutree.rcu_idle_gp_delay=0"
        "rcupdate.rcu_expedited=1"
        # De-synchronize the per-CPU tick so wake-ups do not align across CCXs.
        "skew_tick=1"
        # Zen has an invariant TSC; trust it and keep it out of IRQ accounting.
        "tsc=reliable"
        "tsc=noirqtime"
      ]
      ++ optional (cfg.mitigations == "off") "mitigations=off";

    boot.kernel.sysctl = mkIf cfg.tuning {
      # The NMI watchdog spends a perf counter on every package; disable it
      # along with the scheduler statistics that only matter under profiling.
      "kernel.nmi_watchdog" = 0;
      "kernel.sched_schedstats" = 0;
    };

    environment.systemPackages = with pkgs;
      [
        cpufrequtils
        # Userspace CPU tooling built from the running CachyOS kernel tree so
        # versions match: cpupower reports amd_pstate limits/EPP, turbostat
        # reports package power and per-core frequency (both need the msr module).
        config.boot.kernelPackages.cpupower
        config.boot.kernelPackages.turbostat
      ]
      ++ optionals cfg.sensors [lm_sensors]
      ++ optionals cfg.powerManagement [
        powertop
        zenmonitor # Zen MSR frequency/voltage/temperature monitor
      ]
      ++ optionals cfg.ecc [edac-utils];

    # Persist the hwmon module list for sensor and fan tooling.
    environment.etc."sysconfig/lm_sensors".text = mkIf cfg.sensors ''
      HWMON_MODULES="k10temp nct6775 asus_ec_sensors"
    '';
  };
}
