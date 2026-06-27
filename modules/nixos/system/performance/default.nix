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
    ./oomd.nix
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
    };

    # Performance analysis tools
    environment.systemPackages = with pkgs; [peakperf];

    # Additional kernel sysctl settings from historical config
    # NOTE: overcommit_memory deliberately NOT set — kernel default (0, heuristic) is correct for desktop.
    # Mode 2 (strict accounting) with default 50% ratio caused ENOMEM on apps despite abundant free RAM.
    boot.kernel.sysctl = {
      "vm.oom_dump_tasks" = false;
      "kernel.sysrq" = lib.mkForce 176; # Magic SysRq key (176 = sync+unmount+reboot only)
      "lenovo-legion.force" = 1; # Laptop module
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      # Reduce writeback spikes that cause thermal bursts on NVMe
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
    };

    # BPF performance tuning — disabled: burns ~4% CPU for marginal benefit
    # on a desktop workload. The kernel's built-in heuristics are sufficient.
    services.bpftune.enable = false;
  };
}
