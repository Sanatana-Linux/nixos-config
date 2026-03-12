{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.performance.cachy;
in {
  options.modules.performance.cachy = {
    enable = mkEnableOption "Enable cachy performance optimizations";
  };

  # Note: CachyOS tweaks disabled for now as the flake input needs proper integration
  # TODO: Integrate cachy-tweaks flake properly through specialArgs
  config = mkIf cfg.enable {
    # Basic performance optimizations inspired by CachyOS
    boot.kernelParams = [
      "mitigations=off" # Disable CPU mitigations for performance
      "preempt=full" # Enable full preemption
    ];

    # Enable BBR congestion control
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = lib.mkForce "fq";
      "net.ipv4.tcp_congestion_control" = lib.mkForce "bbr";
    };
  };
}
