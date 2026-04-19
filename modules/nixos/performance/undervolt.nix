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
      default = 28;
      description = "P1 state power limit window in seconds";
    };

    p2Limit = mkOption {
      type = types.int;
      default = 150;
      description = "P2 state power limit in watts";
    };

    p2Window = mkOption {
      type = types.int;
      default = 24;
      description = "P2 state power limit window in seconds";
    };
  };

  config = mkIf cfg.enable {
    # Enable fix for Intel CPU throttling with P-State limits
    services.throttled = {
      enable = true;
      extraConfig = ''
        [GENERAL]
        # Enable or disable the script execution
        Enabled: True
        # SYSFS path for checking if the system is running on AC power
        Sysfs_Power_Path: /sys/class/power_supply/AC*/online

        [BATTERY]
        # Update the registers every this many seconds
        Update_Rate_s: 30
        # Max package power for time window #1
        PL1_Tdp_W: ${toString cfg.p1Limit}
        # Time window #1 duration
        PL1_Duration_s: ${toString cfg.p1Window}
        # Max package power for time window #2
        PL2_Tdp_W: ${toString cfg.p2Limit}
        # Time window #2 duration
        PL2_Duration_S: ${toString cfg.p2Window}

        [AC]
        # Update the registers every this many seconds
        Update_Rate_s: 5
        # Max package power for time window #1
        PL1_Tdp_W: ${toString cfg.p1Limit}
        # Time window #1 duration
        PL1_Duration_s: ${toString cfg.p1Window}
        # Max package power for time window #2
        PL2_Tdp_W: ${toString cfg.p2Limit}
        # Time window #2 duration
        PL2_Duration_S: ${toString cfg.p2Window}
      '';
    };

    # CPU undervolting configuration
    services.undervolt = {
      enable = true;
      tempBat = 85; # Maximum battery temperature
      uncoreOffset = -40; # in mV
      coreOffset = -90; # in mV
      package = pkgs.undervolt;
      verbose = true; # More logging
      turbo = 0; # Keep Intel Turbo feature enabled (1 for disabled)
    };
  };
}
