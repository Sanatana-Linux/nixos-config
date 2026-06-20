{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.performance.default;
in {
  imports = [
    ./zram.nix
    ./oomd.nix
    ./cachy.nix
    ./undervolt.nix
    ./cooling.nix
  ];

  options.modules.performance.default = {
    enable = mkEnableOption "Full performance optimization suite";
  };

  config = mkIf cfg.enable {
    # Enable all performance modules
    modules.performance = {
      zram.enable = mkDefault true;
      oomd.enable = mkDefault true;
      cachy.enable = mkDefault true;
      undervolt.enable = mkDefault true;
      cooling.enable = mkDefault true;
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
    };

    # BPF performance tuning
    services.bpftune.enable = true;
  };
}
