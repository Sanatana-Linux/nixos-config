{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.sleep;
in {
  options.modules.system.sleep = {
    enable = mkEnableOption "System sleep/power management (logind + UPower)";

    lidCloseAction = mkOption {
      type = types.enum ["ignore" "lock" "suspend" "hibernate" "hybrid-sleep" "poweroff"];
      default = "suspend";
      description = "Action when laptop lid is closed on battery power";
    };

    lidCloseActionExternalPower = mkOption {
      type = types.nullOr (types.enum ["ignore" "lock" "suspend" "hibernate" "hybrid-sleep" "poweroff"]);
      default = null;
      description = "Action when laptop lid is closed on AC power. null = same as lidCloseAction";
    };

    powerKeyAction = mkOption {
      type = types.enum ["ignore" "lock" "suspend" "hibernate" "hybrid-sleep" "poweroff"];
      default = "suspend";
      description = "Action when power button is pressed briefly";
    };

    powerKeyLongPressAction = mkOption {
      type = types.enum ["ignore" "lock" "suspend" "hibernate" "hybrid-sleep" "poweroff"];
      default = "poweroff";
      description = "Action when power button is held";
    };

    idleAction = mkOption {
      type = types.nullOr (types.enum ["ignore" "lock" "suspend" "hibernate" "hybrid-sleep" "poweroff"]);
      default = "suspend";
      description = "Action when system is idle. null = no idle action";
    };

    idleTimeout = mkOption {
      type = types.str;
      default = "20min";
      description = "Idle time before idleAction triggers (e.g. '5min', '20min', '1h')";
    };

    criticalBatteryAction = mkOption {
      type = types.enum ["PowerOff" "Hibernate" "HybridSleep" "Suspend" "Ignore"];
      default = "Hibernate";
      description = "UPower action when battery reaches critical level. `Suspend` and `Ignore` require `allowRiskyCriticalPowerAction`.";
    };

    allowRiskyCriticalPowerAction = mkOption {
      type = types.bool;
      default = false;
      description = "Allow the risky critical-power actions `Suspend` and `Ignore`. UPower refuses these unless this is enabled.";
    };

    percentageLow = mkOption {
      type = types.int;
      default = 15;
      description = "Battery percentage considered low";
    };

    percentageCritical = mkOption {
      type = types.int;
      default = 8;
      description = "Battery percentage considered critical";
    };

    percentageAction = mkOption {
      type = types.int;
      default = 3;
      description = "Battery percentage at which criticalPowerAction triggers";
    };
  };

  config = mkIf cfg.enable {
    services.logind.settings.Login = {
      # Lid switch
      HandleLidSwitch = cfg.lidCloseAction;
      HandleLidSwitchExternalPower =
        if cfg.lidCloseActionExternalPower != null
        then cfg.lidCloseActionExternalPower
        else cfg.lidCloseAction;

      # Power button
      HandlePowerKey = cfg.powerKeyAction;
      HandlePowerKeyLongPress = cfg.powerKeyLongPressAction;

      # Idle
      IdleAction = cfg.idleAction;
      IdleActionSec = cfg.idleTimeout;
    };

    services.upower = {
      enable = true;
      criticalPowerAction = cfg.criticalBatteryAction;
      allowRiskyCriticalPowerAction = cfg.allowRiskyCriticalPowerAction;
      percentageLow = cfg.percentageLow;
      percentageCritical = cfg.percentageCritical;
      percentageAction = cfg.percentageAction;
      usePercentageForPolicy = true;
    };
  };
}
