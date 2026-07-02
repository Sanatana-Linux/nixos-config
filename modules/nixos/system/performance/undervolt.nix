{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.system.performance.undervolt;

  # intel-undervolt config — undervolt + tjoffset only
  # Power limits are handled by services.throttled below
  undervoltConfig = ''
    # Enable elogind triggers
    enable no

    # CPU Undervolting
    undervolt 0 'CPU' ${toString cfg.coreOffset}
    undervolt 1 'GPU' ${toString cfg.gpuOffset}
    undervolt 2 'CPU Cache' ${toString cfg.cacheOffset}
    undervolt 3 'System Agent' ${toString cfg.saOffset}
    undervolt 4 'Analog I/O' ${toString cfg.ioOffset}

    # Critical Temperature Offset
    tjoffset ${toString cfg.tempOffset}

    # Daemon Update Interval
    interval 5000

    # Daemon Actions — undervolt and tjoffset only (power limits handled by throttled)
    daemon undervolt:once
    daemon tjoffset:once
  '';
in {
  options.modules.system.performance.undervolt = {
    enable = mkEnableOption "Intel CPU undervolting and throttling fixes";

    # P-State power limits
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

    # Undervolt values (intel-undervolt tool)
    coreOffset = mkOption {
      type = types.int;
      default = -120;
      description = "CPU core voltage offset in mV";
    };

    cacheOffset = mkOption {
      type = types.int;
      default = -120;
      description = "CPU cache voltage offset in mV";
    };

    gpuOffset = mkOption {
      type = types.int;
      default = -50;
      description = "GPU voltage offset in mV";
    };

    saOffset = mkOption {
      type = types.int;
      default = 0;
      description = "System Agent voltage offset in mV";
    };

    ioOffset = mkOption {
      type = types.int;
      default = 0;
      description = "Analog I/O voltage offset in mV";
    };

    tempOffset = mkOption {
      type = types.int;
      default = -20;
      description = "Temperature offset subtracted from max temp (e.g., -20 = 80°C limit on 100°C CPU)";
    };
  };

  config = mkIf cfg.enable {
    # P-State power limits via throttled (periodically re-applies PL1/PL2 limits)
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

    # intel-undervolt config file
    environment.etc."intel-undervolt.conf".text = undervoltConfig;

    # intel-undervolt daemon — applies undervolt + tjoffset at boot
    # Uses daemon mode with :once actions so settings are applied once on start
    systemd.services.intel-undervolt = {
      description = "Intel CPU Undervolting Daemon";
      wantedBy = ["multi-user.target"];
      after = ["sysinit.target"];
      path = with pkgs; [pkgs.intel-undervolt pkgs.bash pkgs.coreutils];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.intel-undervolt}/bin/intel-undervolt daemon";
        Restart = "on-failure";
        RestartSec = "5";
      };
    };
  };
}
