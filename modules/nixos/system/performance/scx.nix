{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.system.performance.scx;
in {
  options.modules.system.performance.scx = {
    enable = mkEnableOption "sched_ext (SCX) userspace CPU scheduler";

    scheduler = mkOption {
      type = types.str;
      default = "scx_lavd";
      description = ''
        Which SCX scheduler to run. `scx_lavd` is tuned for interactive /
        latency-critical workloads (gaming, multimedia, desktop) and is hybrid
        (P/E-core) aware; `scx_bpfland` is a good general-purpose desktop
        alternative; `scx_rusty` is the classic all-rounder. Requires a kernel
        built with `CONFIG_SCHED_CLASS_EXT` (the XanMod kernel has it) and the
        NixOS `services.scx` module, which asserts kernel >= 6.12.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["--performance"];
      description = "Extra flags passed to the selected SCX scheduler at runtime.";
    };
  };

  config = mkIf cfg.enable {
    services.scx = {
      enable = true;
      inherit (cfg) scheduler;
      inherit (cfg) extraArgs;
    };
  };
}
