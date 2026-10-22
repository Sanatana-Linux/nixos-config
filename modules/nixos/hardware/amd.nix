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

    monitoring = mkOption {
      type = types.bool;
      default = true;
      description = "Load the out-of-tree ryzen_smu module and install ryzen-monitor-ng and zenstates for AMD SMU power/P-state telemetry and tuning";
    };

    pstateMode = mkOption {
      type = types.enum ["active" "guided" "passive"];
      default = "guided";
      description = ''
        amd_pstate operating mode. "active" is EPP-based and requires CPU
        support for the CPPC Energy Performance Preference; Zen 2 (Ryzen 3000)
        does not provide it reliably and "active" can pin the cores to the
        lowest non-linear frequency. "guided" (OS sets min/max, firmware picks
        within range) is correct for Zen 2; "passive" (governor drives the
        target) is the fallback. Only Zen 3+ should use "active".
      '';
    };

    preemptFull = mkOption {
      type = types.bool;
      default = true;
      description = "Set preempt=full on the kernel command line. The kernel is built with PREEMPT_DYNAMIC, so this is a pure command-line choice; it lowers scheduling latency under load at the cost of slightly higher idle power.";
    };

    zenpower = mkOption {
      type = types.bool;
      default = false;
      description = "Use the out-of-tree zenpower driver instead of k10temp for richer per-core/SoC Zen telemetry. Requires boot.kernelPackages.zenpower to build for the running kernel.";
    };

    maxCstate = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 5;
      description = "Cap the deepest CPU C-state via processor.max_cstate=N. null leaves the firmware default. Use 5 to work around Zen idle-freeze (C6) hangs.";
    };

    x2apicWorkaround = mkOption {
      type = types.bool;
      default = false;
      description = "Append nox2apic to the kernel command line. Kernel-side workaround for firmware whose broken X2APIC prevents amd_pstate from loading (dmesg: '_CPC object is not present'). The preferred fix is the BIOS APIC setting (XAPIC).";
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
    #   ryzen_smu            — out-of-tree SMU driver; exposes per-rail power and
    #                          P-state telemetry to ryzen-monitor-ng and zenstates.
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
        "nct6775"
        "asus_ec_sensors"
        "i2c-dev"
      ]
      # k10temp and zenpower both claim the Zen temperature interface; zenpower
      # supersedes k10temp when enabled.
      ++ optionals (cfg.sensors && !cfg.zenpower) [
        "k10temp"
      ]
      ++ optionals cfg.zenpower [
        "zenpower"
      ]
      ++ optionals cfg.ecc [
        "edac_mce_amd"
        "amd64_edac"
      ]
      ++ optionals cfg.virtualization [
        "vfio-pci"
      ]
      ++ optionals cfg.monitoring [
        "ryzen_smu" # out-of-tree SMU driver (ryzen-monitor-ng, zenstates)
      ];

    # Out-of-tree modules: ryzen_smu (SMU telemetry) and optionally zenpower.
    boot.extraModulePackages =
      optionals cfg.monitoring [
        config.boot.kernelPackages.ryzen-smu
      ]
      ++ optionals cfg.zenpower [
        config.boot.kernelPackages.zenpower
      ];

    boot.blacklistedKernelModules = mkIf cfg.zenpower ["k10temp"];

    # The amd_pstate operating mode is set from cfg.pstateMode below. The
    # amd_pstate driver itself is provided by the kernel (or by nixos-hardware's
    # common/cpu/amd/pstate module, which also emits amd_pstate=active — ours is
    # appended afterwards so it takes precedence).
    #
    # power-profiles-daemon drives platform_profile and the amd_pstate EPP hint
    # (power-saver / balanced / performance) at runtime. While it is enabled the
    # governor is managed by the daemon, so a static governor is only pinned
    # otherwise — setting one alongside PPD would be silently overridden.
    services.power-profiles-daemon.enable = mkIf cfg.powerProfilesDaemon true;

    powerManagement.cpuFreqGovernor =
      mkIf (cfg.powerManagement && !cfg.powerProfilesDaemon) (mkDefault "schedutil");

    # mkAfter appends these after nixos-hardware's pstate module, which
    # hard-codes `amd_pstate=active` on kernel >= 6.3 with no CPU-generation
    # guard. The last `amd_pstate=` on the command line wins, so ours takes
    # effect regardless of that module.
    boot.kernelParams = mkAfter (
      ["amd_pstate=${cfg.pstateMode}"]
      # Full preemption (PREEMPT_DYNAMIC kernel) — lowest scheduling latency
      # under load; the desktop-responsiveness preemption setting.
      ++ optional cfg.preemptFull "preempt=full"
      # Optional C-state cap to work around Zen idle-freeze (C6) hangs.
      ++ optional (cfg.maxCstate != null) "processor.max_cstate=${toString cfg.maxCstate}"
      # Optional kernel-side X2APIC workaround (prefer the BIOS APIC=XAPIC fix).
      ++ optional cfg.x2apicWorkaround "nox2apic"
      # AMD IOMMU and KVM tuning for the virtualization stack (Docker, virt-manager).
      ++ optionals cfg.virtualization [
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
      ++ optional (cfg.mitigations == "off") "mitigations=off"
    );

    boot.kernel.sysctl = mkIf cfg.tuning {
      # The NMI watchdog spends a perf counter on every package; disable it
      # along with the scheduler statistics that only matter under profiling.
      "kernel.nmi_watchdog" = 0;
      "kernel.sched_schedstats" = 0;

      # BORE (Burst-Oriented Response Enhancer) tuning. The cachyos kernel is
      # built CONFIG_SCHED_BORE=y. These are scheduler-latency knobs; values are
      # the upstream-recommended desktop/responsiveness set for an always-on
      # workstation. sched_bore=1 (enabled) is already the kernel default.
      # Child tasks inherit half the parent's burst score on fork — keeps a
      # forking desktop app responsive instead of each child starting cold.
      "kernel.sched_burst_fork_atavistic" = 2;
      # Penalise tasks that burn their full slice so interactive ones win.
      "kernel.sched_burst_penalty_offset" = 22;
      "kernel.sched_burst_penalty_scale" = 1280;
      # Exclude tasks that ran their full slice from the cache bonus.
      "kernel.sched_burst_exclude_kthreads" = 1;
    };

    # Force the amd_pstate operating mode at runtime. The command-line parameter
    # above is authoritative, but this guarantees the mode even if firmware or
    # another layer left the driver in a different state at boot. It is a no-op
    # when the driver is absent (e.g. an acpi-cpufreq fallback) because the
    # status path does not exist.
    systemd.services.amd-pstate-mode = {
      description = "Set amd_pstate operating mode to ${cfg.pstateMode}";
      wantedBy = ["multi-user.target"];
      after = ["sysinit.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = [pkgs.coreutils pkgs.bash];
      script = ''
        status=/sys/devices/system/cpu/amd_pstate/status
        if [ -w "$status" ]; then
          echo ${cfg.pstateMode} > "$status" || true
        fi
      '';
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
      ++ optionals cfg.ecc [edac-utils]
      ++ optionals cfg.monitoring [
        ryzen-monitor-ng # SMU power/temperature/frequency monitor
        zenstates # P-state / SMU tuning
      ];

    # Persist the hwmon module list for sensor and fan tooling.
    environment.etc."sysconfig/lm_sensors".text = mkIf cfg.sensors ''
      HWMON_MODULES="${
        if cfg.zenpower
        then "zenpower"
        else "k10temp"
      } nct6775 asus_ec_sensors"
    '';
  };
}
