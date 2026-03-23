{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.performance.oomd;
in {
  options.modules.performance.oomd = {
    enable = mkEnableOption "Out-of-Memory daemon and related services";
  };

  config = mkIf cfg.enable {
    # Systemd OOMd configuration
    # Fedora enables these options by default
    systemd.oomd = {
      enable = true;
      enableRootSlice = true; # Root slice monitoring
      enableUserSlices = true; # User slice monitoring
      enableSystemSlice = true; # System slice monitoring
      settings.OOM = {
        "DefaultMemoryPressureDurationSec" = "8s"; # Time after memory pressure to take action
      };
    };

    # Additional memory management services
    services = {
      irqbalance.enable = true; # Distributes hardware interrupts to processors
      earlyoom.enable = true; # Early OOM killer before it gets bad
    };
  };
}
