{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.system.performance.undervolt;
in {
  options.modules.system.performance.undervolt = {
    enable = mkEnableOption "Intel CPU undervolting and throttling fixes";

    # P-State power limits (missing from current implementation)
    p1Limit = mkOption {
      type = types.int;
      default = 45;
      description = "P1 state (sustained) power limit in watts. Lower values reduce VRM heat. The i9-14900HX base TDP is 55W; 45W is a safe sustained target that significantly reduces VRM load.";
    };

    p1Window = mkOption {
      type = types.int;
      default = 28;
      description = "P1 state power limit window in seconds";
    };

    p2Limit = mkOption {
      type = types.int;
      default = 65;
      description = "P2 state (turbo) power limit in watts. Lower values reduce VRM heat spikes. The default of 100W causes excessive VRM temperatures on the Legion 5 Pro.";
    };

    p2Window = mkOption {
      type = types.int;
      default = 8;
      description = "P2 state power limit window in seconds. Shorter windows limit the duration of high-current VRM stress during turbo boost.";
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
      tempAc = 80; # Maximum AC temperature — throttle before VRM hits danger zone
      tempBat = 75; # Maximum battery temperature
      uncoreOffset = -65; # in mV — aggressive uncore undervolt reduces VRM current draw
      coreOffset = -120; # in mV — deeper core undervolt
      gpuOffset = -50; # in mV — undervolt the GPU slice too
      package = pkgs.undervolt;
      verbose = true;
      turbo = 0; # Keep Intel Turbo feature enabled (1 for disabled)
    };
  };
}
