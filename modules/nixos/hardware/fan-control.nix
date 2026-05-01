{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.fan-control;

  # Fan curve point: { cpu_temp, gpu_temp, ic_temp, fan1_rpm, fan2_rpm, accel, decel }
  # Temperature in °C, RPM as absolute values, accel/decel as multiplier (1-5)

  # Quiet: fans barely spin until 60°C, gradual ramp-up. Targets idle/browsing.
  quietCurve = {
    points = [
      # point  cpu_temp  gpu_temp  ic_temp  fan1_rpm  fan2_rpm  accel  decel
      {         cpu=0;   gpu=0;    ic=0;    f1=0;     f2=0;     a=5;   d=5; }
      {         cpu=45;  gpu=45;   ic=45;   f1=1500;  f2=1500;  a=5;   d=5; }
      {         cpu=52;  gpu=52;   ic=50;   f1=1700;  f2=1600;  a=5;   d=4; }
      {         cpu=58;  gpu=56;   ic=53;   f1=1900;  f2=1800;  a=4;   d=4; }
      {         cpu=64;  gpu=60;   ic=56;   f1=2100;  f2=2000;  a=3;   d=3; }
      {         cpu=72;  gpu=65;   ic=60;   f1=2400;  f2=2300;  a=2;   d=2; }
      {         cpu=78;  gpu=70;   ic=64;   f1=2700;  f2=2600;  a=2;   d=2; }
      {         cpu=84;  gpu=75;   ic=68;   f1=3100;  f2=3000;  a=1;   d=1; }
      {         cpu=90;  gpu=80;   ic=72;   f1=3600;  f2=3500;  a=1;   d=1; }
      {         cpu=95;  gpu=85;   ic=76;   f1=4200;  f2=4100;  a=1;   d=1; }
    ];
  };

  # Balanced: moderate fan response, good for general use. Similar to Lenovo's default.
  balancedCurve = {
    points = [
      # point  cpu_temp  gpu_temp  ic_temp  fan1_rpm  fan2_rpm  accel  decel
      {         cpu=0;   gpu=0;    ic=0;    f1=0;     f2=0;     a=5;   d=5; }
      {         cpu=46;  gpu=56;   ic=56;   f1=1500;  f2=1600;  a=5;   d=4; }
      {         cpu=52;  gpu=57;   ic=57;   f1=1900;  f2=2000;  a=5;   d=4; }
      {         cpu=56;  gpu=58;   ic=58;   f1=2100;  f2=2200;  a=4;   d=3; }
      {         cpu=58;  gpu=59;   ic=59;   f1=2200;  f2=2300;  a=4;   d=3; }
      {         cpu=67;  gpu=60;   ic=60;   f1=2500;  f2=2500;  a=3;   d=2; }
      {         cpu=74;  gpu=65;   ic=62;   f1=2900;  f2=2800;  a=2;   d=2; }
      {         cpu=80;  gpu=70;   ic=66;   f1=3400;  f2=3300;  a=2;   d=1; }
      {         cpu=86;  gpu=76;   ic=70;   f1=4000;  f2=3900;  a=1;   d=1; }
      {         cpu=95;  gpu=85;   ic=78;   f1=4500;  f2=4400;  a=1;   d=1; }
    ];
  };

  # Performance: aggressive cooling, fans spin up early. For gaming/heavy workloads.
  performanceCurve = {
    points = [
      # point  cpu_temp  gpu_temp  ic_temp  fan1_rpm  fan2_rpm  accel  decel
      {         cpu=0;   gpu=0;    ic=0;    f1=0;     f2=0;     a=4;   d=4; }
      {         cpu=40;  gpu=40;   ic=40;   f1=1800;  f2=1800;  a=4;   d=3; }
      {         cpu=48;  gpu=48;   ic=46;   f1=2200;  f2=2100;  a=3;   d=3; }
      {         cpu=54;  gpu=54;   ic=50;   f1=2500;  f2=2400;  a=3;   d=2; }
      {         cpu=60;  gpu=58;   ic=54;   f1=2800;  f2=2700;  a=2;   d=2; }
      {         cpu=66;  gpu=62;   ic=58;   f1=3200;  f2=3100;  a=2;   d=2; }
      {         cpu=72;  gpu=67;   ic=62;   f1=3700;  f2=3600;  a=1;   d=1; }
      {         cpu=78;  gpu=72;   ic=66;   f1=4200;  f2=4100;  a=1;   d=1; }
      {         cpu=84;  gpu=78;   ic=70;   f1=4700;  f2=4600;  a=1;   d=1; }
      {         cpu=92;  gpu=85;   ic=76;   f1=5200;  f2=5100;  a=1;   d=1; }
    ];
  };

  # Generate a shell function that writes a fan curve to hwmon
  writeCurveScript = name: curve: let
    writePoints = imap1 (i: p: ''
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
    '') curve.points;
  in
    writePoints;

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
      default = "quiet";
      description = "Fan profile when on battery power (auto mode only).";
    };

    onAc = mkOption {
      type = types.enum ["balanced" "performance"];
      default = "performance";
      description = "Fan profile when on AC power (auto mode only).";
    };

    thermalGuardIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Signal thermal-guard to re-apply fan curve after throttling events.";
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
      after = ["systemd-modules-load.service" "systemd-udevd.service" "sysinit.target"];
      wants = ["systemd-udevd.service"];
      wants = mkIf config.services.auto-cpufreq.enable ["auto-cpufreq.service"];
      after = mkIf config.services.auto-cpufreq.enable ["auto-cpufreq.service"];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        User = "root";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      };
      path = with pkgs; [coreutils gnugrep findutils];

      script = ''
        HWMON=""
        PROFILE_FILE="/var/run/legion-fan-profile"
        OVERRIDE_FILE="/var/run/legion-fan-override"
        THERMAL_SIGNAL="/var/run/legion-thermal-recovery"
        DEFAULT_PROFILE="${cfg.profile}"
        ON_BATTERY="${cfg.onBattery}"
        ON_AC="${cfg.onAc}"

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
        resolve_profile() {
          # Check for manual override (set by user via Fn+Q or legion_cli)
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

          # Check for thermal-guard recovery signal
          if [ -f "$THERMAL_SIGNAL" ]; then
            rm -f "$THERMAL_SIGNAL"
            echo "performance"
            return
          fi

          # Auto mode: switch based on power source
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

        # ---- Watch for platform profile changes (Fn+Q) ----
        watch_profile_changes() {
          # Use inotifywait if available, otherwise poll
          if command -v inotifywait &>/dev/null; then
            inotifywait -m -e modify /sys/firmware/acpi/platform_profile 2>/dev/null | while read -r _; do
              local new_profile
              new_profile=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo "unknown")
              echo "Platform profile changed to: $new_profile"
              # Fn+Q pressed — set override so our daemon doesn't fight it
              echo "$new_profile" > "$OVERRIDE_FILE"
            done
          fi
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

        # ---- Main loop ----
        # Start profile change watcher in background
        watch_profile_changes &

        while true; do
          desired_profile=$(resolve_profile)

          if [ "$desired_profile" != "$active_profile" ]; then
            apply_curve "$desired_profile"
            active_profile="$desired_profile"
          fi

          sleep 10
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

    # Coordinate with thermal-guard: after thermal recovery, signal fan daemon
    # to re-apply the correct curve instead of leaving it on "performance"
    systemd.services.thermal-guard = mkIf cfg.thermalGuardIntegration {
      script = mkBefore ''
        THERMAL_SIGNAL="/var/run/legion-thermal-recovery"
      '' + mkAfter ''
        # After restoring from throttle, signal the fan daemon
        # so it re-applies the correct curve instead of staying on performance
        if [ -f "$THERMAL_SIGNAL" ]; then
          rm -f "$THERMAL_SIGNAL"
        fi
        if [ "$throttled" -eq 0 ] && [ -n "$saved_profile" ]; then
          # We just recovered from throttle — tell the fan daemon
          touch "$THERMAL_SIGNAL"
        fi
      '';
    };
  };
}