{
  config,
  lib,
  pkgs,
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
        NixOS `services.scx-loader` module, which asserts kernel >= 6.12.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["--performance"];
      description = "Extra flags passed to the selected SCX scheduler at runtime.";
    };
  };

  config = mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isx86_64) {
    # SCX BPF schedulers are x86_64-focused; the loader/packages do not apply
    # (or build) on aarch64 hosts such as the Raspberry Pi.
    services.scx-loader = {
      enable = true;
      schedsPackages = [pkgs.scx.full];
      config.default_sched = cfg.scheduler;
    };
  };
}
