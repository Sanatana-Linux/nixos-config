{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.power.laptop;
in {
  options.modules.power.laptop = {
    enable = lib.mkEnableOption "laptop power management";

    cpuBoostOnAc = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "CPU boost on AC power";
    };

    cpuBoostOnBat = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "CPU boost on battery";
    };

    startChargeThreshold = lib.mkOption {
      type = lib.types.int;
      default = 40;
      description = "Battery charge start threshold";
    };

    stopChargeThreshold = lib.mkOption {
      type = lib.types.int;
      default = 80;
      description = "Battery charge stop threshold";
    };
  };

  config = lib.mkIf cfg.enable {
    powerManagement = {
      enable = true;
      powertop.enable = true; # Auto tune performance
    };
    
    boot.kernelModules = [ "cpupower" ];
    environment.systemPackages = [ config.boot.kernelPackages.cpupower ];

    services = {
      # thermal sensors and controls
      thermald.enable = true;
      # handle ACPI events
      acpid.enable = true;
      # Disable Power Profiles
      power-profiles-daemon.enable = false;

      tlp = {
        enable = true;
        settings = {
          CPU_BOOST_ON_AC = cfg.cpuBoostOnAc;
          CPU_BOOST_ON_BAT = cfg.cpuBoostOnBat;
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
          PLATFORM_PROFILE_ON_AC = "performance";
          PLATFORM_PROFILE_ON_BAT = "balanced";
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MAX_PERF_ON_BAT = 60;
          TLP_DEFAULT_MODE = "BAT";
          TLP_PERSISTENT_DEFAULT = 1;
          # Optional helps save long term battery health
          START_CHARGE_THRESH_BAT0 = cfg.startChargeThreshold;
          STOP_CHARGE_THRESH_BAT0 = cfg.stopChargeThreshold;
          DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi";
          DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi ";
        };
      };

      upower = {
        enable = true;
        # Adjusts the action taken at the point of the battery being critical
        criticalPowerAction = "Hibernate";
        percentageLow = 15;
        percentageCritical = 5;
        percentageAction = 4;
        usePercentageForPolicy = true;
      };
    };
  };
}
