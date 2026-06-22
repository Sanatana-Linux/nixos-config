{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.lenovo.fan-control;

  # Fan curve point: { cpu_temp, gpu_temp, ic_temp, f1_pwm, f2_pwm, accel, decel }
  # Temperature in °C, PWM 0-255, accel/decel 2-5 (lower = faster response)
  #
  # NOTE: The kernel module (model_g8cn) uses FAN_SPEED_UNIT_RPM_HUNDRED internally.
  # The sysfs interface presents PWM 0-255, and the kernel converts to/from RPM/100.
  # Writing PWM values is correct — the kernel handles the conversion.
  # accel/decel must be 2-5 (kernel rejects values < 2).

  # Quiet: moderate cooling, good idle. (Formerly "balanced")
  quietCurve = {
    points = [
      # point  cpu_temp  gpu_temp  ic_temp  f1_pwm  f2_pwm  accel  decel
      {
        cpu = 0;
        gpu = 0;
        ic = 0;
        f1 = 0;
        f2 = 0;
        a = 3;
        d = 4;
      }
      {
        cpu = 40;
        gpu = 50;
        ic = 50;
        f1 = 51;
        f2 = 48;
        a = 3;
        d = 4;
      }
      {
        cpu = 46;
        gpu = 51;
        ic = 51;
        f1 = 61;
        f2 = 59;
        a = 3;
        d = 3;
      }
      {
        cpu = 51;
        gpu = 52;
        ic = 52;
        f1 = 71;
        f2 = 69;
        a = 2;
        d = 3;
      }
      {
        cpu = 54;
        gpu = 53;
        ic = 53;
        f1 = 79;
        f2 = 77;
        a = 2;
        d = 2;
      }
      {
        cpu = 60;
        gpu = 55;
        ic = 54;
        f1 = 89;
        f2 = 87;
        a = 2;
        d = 2;
      }
      {
        cpu = 67;
        gpu = 60;
        ic = 58;
        f1 = 102;
        f2 = 99;
        a = 2;
        d = 2;
      }
      {
        cpu = 74;
        gpu = 65;
        ic = 62;
        f1 = 117;
        f2 = 115;
        a = 2;
        d = 2;
      }
      {
        cpu = 81;
        gpu = 71;
        ic = 66;
        f1 = 133;
        f2 = 130;
        a = 2;
        d = 2;
      }
      {
        cpu = 89;
        gpu = 79;
        ic = 74;
        f1 = 143;
        f2 = 140;
        a = 2;
        d = 2;
      }
    ];
  };

  # Balanced: aggressive cooling, fast spin-up. (Formerly "performance")
  balancedCurve = {
    points = [
      # point  cpu_temp  gpu_temp  ic_temp  f1_pwm  f2_pwm  accel  decel
      {
        cpu = 0;
        gpu = 0;
        ic = 0;
        f1 = 0;
        f2 = 0;
        a = 2;
        d = 3;
      }
      {
        cpu = 35;
        gpu = 35;
        ic = 35;
        f1 = 61;
        f2 = 59;
        a = 2;
        d = 3;
      }
      {
        cpu = 41;
        gpu = 41;
        ic = 40;
        f1 = 74;
        f2 = 71;
        a = 2;
        d = 2;
      }
      {
        cpu = 47;
        gpu = 47;
        ic = 45;
        f1 = 87;
        f2 = 84;
        a = 2;
        d = 2;
      }
      {
        cpu = 53;
        gpu = 52;
        ic = 49;
        f1 = 102;
        f2 = 99;
        a = 2;
        d = 2;
      }
      {
        cpu = 59;
        gpu = 56;
        ic = 53;
        f1 = 117;
        f2 = 115;
        a = 2;
        d = 2;
      }
      {
        cpu = 65;
        gpu = 61;
        ic = 57;
        f1 = 133;
        f2 = 130;
        a = 2;
        d = 2;
      }
      {
        cpu = 71;
        gpu = 66;
        ic = 61;
        f1 = 143;
        f2 = 140;
        a = 2;
        d = 2;
      }
      {
        cpu = 77;
        gpu = 72;
        ic = 65;
        f1 = 148;
        f2 = 145;
        a = 2;
        d = 2;
      }
      {
        cpu = 86;
        gpu = 80;
        ic = 71;
        f1 = 153;
        f2 = 150;
        a = 2;
        d = 2;
      }
    ];
  };

  # Performance: maximum cooling, very aggressive ramp. (Formerly "extreme")
  performanceCurve = {
    points = [
      # point  cpu_temp  gpu_temp  ic_temp  f1_pwm  f2_pwm  accel  decel
      {
        cpu = 0;
        gpu = 0;
        ic = 0;
        f1 = 0;
        f2 = 0;
        a = 2;
        d = 3;
      }
      {
        cpu = 30;
        gpu = 30;
        ic = 30;
        f1 = 89;
        f2 = 84;
        a = 2;
        d = 3;
      }
      {
        cpu = 36;
        gpu = 36;
        ic = 35;
        f1 = 115;
        f2 = 110;
        a = 2;
        d = 2;
      }
      {
        cpu = 42;
        gpu = 42;
        ic = 40;
        f1 = 140;
        f2 = 135;
        a = 2;
        d = 2;
      }
      {
        cpu = 48;
        gpu = 47;
        ic = 44;
        f1 = 166;
        f2 = 160;
        a = 2;
        d = 2;
      }
      {
        cpu = 54;
        gpu = 51;
        ic = 48;
        f1 = 191;
        f2 = 186;
        a = 2;
        d = 2;
      }
      {
        cpu = 60;
        gpu = 56;
        ic = 52;
        f1 = 217;
        f2 = 212;
        a = 2;
        d = 2;
      }
      {
        cpu = 66;
        gpu = 61;
        ic = 56;
        f1 = 230;
        f2 = 225;
        a = 2;
        d = 2;
      }
      {
        cpu = 72;
        gpu = 67;
        ic = 60;
        f1 = 242;
        f2 = 237;
        a = 2;
        d = 2;
      }
      {
        cpu = 80;
        gpu = 75;
        ic = 66;
        f1 = 255;
        f2 = 255;
        a = 2;
        d = 2;
      }
    ];
  };

  # Generate a shell function that writes a fan curve to hwmon
  # NOTE: model_g8cn uses minifancurve mode — EC controls temp thresholds internally.
  # Only pwm1 (fan speed) and accel/decel are writable. pwm2/temps are EC-controlled.
  writeCurveScript = name: curve: let
    writePoints =
      imap1 (i: p: ''
        echo ${toString p.f1} > "$HWMON/pwm1_auto_point${toString i}_pwm"
        echo ${toString p.a}  > "$HWMON/pwm1_auto_point${toString i}_accel"
        echo ${toString p.d}  > "$HWMON/pwm1_auto_point${toString i}_decel"
      '')
      curve.points;
  in
    concatStringsSep "\n" writePoints;

  applyQuiet = writeCurveScript "quiet" quietCurve;
  applyBalanced = writeCurveScript "balanced" balancedCurve;
  applyPerformance = writeCurveScript "performance" performanceCurve;
in {
  options.modules.hardware.lenovo.fan-control = {
    enable = mkEnableOption "Lenovo Legion fan curve daemon with automatic profile switching";

    profile = mkOption {
      type = types.enum ["quiet" "balanced" "performance" "auto"];
      default = "auto";
      description = "Default fan profile. 'auto' switches based on power source (AC=performance, battery=quiet).";
    };

    onBattery = mkOption {
      type = types.enum ["quiet" "balanced"];
      default = "balanced";
      description = "Fan profile when on battery power (auto mode only).";
    };

    onAc = mkOption {
      type = types.enum ["balanced" "performance"];
      default = "performance";
      description = "Fan profile when on AC power (auto mode only).";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.modules.hardware.lenovo.enable;
        message = "fan-control requires modules.hardware.lenovo.enable = true (for the legion_laptop kernel module)";
      }
    ];

    environment.etc = {
      "legion/fan-curves/quiet.conf".text = lib.generators.toINI {} {
        FanCurve = {
          name = "Quiet";
          description = "Low-noise fan curve for idle and light tasks";
        };
      };
      "legion/fan-curves/balanced.conf".text = lib.generators.toINI {} {
        FanCurve = {
          name = "Balanced";
          description = "Moderate fan response for general use";
        };
      };
      "legion/fan-curves/performance.conf".text = lib.generators.toINI {} {
        FanCurve = {
          name = "Performance";
          description = "Aggressive cooling for gaming and heavy workloads";
        };
      };
    };

    systemd.services.legion-fan-control = {
      description = "Lenovo Legion fan curve daemon — applies fan curves and monitors power/profile changes";
      wantedBy = ["multi-user.target"];
      after =
        ["systemd-modules-load.service" "systemd-udevd.service" "sysinit.target"]
        ++ lib.optional config.services.auto-cpufreq.enable "auto-cpufreq.service";
      wants =
        ["systemd-udevd.service"]
        ++ lib.optional config.services.auto-cpufreq.enable "auto-cpufreq.service";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        User = "root";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      };
      path = with pkgs; [coreutils gnugrep findutils inotify-tools];

      script = ''
        HWMON=""
        PROFILE_FILE="/var/run/legion-fan-profile"
        OVERRIDE_FILE="/var/run/legion-fan-override"
        FNQ_EVENT="/var/run/legion-fnq-event"
        THERMAL_SIGNAL="/var/run/legion-thermal-recovery"
        DEFAULT_PROFILE="${cfg.profile}"
        ON_BATTERY="${cfg.onBattery}"
        ON_AC="${cfg.onAc}"

        # ---- Translate platform_profile values to our curated profile names ----
        # Fn+Q blue (blue LED)  -> "quiet"
        # Fn+Q white (no LED)   -> "balanced"
        # Fn+Q red (red LED)    -> "performance"
        # Also: low-power=quiet, balanced=balanced, performance=performance
        translate_profile() {
          case "$1" in
            low-power|quiet)     echo "quiet" ;;
            balanced)            echo "balanced" ;;
            performance)         echo "performance" ;;
            *)                   echo "balanced" ;;  # fallback
          esac
        }

        # ---- Find the legion hwmon device ----
        find_hwmon() {
          for d in /sys/class/hwmon/hwmon*; do
            if [ -f "$d/name" ] && grep -q "legion" "$d/name" 2>/dev/null; then
              HWMON="$d"
              return 0
            fi
          done
          # Fallback: try by driver path
          for d in /sys/module/legion_laptop/drivers/platform:legion/*/hwmon/hwmon*; do
            if [ -d "$d" ]; then
              HWMON="$d"
              return 0
            fi
          done
          return 1
        }

        # ---- Apply fan curve by profile name ----
        apply_curve() {
          local profile="$1"
          if [ -z "$HWMON" ]; then
            echo "ERROR: No hwmon device found"
            return 1
          fi

          case "$profile" in
            quiet)
              echo "Applying quiet fan curve..."
              ${applyQuiet}
              ;;
            balanced)
              echo "Applying balanced fan curve..."
              ${applyBalanced}
              ;;
            performance)
              echo "Applying performance fan curve..."
              ${applyPerformance}
              ;;
            *)
              echo "Unknown profile: $profile"
              return 1
              ;;
          esac
          echo "$profile" > "$PROFILE_FILE"
          echo "Fan curve applied: $profile"
        }

        # ---- Detect current power source ----
        get_power_source() {
          # Check AC adapter status
          for bat in /sys/class/power_supply/AC*/online /sys/class/power_supply/ADP*/online; do
            if [ -f "$bat" ]; then
              if [ "$(cat "$bat" 2>/dev/null)" = "1" ]; then
                echo "ac"
                return
              fi
            fi
          done
          # Check battery status
          for bat in /sys/class/power_supply/BAT*/status; do
            if [ -f "$bat" ]; then
              local status
              status=$(cat "$bat" 2>/dev/null)
              if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
                echo "ac"
                return
              fi
            fi
          done
          echo "battery"
        }

        # ---- Resolve which profile should be active ----
        # Priority: manual override > Fn+Q event > thermal recovery > power source based
        resolve_profile() {
          # 1. Check for manual override (set by user via legion-fan command)
          if [ -f "$OVERRIDE_FILE" ]; then
            local mtime
            mtime=$(stat -c %Y "$OVERRIDE_FILE" 2>/dev/null || echo 0)
            local now
            now=$(date +%s)
            local age=$(( now - mtime ))
            # Overrides expire after 30 minutes
            if [ "$age" -lt 1800 ]; then
              cat "$OVERRIDE_FILE"
              return
            else
              rm -f "$OVERRIDE_FILE"
            fi
          fi

          # 2. Check for recent Fn+Q event (set by udev rule when platform_profile changes)
          if [ -f "$FNQ_EVENT" ]; then
            local mtime
            mtime=$(stat -c %Y "$FNQ_EVENT" 2>/dev/null || echo 0)
            local now
            now=$(date +%s)
            local age=$(( now - mtime ))
            # Fn+Q overrides expire after 30 minutes
            if [ "$age" -lt 1800 ]; then
              local raw_profile
              raw_profile=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo "balanced")
              local translated
              translated=$(translate_profile "$raw_profile")
              # Update the event file mtime so it stays active
              touch "$FNQ_EVENT"
              echo "Fn+Q active: $raw_profile -> $translated"
              echo "$translated"
              return
            else
              rm -f "$FNQ_EVENT"
            fi
          fi

          # 3. Check for thermal-guard recovery signal
          if [ -f "$THERMAL_SIGNAL" ]; then
            rm -f "$THERMAL_SIGNAL"
            echo "performance"
            return
          fi

          # 4. Auto mode: switch based on power source
          if [ "$DEFAULT_PROFILE" = "auto" ]; then
            local pw
            pw=$(get_power_source)
            if [ "$pw" = "ac" ]; then
              echo "$ON_AC"
            else
              echo "$ON_BATTERY"
            fi
            return
          fi

          echo "$DEFAULT_PROFILE"
        }

        # ---- Read current platform_profile from sysfs ----
        read_platform_profile() {
          cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo "unknown"
        }

        # ---- Initialize ----
        echo "=== Legion Fan Control Daemon ==="

        # Wait for hwmon device
        for i in $(seq 1 30); do
          if find_hwmon; then
            break
          fi
          echo "Waiting for legion hwmon device (attempt $i/30)..."
          sleep 2
        done

        if [ -z "$HWMON" ]; then
          echo "ERROR: Could not find legion hwmon device after 60 seconds"
          echo "Make sure the legion_laptop kernel module is loaded"
          exit 1
        fi

        echo "Found hwmon device: $HWMON"

        # Initial apply
        active_profile=""
        desired_profile=""
        last_platform_profile=""

        # ---- Main loop ----
        while true; do
          desired_profile=$(resolve_profile)

          # Also detect Fn+Q changes by polling platform_profile directly
          current_pp=$(read_platform_profile)
          if [ "$current_pp" != "$last_platform_profile" ] && [ "$last_platform_profile" != "" ]; then
            # Fn+Q was pressed — update the override
            translated=$(translate_profile "$current_pp")
            echo "$translated" > "$OVERRIDE_FILE" 2>/dev/null || true
            touch "$FNQ_EVENT" 2>/dev/null || true
            echo "Fn+Q change detected via poll: $current_pp -> $translated"
          fi
          last_platform_profile="$current_pp"

          if [ "$desired_profile" != "$active_profile" ]; then
            apply_curve "$desired_profile"
            active_profile="$desired_profile"
          fi

          sleep 5
        done
      '';
    };

    # Ensure the override marker directory exists and profile changes are detected
    systemd.tmpfiles.rules = [
      "d /var/run/legion 0755 root root -"
    ];

    # Expose a convenience script for manual fan curve changes
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "legion-fan" ''
        case "$1" in
          quiet|balanced|performance)
            echo "$1" > /var/run/legion-fan-override
            echo "Fan profile override set to: $1 (expires in 30 min)"
            echo "The daemon will apply this on the next cycle."
            ;;
          auto)
            rm -f /var/run/legion-fan-override
            rm -f /var/run/legion-fnq-event
            echo "Fan profile override cleared. Returning to auto mode."
            ;;
          status)
            if [ -f /var/run/legion-fan-profile ]; then
              echo "Active fan profile: $(cat /var/run/legion-fan-profile)"
            else
              echo "No fan profile recorded yet"
            fi
            if [ -f /var/run/legion-fan-override ]; then
              echo "Manual override: $(cat /var/run/legion-fan-override)"
              mtime=$(stat -c %Y /var/run/legion-fan-override 2>/dev/null || echo 0)
              now=$(date +%s)
              remaining=$(( 1800 - (now - mtime) ))
              if [ "$remaining" -gt 0 ]; then
                echo "Override expires in $(( remaining / 60 )) minutes"
              else
                echo "Override expired (daemon will revert to auto)"
              fi
            else
              echo "No manual override active"
            fi
            if [ -f /var/run/legion-fnq-event ]; then
              echo "Fn+Q override active"
            fi
            echo "Platform profile: $(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo 'N/A')"
            echo "Thermal mode: $(cat /sys/devices/platform/legion/thermalmode 2>/dev/null || echo 'N/A')"
            echo "Power mode: $(cat /sys/devices/platform/legion/powermode 2>/dev/null || echo 'N/A')"
            echo "Fan speeds: F1=$(cat /sys/devices/platform/legion/hwmon/hwmon*/fan1_input 2>/dev/null) F2=$(cat /sys/devices/platform/legion/hwmon/hwmon*/fan2_input 2>/dev/null)"
            echo "Temps: CPU=$(cat /sys/devices/platform/legion/hwmon/hwmon*/temp1_input 2>/dev/null) GPU=$(cat /sys/devices/platform/legion/hwmon/hwmon*/temp2_input 2>/dev/null)"
            ;;
          *)
            echo "Usage: legion-fan {quiet|balanced|performance|auto|status}"
            echo ""
            echo "  quiet        - Moderate cooling, good idle (general use)"
            echo "  balanced     - Aggressive cooling, fast spin-up (gaming)"
            echo "  performance  - Maximum cooling, full fan speed at high temps"
            echo "  auto         - Clear manual override, return to auto mode"
            echo "  status       - Show current profile and override state"
            ;;
        esac
      '')
    ];
  };
}
