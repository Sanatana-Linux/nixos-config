{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.lenovo.cooling;
in {
  options.modules.hardware.lenovo.cooling = {
    enable = mkEnableOption "Thermal guard — defaults to balanced EPP, throttles to power-saver when overheating";

    thermalGuard = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable thermal guard — monitors CPU temp and switches to balanced profile when overheating";
      };

      highThreshold = mkOption {
        type = types.int;
        default = 75;
        description = "CPU package temperature (°C) at which to throttle to balanced profile";
      };

      lowThreshold = mkOption {
        type = types.int;
        default = 70;
        description = "CPU package temperature (°C) at which to restore performance profile";
      };

      pollInterval = mkOption {
        type = types.int;
        default = 10;
        description = "Seconds between temperature checks";
      };
    };
  };

  config = mkIf cfg.enable {
    # Thermal guard: monitors CPU temp and throttles EPP when overheating.
    # Sets EPP to balance_performance at startup (after TLP), throttles to
    # balance_power at highThreshold, restores at lowThreshold.
    # Directly calls legion-fan-apply (via legion_cli) for fan curve changes.
    systemd.services.legion-thermal-guard = lib.mkIf cfg.thermalGuard.enable {
      description = "Lenovo Legion thermal guard — throttles EPP and fans when CPU overheats";
      wantedBy = ["multi-user.target"];
      after = ["systemd-modules-load.service" "sysinit.target"];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "${toString cfg.thermalGuard.pollInterval}";
        User = "root";
      };
      path = with pkgs; [coreutils pkgs.lenovo-legion];
      script = ''
        HIGH=${toString cfg.thermalGuard.highThreshold}
        LOW=${toString cfg.thermalGuard.lowThreshold}
        INTERVAL=${toString cfg.thermalGuard.pollInterval}
        THROTTLED=0

        echo "=== Legion Thermal Guard ==="
        echo "High threshold: ''${HIGH}°C"
        echo "Low threshold: ''${LOW}°C"
        echo "Poll interval: ''${INTERVAL}s"
        echo "Throttle: EPP=balance_power, Fan=performance"
        echo "TLP manages baseline EPP — guard only intervenes above threshold"

        while true; do
          # Read CPU package temperature from coretemp hwmon
          CPU_TEMP=""
          for hwmon in /sys/class/hwmon/hwmon*; do
            if [ -f "$hwmon/name" ] && grep -q "coretemp" "$hwmon/name" 2>/dev/null; then
              if [ -f "$hwmon/temp1_input" ]; then
                CPU_TEMP=$(( $(cat "$hwmon/temp1_input") / 1000 ))
                break
              fi
            fi
          done

          if [ -z "$CPU_TEMP" ]; then
            echo "WARNING: Could not read CPU temperature"
            sleep "$INTERVAL"
            continue
          fi

          if [ "$CPU_TEMP" -ge "$HIGH" ] && [ "$THROTTLED" -eq 0 ]; then
            # Save current EPP before throttling
            SAVED_EPP=$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null || echo "balance_power")
            echo "$SAVED_EPP" > /var/run/legion-thermal-guard-saved-epp 2>/dev/null || true
            echo "[$(date +%H:%M:%S)] CPU at ''${CPU_TEMP}°C >= ''${HIGH}°C — THROTTLING EPP to balance_power (was $SAVED_EPP)"
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
              echo "balance_power" > "$cpu" 2>/dev/null || true
            done
            # Apply performance fan curve for max cooling (pick AC or battery variant)
            SOURCE="battery"
            for bat in /sys/class/power_supply/AC*/online /sys/class/power_supply/ADP*/online; do
              if [ -f "$bat" ] && [ "$(cat "$bat" 2>/dev/null)" = "1" ]; then
                SOURCE="ac"; break
              fi
            done
            ${pkgs.lenovo-legion}/bin/legion_cli --donotexpecthwmon fancurve-write-file-to-hw "/etc/legion/fan-curves/performance-''${SOURCE}.yaml" 2>/dev/null || true
            THROTTLED=1
          elif [ "$CPU_TEMP" -le "$LOW" ] && [ "$THROTTLED" -eq 1 ]; then
            RESTORE_EPP="balance_power"
            if [ -f /var/run/legion-thermal-guard-saved-epp ]; then
              RESTORE_EPP=$(cat /var/run/legion-thermal-guard-saved-epp 2>/dev/null || echo "balance_power")
            fi
            echo "[$(date +%H:%M:%S)] CPU at ''${CPU_TEMP}°C <= ''${LOW}°C — RESTORING EPP to $RESTORE_EPP"
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
              echo "$RESTORE_EPP" > "$cpu" 2>/dev/null || true
            done
            # Write a signal for the Fn+Q poll service to restore auto curve
            touch /var/run/legion-thermal-recovery 2>/dev/null || true
            THROTTLED=0
          fi

          sleep "$INTERVAL"
        done
      '';
    };

    # Ensure state directory exists for saved EPP
    systemd.tmpfiles.rules = lib.mkIf cfg.thermalGuard.enable [
      "d /var/run/legion 0755 root root -"
    ];
  };
}
