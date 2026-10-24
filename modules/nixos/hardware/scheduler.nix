{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.scheduler;

  # Applied through a oneshot instead of boot.kernel.sysctl so that a knob a
  # future kernel does not export cannot make systemd-sysctl fail at boot: each
  # key is written only when the running kernel actually provides it.
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
  '';
in {
  options.modules.hardware.scheduler = {
    enable = mkEnableOption "kernel scheduler latency tuning";
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
