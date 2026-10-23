{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.scheduler;

  # Applied through a oneshot instead of boot.kernel.sysctl because the hosts do
  # not all run the same kernel: XanMod mainline (CONFIG_SCHED_BORE unset) on
  # bagalamukhi, kamala, matangi and bhairavi, CachyOS BORE on chhinamasta. A
  # sysctl key the kernel does not export makes systemd-sysctl fail at boot, so
  # each knob is written only when the running kernel actually provides it.
  script = ''
    apply() {
      local path="/proc/sys/$1"
      if [ -w "$path" ]; then
        echo "$2" > "$path"
      fi
    }

    # The NMI watchdog spends a perf counter per package for a watchdog nothing
    # here relies on.
    apply kernel.nmi_watchdog 0
    # Scheduler statistics are profiling-only accounting on the wakeup path.
    apply kernel.sched_schedstats 0
    # Keep a timer on the CPU that armed it. Timer migration chases idle CPUs to
    # save power, which costs a cross-CPU interrupt on the next wakeup — the
    # wrong trade on a latency-first desktop.
    apply kernel.timer_migration 0

    ${optionalString cfg.bore ''
      # BORE (Burst-Oriented Response Enhancer), CachyOS kernels only. These
      # are the CachyOS desktop defaults, pinned explicitly so a future kernel
      # default change cannot silently alter wakeup behaviour.
      apply kernel.sched_bore 1
      # Burst-score decay window in nanoseconds (75 ms).
      apply kernel.sched_burst_cache_lifetime 75000000
      # Offset a task must exceed before any burst penalty applies, so
      # short-lived wakeups (input, compositor) never pay one.
      apply kernel.sched_burst_penalty_offset 24
      # Penalty scale for a task that burns its full slice; lower than the
      # 1536 default, so CPU-bound work yields to interactive tasks sooner.
      apply kernel.sched_burst_penalty_scale 1280
      # Smooth the burst score across wakeups to avoid score spikes.
      apply kernel.sched_burst_smoothness 1
    ''}
  '';
in {
  options.modules.hardware.scheduler = {
    enable = mkEnableOption "kernel scheduler latency tuning";

    bore = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Also apply the CachyOS BORE burst-scheduler knobs. They are written only
        when the running kernel exports them (CONFIG_SCHED_BORE=y), so this is a
        no-op on XanMod mainline, which carries no BORE patch.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.sched-latency-tuning = {
      description = "Apply the scheduler latency knobs this kernel provides";
      wantedBy = ["multi-user.target"];
      after = ["sysinit.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = [pkgs.bash pkgs.coreutils];
      inherit script;
    };
  };
}
