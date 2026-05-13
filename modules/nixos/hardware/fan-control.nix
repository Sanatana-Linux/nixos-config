{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.fan-control;

  # Fan curve point: { cpu_temp, gpu_temp, ic_temp, fan1_rpm, fan2_rpm, accel, decel }
  # Temperature in °C, RPM as absolute values, accel/decel as multiplier (1-5, lower = faster)

  # Quiet: reduced noise at idle but steeper ramp once temps rise.
  quietCurve = {
    points = [
      # point  cpu_temp  gpu_temp  ic_temp  fan1_rpm  fan2_rpm  accel  decel
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
        cpu = 38;
        gpu = 38;
        ic = 38;
        f1 = 1800;
        f2 = 1700;
        a = 3;
        d = 4;
      }
      {
        cpu = 44;
        gpu = 44;
        ic = 42;
        f1 = 2200;
        f2 = 2100;
        a = 3;
        d = 3;
      }
      {
        cpu = 50;
        gpu = 49;
        ic = 46;
        f1 = 2500;
        f2 = 2400;
        a = 2;
        d = 2;
      }
      {
        cpu = 56;
        gpu = 53;
        ic = 49;
        f1 = 2900;
        f2 = 2800;
        a = 2;
        d = 2;
      }
      {
        cpu = 63;
        gpu = 58;
        ic = 53;
        f1 = 3300;
        f2 = 3200;
        a = 2;
        d = 2;
      }
      {
        cpu = 70;
        gpu = 63;
        ic = 57;
        f1 = 3800;
        f2 = 3700;
        a = 1;
        d = 1;
      }
      {
        cpu = 77;
        gpu = 68;
        ic = 61;
        f1 = 4200;
        f2 = 4100;
        a = 1;
        d = 1;
      }
      {
        cpu = 83;
        gpu = 73;
        ic = 66;
        f1 = 4700;
        f2 = 4600;
        a = 1;
        d = 1;
      }
      {
        cpu = 90;
        gpu = 80;
        ic = 73;
        f1 = 5200;
        f2 = 5100;
        a = 1;
        d = 1;
      }
    ];
  };

  # Balanced: good cooling, moderate idle.
  balancedCurve = {
    points = [
      # point  cpu_temp  gpu_temp  ic_temp  fan1_rpm  fan2_rpm  accel  decel
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
        cpu = 38;
        gpu = 48;
        ic = 48;
        f1 = 2000;
        f2 = 1900;
        a = 2;
        d = 3;
      }
      {
        cpu = 44;
        gpu = 49;
        ic = 49;
        f1 = 2400;
        f2 = 2300;
        a = 2;
        d = 2;
      }
      {
        cpu = 49;
        gpu = 50;
        ic = 50;
        f1 = 2800;
        f2 = 2700;
        a = 2;
        d = 2;
      }
      {
        cpu = 52;
        gpu = 51;
        ic = 51;
        f1 = 3100;
        f2 = 3000;
        a = 2;
        d = 2;
      }
      {
        cpu = 58;
        gpu = 53;
        ic = 52;
        f1 = 3500;
        f2 = 3400;
        a = 1;
        d = 1;
      }
      {
        cpu = 65;
        gpu = 58;
        ic = 56;
        f1 = 4000;
        f2 = 3900;
        a = 1;
        d = 1;
      }
      {
        cpu = 72;
        gpu = 63;
        ic = 60;
        f1 = 4600;
        f2 = 4500;
        a = 1;
        d = 1;
      }
      {
        cpu = 79;
        gpu = 69;
        ic = 64;
        f1 = 5200;
        f2 = 5100;
        a = 1;
        d = 1;
      }
      {
        cpu = 87;
        gpu = 77;
        ic = 72;
        f1 = 5600;
        f2 = 5500;
        a = 1;
        d = 1;
      }
    ];
  };

  # Performance: maximum cooling, fast spin-up, aggressive ramp.
  performanceCurve = {
    points = [
      # point  cpu_temp  gpu_temp  ic_temp  fan1_rpm  fan2_rpm  accel  decel
      {
        cpu = 0;
        gpu = 0;
        ic = 0;
        f1 = 0;
        f2 = 0;
        a = 1;
        d = 2;
      }
      {
        cpu = 32;
        gpu = 32;
        ic = 32;
        f1 = 2400;
        f2 = 2300;
        a = 1;
        d = 2;
      }
      {
        cpu = 39;
        gpu = 39;
        ic = 38;
        f1 = 2900;
        f2 = 2800;
        a = 1;
        d = 1;
      }
      {
        cpu = 45;
        gpu = 45;
        ic = 43;
        f1 = 3400;
        f2 = 3300;
        a = 1;
        d = 1;
      }
      {
        cpu = 51;
        gpu = 50;
        ic = 47;
        f1 = 4000;
        f2 = 3900;
        a = 1;
        d = 1;
      }
      {
        cpu = 57;
        gpu = 54;
        ic = 51;
        f1 = 4600;
        f2 = 4500;
        a = 1;
        d = 1;
      }
      {
        cpu = 63;
        gpu = 59;
        ic = 55;
        f1 = 5200;
        f2 = 5100;
        a = 1;
        d = 1;
      }
      {
        cpu = 69;
        gpu = 64;
        ic = 59;
        f1 = 5600;
        f2 = 5500;
        a = 1;
        d = 1;
      }
      {
        cpu = 75;
        gpu = 70;
        ic = 63;
        f1 = 5800;
        f2 = 5700;
        a = 1;
        d = 1;
      }
      {
        cpu = 84;
        gpu = 78;
        ic = 69;
        f1 = 6000;
        f2 = 5900;
        a = 1;
        d = 1;
      }
    ];
  };

  # Generate a shell function that writes a fan curve to hwmon
  writeCurveScript = name: curve: let
    writePoints =
      imap1 (i: p: ''
        echo ${toString p.f1} > "$HWMON/pwm1_auto_point${toString i}_pwm"
        echo ${toString p.f2} > "$HWMON/pwm2_auto_point${toString i}_pwm"
        echo ${toString p.cpu} > "$HWMON/pwm1_auto_point${toString i}_temp"
        echo ${toString p.cpu} > "$HWMON/pwm1_auto_point${toString i}_temp_hyst"
        echo ${toString p.gpu} > "$HWMON/pwm2_auto_point${toString i}_temp"
        echo ${toString p.gpu} > "$HWMON/pwm2_auto_point${toString i}_temp_hyst"
        echo ${toString p.ic}  > "$HWMON/pwm3_auto_point${toString i}_temp"
        echo ${toString p.ic}  > "$HWMON/pwm3_auto_point${toString i}_temp_hyst"
        echo ${toString p.a}   > "$HWMON/pwm1_auto_point${toString i}_accel"
        echo ${toString p.d}   > "$HWMON/pwm1_auto_point${toString i}_decel"
      '')
      curve.points;
  in
    concatStringsSep "\n" writePoints;

  applyQuiet = writeCurveScript "quiet" quietCurve;
  applyBalanced = writeCurveScript "balanced" balancedCurve;
  applyPerformance = writeCurveScript "performance" performanceCurve;
in {
  options.modules.hardware.fan-control = {
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
            local translated
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
            ;;
          *)
            echo "Usage: legion-fan {quiet|balanced|performance|auto|status}"
            echo ""
            echo "  quiet        - Low-noise fan curve (idle/light tasks)"
            echo "  balanced     - Moderate fan response (general use)"
            echo "  performance  - Aggressive cooling (gaming/heavy workloads)"
            echo "  auto         - Clear manual override, return to auto mode"
            echo "  status       - Show current profile and override state"
            ;;
        esac
      '')
    ];
  };
}
