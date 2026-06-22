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

  # Note: CachyOS tweaks disabled for now as the flake input needs proper integration
  # TODO: Integrate cachy-tweaks flake properly through specialArgs
  config = mkIf cfg.enable {
    # Basic performance optimizations inspired by CachyOS
    # NOTE: preempt=full is intentionally NOT set — it prevents the CPU from
    # entering deep C-states (idle power savings), generating excess heat.
    # intel_pstate + powersave governor handles dynamic scaling better.
    boot.kernelParams = [];

    # Enable BBR congestion control
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = lib.mkForce "fq";
      "net.ipv4.tcp_congestion_control" = lib.mkForce "bbr";
    };
  };
}
