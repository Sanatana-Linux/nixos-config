{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.performance.undervolt;
in {
  options.modules.performance.undervolt = {
    enable = mkEnableOption "Intel CPU undervolting and throttling fixes";

    # P-State power limits (missing from current implementation)
    p1Limit = mkOption {
      type = types.int;
      default = 150;
      description = "P1 state power limit in watts";
    };

    p1Window = mkOption {
      type = types.int;
      default = 300;
      description = "P1 state power limit window in seconds";
    };

    p2Limit = mkOption {
      type = types.int;
      default = 150;
      description = "P2 state power limit in watts";
    };

    p2Window = mkOption {
      type = types.int;
      default = 224;
      description = "P2 state power limit window in seconds";
    };
  };

  config = mkIf cfg.enable {
    # Enable fix for Intel CPU throttling with P-State limits
    services.throttled = {
      enable = true;
      extraConfig = ''
        [POWER]
        P1=${toString cfg.p1Limit}
        window1=${toString cfg.p1Window}
        P2=${toString cfg.p2Limit}
        window2=${toString cfg.p2Window}
      '';
    };

    # CPU undervolting configuration
    services.undervolt = {
      enable = true;
      tempBat = 85; # Maximum battery temperature
      uncoreOffset = -50; # in mV
      coreOffset = -50; # in mV
      package = pkgs.undervolt;
      verbose = true; # More logging
      turbo = 0; # Keep Intel Turbo feature enabled (1 for disabled)
    };
  };
}
