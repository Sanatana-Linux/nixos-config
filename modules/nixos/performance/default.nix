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
  ];

  options.modules.performance.default = {
    enable = mkEnableOption "Full performance optimization suite";
  };

  config = mkIf cfg.enable {
    # Enable all performance modules
    modules.performance = {
      zram.enable = true;
      oomd.enable = true;
      cachy.enable = true;
      undervolt.enable = true;
    };

    # Additional kernel sysctl settings from historical config
    boot.kernel.sysctl = {
      "vm.oom_kill_allocating_task" = true;
      "vm.oom_dump_tasks" = false;
      "kernel.sysrq" = lib.mkForce 438; # Magic SysRq key
      "lenovo-legion.force" = 1; # Laptop module
      "vm.overcommit_memory" = 1;
    };

    # BPF performance tuning
    services.bpftune.enable = true;
  };
}
