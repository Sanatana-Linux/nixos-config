{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.system.performance.cachy;
in {
  options.modules.system.performance.cachy = {
    enable = mkEnableOption "Enable cachy performance optimizations";
  };

  # BBR congestion control; the scheduler choice belongs to the kernel package,
  # so this module only tunes the network stack.
  config = mkIf cfg.enable {
    # Basic performance optimizations inspired by CachyOS.
    # NOTE: preempt=full is set on the Intel module (hardware/intel.nix); it is
    # deliberately not repeated here so the model has a single owner.
    boot.kernelParams = [];

    # Enable BBR congestion control
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = lib.mkForce "fq";
      "net.ipv4.tcp_congestion_control" = lib.mkForce "bbr";
    };
  };
}
