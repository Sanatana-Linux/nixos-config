{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.hardware.lenovo.power;
in {
  options.modules.hardware.lenovo.power = {
    enable = lib.mkEnableOption "laptop power management";

    powerProfilesDaemon = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use power-profiles-daemon instead of TLP";
    };

    conservationMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable battery conservation mode (stop charging at ~80%) via legion_cli";
    };

    defaultProfile = lib.mkOption {
      type = lib.types.enum ["low-power" "balanced" "performance"];
      default = "balanced";
      description = "Default platform_profile set at boot. Overrides the BIOS/EC-persisted Fn+Q state so the system always starts in the desired mode.";
    };

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

    boot.kernelModules = ["cpupower"];
    environment.systemPackages = [config.boot.kernelPackages.cpupower];

    services = {
      # handle ACPI events
      acpid.enable = true;
      # Power Profiles
      power-profiles-daemon.enable = cfg.powerProfilesDaemon;

      tlp = {
        enable = !cfg.powerProfilesDaemon;
        settings = {
          CPU_BOOST_ON_AC = cfg.cpuBoostOnAc;
          CPU_BOOST_ON_BAT = cfg.cpuBoostOnBat;
          CPU_SCALING_GOVERNOR_ON_AC = "powersave";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          # EPP is managed by TLP — don't override
          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
          PLATFORM_PROFILE_ON_AC = "balanced";
          PLATFORM_PROFILE_ON_BAT = "low-power";
          CPU_MAX_PERF_ON_AC = 80; # Cap at 80% to reduce VRM current draw — full 100% on i9-14900HX causes excessive VRM temperatures
          CPU_MAX_PERF_ON_BAT = 60;
          TLP_DEFAULT_MODE = "AC";
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
        percentageCritical = 8;
        percentageAction = 3;
        usePercentageForPolicy = true;
      };
    };

    # Battery conservation mode via legion_cli — stops charging at ~80%
    # to reduce VRM/IC heat. Uses set-feature to avoid the broken WMI
    # rapidcharge path that fancurve-write-preset-to-hw triggers.
    systemd.services.legion-conservation-mode = lib.mkIf cfg.conservationMode {
      description = "Enable Lenovo Legion battery conservation mode";
      wantedBy = ["multi-user.target"];
      after = ["systemd-modules-load.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = with pkgs; [pkgs.lenovo-legion pkgs.bash pkgs.coreutils];
      script = ''
        ${pkgs.lenovo-legion}/bin/legion_cli --donotexpecthwmon set-feature BatteryConservation 1
      '';
    };

    # Force platform_profile to the configured default at boot.
    # The BIOS/EC persists the last Fn+Q state across reboots, so if you
    # last used quiet mode (blue LED), the system boots into quiet mode
    # with minimal fans and reduced performance. This service overrides
    # that at boot so the system always starts in the desired profile.
    systemd.services.legion-default-profile = {
      description = "Force Legion platform_profile to ${cfg.defaultProfile} at boot";
      wantedBy = ["multi-user.target"];
      after = ["systemd-modules-load.service" "sysinit.target"];
      # No fan-control dependency — that module is being removed
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = with pkgs; [coreutils];
      script = ''
        PROFILE="${cfg.defaultProfile}"
        TARGET="/sys/firmware/acpi/platform_profile"
        if [ -f "$TARGET" ]; then
          CURRENT=$(cat "$TARGET" 2>/dev/null || echo "unknown")
          if [ "$CURRENT" != "$PROFILE" ]; then
            echo "Setting platform_profile from ''${CURRENT} → ''${PROFILE}"
            echo "$PROFILE" > "$TARGET" 2>/dev/null || echo "WARNING: Could not set platform_profile to $PROFILE" >&2
          fi
        fi
      '';
    };

    # UPower has no built-in notification mechanism — it relies on desktop
    # environments to listen to D-Bus signals. In AwesomeWM, no such listener
    # exists by default. This timer polls battery percentage every 2 minutes
    # and sends a critical desktop notification when the battery drops to
    # the critical threshold (8%), giving the user time to act before the
    # hibernate action fires at 3%.
    systemd.services.battery-critical-warning = {
      description = "Send desktop notification when battery is critically low";
      path = with pkgs; [upower libnotify];
      serviceConfig.Type = "oneshot";
      script = ''
        BATTERY_PATH=$(upower -e 2>/dev/null | grep -i battery | head -1)
        if [ -z "$BATTERY_PATH" ]; then
          exit 0
        fi
        LEVEL=$(upower -i "$BATTERY_PATH" | grep "percentage:" | tr -dc '0-9\n')
        STATE=$(upower -i "$BATTERY_PATH" | grep "state:" | cut -d: -f2 | tr -d ' ')
        if [ "$STATE" = "discharging" ] && [ -n "$LEVEL" ] && [ "$LEVEL" -le 8 ]; then
          DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus" \
            ${pkgs.libnotify}/bin/notify-send -u critical \
            "Battery Critical" "Only $LEVEL% remaining — plug in now or system will hibernate at 3%"
        fi
      '';
    };

    systemd.timers.battery-critical-warning = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "2m";
      };
    };
  };
}
