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
    enable = mkEnableOption "Thermal guard — monitors CPU and IC/VRM temp, throttles to power-saver when either overheats";

    thermalGuard = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable thermal guard — monitors CPU and IC/VRM temp, switches to balanced profile when overheating";
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

      icHighThreshold = mkOption {
        type = types.int;
        default = 85;
        description = "IC/VRM chipset temperature (°C) at which to throttle to balanced profile. The VRM runs hotter than the CPU under GPU-heavy or charging loads and needs its own threshold.";
      };

      icLowThreshold = mkOption {
        type = types.int;
        default = 78;
        description = "IC/VRM chipset temperature (°C) at which to restore performance profile";
      };

      icCriticalThreshold = mkOption {
        type = types.int;
        default = 90;
        description = "IC/VRM temperature (°C) at which to force maximum fans regardless of profile. The VRM can hit this under sustained load with high PL limits — immediate max cooling is needed to prevent thermal damage.";
      };

      pollInterval = mkOption {
        type = types.int;
        default = 5;
        description = "Seconds between temperature checks. Shorter interval for faster VRM thermal response.";
      };
    };
  };

  config = mkIf cfg.enable {
    # Thermal guard: monitors CPU and IC/VRM temp, throttles EPP when either
    # overheats. Sets EPP to balance_performance at startup (after TLP),
    # throttles to balance_power at highThreshold, restores at lowThreshold.
    # The IC/VRM chipset runs independently of CPU load — GPU stress, charging,
    # and power delivery heat soak can push VRM temps well above CPU temp.
    # Directly calls legion-fan-apply (via legion_cli) for fan curve changes.
    systemd.services.legion-thermal-guard = lib.mkIf cfg.thermalGuard.enable {
      description = "Lenovo Legion thermal guard — throttles EPP and fans when CPU or IC/VRM overheats";
      wantedBy = ["multi-user.target"];
      after = ["systemd-modules-load.service" "sysinit.target"];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "${toString cfg.thermalGuard.pollInterval}";
        User = "root";
      };
      path = with pkgs; [coreutils gawk pkgs.lenovo-legion];
      script = ''
        HIGH=${toString cfg.thermalGuard.highThreshold}
        LOW=${toString cfg.thermalGuard.lowThreshold}
        IC_HIGH=${toString cfg.thermalGuard.icHighThreshold}
        IC_LOW=${toString cfg.thermalGuard.icLowThreshold}
        INTERVAL=${toString cfg.thermalGuard.pollInterval}
        THROTTLED=0

        echo "=== Legion Thermal Guard ==="
        echo "CPU thresholds: ''${HIGH}°C / ''${LOW}°C (throttle/restore)"
        echo "IC/VRM thresholds: ''${IC_HIGH}°C / ''${IC_LOW}°C (throttle/restore)"
        echo "Poll interval: ''${INTERVAL}s"
        echo "Throttle: EPP=balance_power, Fan=performance"
        echo "TLP manages baseline EPP — guard only intervenes above threshold"

        # ── read_temp <hwmon_name_pattern> <temp_file> ──────────────────
        # Read a temperature sensor by hwmon name. Returns °C integer or empty.
        read_temp() {
          local name_pattern="$1" temp_file="$2"
          for hwmon in /sys/class/hwmon/hwmon*; do
            if [ -f "$hwmon/name" ] && grep -q "$name_pattern" "$hwmon/name" 2>/dev/null; then
              if [ -f "$hwmon/$temp_file" ]; then
                cat "$hwmon/$temp_file" 2>/dev/null | awk '{printf "%d", $1/1000}'
                return 0
              fi
            fi
          done
          return 1
        }

        while true; do
          # Read CPU package temperature from coretemp hwmon
          CPU_TEMP=$(read_temp "coretemp" "temp1_input")

          # Read IC/VRM temperature from legion_laptop hwmon.
          # legion_laptop exposes: temp1=CPU, temp2=GPU, temp3=IC/VRM, temp4=ambient
          # We want temp3 (IC/VRM). Fall back to temp4, then temp2 if unavailable.
          IC_TEMP=""
          for hwmon in /sys/class/hwmon/hwmon*; do
            if [ -f "$hwmon/name" ] && grep -q "legion" "$hwmon/name" 2>/dev/null; then
              for tfile in temp3_input temp4_input temp5_input temp2_input; do
                if [ -f "$hwmon/$tfile" ]; then
                  IC_TEMP=$(cat "$hwmon/$tfile" 2>/dev/null | awk '{printf "%d", $1/1000}')
                  break
                fi
              done
              break
            fi
          done

          if [ -z "$CPU_TEMP" ]; then
            echo "WARNING: Could not read CPU temperature"
            sleep "$INTERVAL"
            continue
          fi

          # Use the higher of CPU and IC as the trigger. The IC/VRM can
          # run much hotter than the CPU under GPU/charging loads — if we
          # only checked CPU, the VRM would cook with no throttling.
          TRIGGER_TEMP="$CPU_TEMP"
          TRIGGER_SOURCE="CPU"
          if [ -n "$IC_TEMP" ] && [ "$IC_TEMP" -gt "$CPU_TEMP" ]; then
            TRIGGER_TEMP="$IC_TEMP"
            TRIGGER_SOURCE="IC"
          fi

          # Determine effective thresholds based on which sensor is hotter
          EFFECTIVE_HIGH="$HIGH"
          EFFECTIVE_LOW="$LOW"
          if [ -n "$IC_TEMP" ] && [ "$IC_TEMP" -ge "$CPU_TEMP" ]; then
            EFFECTIVE_HIGH="$IC_HIGH"
            EFFECTIVE_LOW="$IC_LOW"
          fi

          if [ "$TRIGGER_TEMP" -ge "$EFFECTIVE_HIGH" ] && [ "$THROTTLED" -eq 0 ]; then
            # Save current EPP before throttling
            SAVED_EPP=$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null || echo "balance_power")
            echo "$SAVED_EPP" > /var/run/legion-thermal-guard-saved-epp 2>/dev/null || true
            echo "[$(date +%H:%M:%S)] ''${TRIGGER_SOURCE} at ''${TRIGGER_TEMP}°C >= ''${EFFECTIVE_HIGH}°C — THROTTLING EPP to balance_power (was $SAVED_EPP)"
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
            # Restore only when BOTH CPU and IC have cooled below their
            # respective low thresholds — prevents flapping when VRM
            # heat lags behind CPU cooling.
            IC_COOL=1
            if [ -n "$IC_TEMP" ] && [ "$IC_TEMP" -gt "$IC_LOW" ]; then
              IC_COOL=0
            fi

            if [ "$IC_COOL" -eq 1 ]; then
              RESTORE_EPP="balance_power"
              if [ -f /var/run/legion-thermal-guard-saved-epp ]; then
                RESTORE_EPP=$(cat /var/run/legion-thermal-guard-saved-epp 2>/dev/null || echo "balance_power")
              fi
              echo "[$(date +%H:%M:%S)] CPU at ''${CPU_TEMP}°C <= ''${LOW}°C, IC at ''${IC_TEMP:-N/A}°C <= ''${IC_LOW}°C — RESTORING EPP to $RESTORE_EPP"
              for cpu in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
                echo "$RESTORE_EPP" > "$cpu" 2>/dev/null || true
              done
              # Write a signal for the Fn+Q poll service to restore auto curve
              touch /var/run/legion-thermal-recovery 2>/dev/null || true
              THROTTLED=0
            else
              echo "[$(date +%H:%M:%S)] CPU cooled to ''${CPU_TEMP}°C but IC still at ''${IC_TEMP}°C > ''${IC_LOW}°C — holding throttle"
            fi
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
