{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.system.performance.default;
in {
  imports = [
    ./cachy.nix
    ./hugepages.nix
    ./oomd.nix
    ./scx.nix
    ./undervolt.nix
    ./zram.nix
  ];

  options.modules.system.performance.default = {
    enable = mkEnableOption "Full performance optimization suite";
  };

  config = mkIf cfg.enable {
    # Enable all performance modules
    modules.system.performance = {
      zram.enable = mkDefault true;
      oomd.enable = mkDefault true;
      cachy.enable = mkDefault true;
      undervolt.enable = mkDefault true;
      hugepages.enable = mkDefault true;
      scx.enable = mkDefault true;
    };

    # Performance analysis tools
    environment.systemPackages = with pkgs; [peakperf];

    # Additional kernel sysctl settings from historical config
    # NOTE: overcommit_memory deliberately NOT set — kernel default (0, heuristic) is correct for desktop.
    # Mode 2 (strict accounting) with default 50% ratio caused ENOMEM on apps despite abundant free RAM.
    boot.kernel.sysctl = {
      "vm.oom_dump_tasks" = false;
      "kernel.sysrq" = lib.mkForce 176; # Magic SysRq key (176 = sync+unmount+reboot only)
      # With zram (compressed RAM swap) "swap" is cheaper than evicting the page
      # cache, so a high swappiness keeps file pages hot and pushes cold
      # anonymous pages into zram instead. CachyOS ships 150 with zram active;
      # the kernel docs suggest values beyond 100 for in-memory swap.
      "vm.swappiness" = 150;
      "vm.vfs_cache_pressure" = 50;
      # Reduce writeback spikes that cause thermal bursts on NVMe
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      # Smooth writeback — 5s intervals instead of 15s default
      # prevents large writeback bursts that cause thermal spikes
      "vm.dirty_writeback_centisecs" = 500;
      # Start background reclaim a little earlier so bursty allocations
      # (large parallel Nix builds) hit kswapd instead of stalling in direct
      # reclaim. Default is 10.
      "vm.watermark_scale_factor" = 100;
      # zram: read one page per fault instead of a swap cluster, which is keyed
      # to rotational-disk seek amortisation and meaningless for RAM-backed swap
      # — lowers swap-in latency and random-read amplification.
      "vm.page-cluster" = 0;
      # zram: the watermark boost is designed for disk-backed swap and only adds
      # reclaim churn during large bursts on a RAM-backed device.
      "vm.watermark_boost_factor" = 0;
      # Large address-space consumers (games under Proton/Wine, Electron apps,
      # CUDA/JIT workloads) exceed the 65536 default and abort with ENOMEM.
      "vm.max_map_count" = 1048576;
      # Dev tooling and file watchers need more than the default inotify limits,
      # otherwise watchers silently miss events (stale editors/tests).
      "fs.inotify.max_user_instances" = 1024;
      "fs.inotify.max_user_watches" = 524288;
      # Group processes by session for better desktop responsiveness
      "kernel.sched_autogroup_enabled" = lib.mkForce 1;
    };

    # Protect the desktop working set from thrashing under memory pressure.
    # min_ttl_ms=1000 prevents the most recently-used ~1s working set from being
    # evicted; per the kernel docs this "usually eliminates intolerable desktop
    # janks due to thrashing". /sys/kernel/mm/lru_gen is not a sysctl, so it is
    # written via tmpfiles.
    systemd.tmpfiles.rules = [
      "w /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 1000"
    ];

    # Reduce NVMe queue depth for lower latency on desktop workloads, and use
    # the kernel's ADIOS (Adaptive Deadline I/O Scheduler) on NVMe. ADIOS is a
    # low-latency, learning-based blk-mq scheduler (CachyOS ships it in-tree) —
    # it beats `none` under mixed read/write desktop I/O. If it ever regresses,
    # revert this attribute to "none".
    services.udev.extraRules = ''
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ENV{DEVTYPE}=="disk", ATTR{queue/nr_requests}="512", ATTR{queue/scheduler}="adios"
    '';

    # BPF performance tuning — disabled: burns ~4% CPU for marginal benefit
    # on a desktop workload. The kernel's built-in heuristics are sufficient.
    services.bpftune.enable = false;
  };
}
