{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.lenovo.fan-control;

  # Convert PWM (0-255) to RPM (max ~4500 RPM for Legion fans)
  pwmToRpm = pwm:
    if pwm == 0
    then 0
    else builtins.div (pwm * 4500) 255;

  fanCurvePoint = {
    cpu,
    gpu,
    ic,
    f1,
    f2,
    a,
    d,
  }: {
    inherit cpu gpu ic f1 f2 a d;
  };

  quietCurve = {
    points = [
      (fanCurvePoint {
        cpu = 0;
        gpu = 0;
        ic = 0;
        f1 = 0;
        f2 = 0;
        a = 3;
        d = 4;
      })
      (fanCurvePoint {
        cpu = 35;
        gpu = 45;
        ic = 45;
        f1 = 71;
        f2 = 68;
        a = 3;
        d = 4;
      })
      (fanCurvePoint {
        cpu = 41;
        gpu = 46;
        ic = 46;
        f1 = 82;
        f2 = 79;
        a = 3;
        d = 3;
      })
      (fanCurvePoint {
        cpu = 46;
        gpu = 47;
        ic = 47;
        f1 = 92;
        f2 = 89;
        a = 2;
        d = 3;
      })
      (fanCurvePoint {
        cpu = 49;
        gpu = 48;
        ic = 48;
        f1 = 102;
        f2 = 99;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 55;
        gpu = 50;
        ic = 49;
        f1 = 115;
        f2 = 112;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 62;
        gpu = 55;
        ic = 53;
        f1 = 130;
        f2 = 127;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 69;
        gpu = 60;
        ic = 57;
        f1 = 145;
        f2 = 142;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 76;
        gpu = 66;
        ic = 61;
        f1 = 160;
        f2 = 157;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 85;
        gpu = 75;
        ic = 70;
        f1 = 175;
        f2 = 172;
        a = 2;
        d = 2;
      })
    ];
  };

  balancedCurve = {
    points = [
      (fanCurvePoint {
        cpu = 0;
        gpu = 0;
        ic = 0;
        f1 = 0;
        f2 = 0;
        a = 2;
        d = 3;
      })
      (fanCurvePoint {
        cpu = 30;
        gpu = 30;
        ic = 30;
        f1 = 82;
        f2 = 79;
        a = 2;
        d = 3;
      })
      (fanCurvePoint {
        cpu = 36;
        gpu = 36;
        ic = 35;
        f1 = 97;
        f2 = 94;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 42;
        gpu = 42;
        ic = 40;
        f1 = 112;
        f2 = 109;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 48;
        gpu = 47;
        ic = 44;
        f1 = 130;
        f2 = 127;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 54;
        gpu = 51;
        ic = 48;
        f1 = 148;
        f2 = 145;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 60;
        gpu = 56;
        ic = 52;
        f1 = 166;
        f2 = 163;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 66;
        gpu = 61;
        ic = 56;
        f1 = 184;
        f2 = 181;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 72;
        gpu = 67;
        ic = 60;
        f1 = 200;
        f2 = 197;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 80;
        gpu = 75;
        ic = 66;
        f1 = 217;
        f2 = 214;
        a = 2;
        d = 2;
      })
    ];
  };

  performanceCurve = {
    points = [
      (fanCurvePoint {
        cpu = 0;
        gpu = 0;
        ic = 0;
        f1 = 0;
        f2 = 0;
        a = 2;
        d = 3;
      })
      (fanCurvePoint {
        cpu = 25;
        gpu = 25;
        ic = 25;
        f1 = 115;
        f2 = 110;
        a = 2;
        d = 3;
      })
      (fanCurvePoint {
        cpu = 31;
        gpu = 31;
        ic = 30;
        f1 = 145;
        f2 = 140;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 37;
        gpu = 37;
        ic = 35;
        f1 = 175;
        f2 = 170;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 43;
        gpu = 42;
        ic = 39;
        f1 = 200;
        f2 = 195;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 49;
        gpu = 46;
        ic = 43;
        f1 = 220;
        f2 = 215;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 55;
        gpu = 51;
        ic = 47;
        f1 = 235;
        f2 = 230;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 61;
        gpu = 56;
        ic = 51;
        f1 = 245;
        f2 = 240;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 67;
        gpu = 62;
        ic = 55;
        f1 = 255;
        f2 = 255;
        a = 2;
        d = 2;
      })
      (fanCurvePoint {
        cpu = 75;
        gpu = 70;
        ic = 61;
        f1 = 255;
        f2 = 255;
        a = 2;
        d = 2;
      })
    ];
  };

  # Generate a single YAML entry from a curve point and temp range
  mkEntry = low: p: high: ''
    - fan1_speed: ${toString (pwmToRpm p.f1)}
      fan2_speed: ${toString (pwmToRpm p.f2)}
      cpu_lower_temp: ${toString low}
      cpu_upper_temp: ${toString high}
      gpu_lower_temp: ${toString low}
      gpu_upper_temp: ${toString high}
      ic_lower_temp: ${toString low}
      ic_upper_temp: ${toString high}
      acceleration: ${toString p.a}
      deceleration: ${toString p.d}
  '';

  # Build midpoints between consecutive curve points
  midpoints = pts:
    imap0 (i: p:
      if i == 0
      then 0
      else let
        prev = builtins.elemAt pts (i - 1);
      in
        (prev.cpu + p.cpu) / 2)
    pts;

  # Generate complete YAML for a fan curve
  genYaml = name: curve: let
    pts = curve.points;
    temps = map (p: p.cpu) pts;
    mids = midpoints pts ++ [127];
    entries = imap0 (i: p:
      mkEntry (builtins.elemAt mids i) p (builtins.elemAt mids (i + 1)))
    pts;
  in ''
    name: ${name}
    entries:
    ${concatStrings entries}enable_minifancurve: false
  '';

  # Produce {ac,battery} variants — same curve, different filename
  mkProfileYamls = name: curve: {
    "legion/fan-curves/${name}-ac.yaml".text = genYaml "${name}-ac" curve;
    "legion/fan-curves/${name}-battery.yaml".text = genYaml "${name}-battery" curve;
  };

  allYamls =
    mkProfileYamls "quiet" quietCurve
    // mkProfileYamls "balanced" balancedCurve
    // mkProfileYamls "performance" performanceCurve;

  # The core script — detects profile + power source, calls legion_cli
  applyScript = pkgs.writeShellScriptBin "legion-fan-apply" ''
    set -e
    PROFILE="''${1:-}"

    # Detect power source
    SOURCE="battery"
    for bat in /sys/class/power_supply/AC*/online /sys/class/power_supply/ADP*/online; do
      if [ -f "$bat" ] && [ "$(cat "$bat" 2>/dev/null)" = "1" ]; then
        SOURCE="ac"
        break
      fi
    done

    if [ -z "$PROFILE" ]; then
      # Auto: resolve from platform_profile (Fn+Q state)
      PP=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo "balanced")
      case "$PP" in
        low-power|quiet)   PROFILE="quiet" ;;
        balanced)          PROFILE="balanced" ;;
        performance)       PROFILE="performance" ;;
        *)                 PROFILE="balanced" ;;
      esac
    fi

    FILE="/etc/legion/fan-curves/''${PROFILE}-''${SOURCE}.yaml"

    if [ ! -f "$FILE" ]; then
      echo "ERROR: Fan curve file not found: $FILE" >&2
      exit 1
    fi

    echo "Applying fan curve: ''${PROFILE} (''${SOURCE})"
    exec ${pkgs.lenovo-legion}/bin/legion_cli --donotexpecthwmon fancurve-write-file-to-hw "$FILE"
  '';
in {
  options.modules.hardware.lenovo.fan-control = {
    enable = mkEnableOption "Lenovo Legion fan curve control via legion_cli";

    profile = mkOption {
      type = types.enum ["quiet" "balanced" "performance" "auto"];
      default = "auto";
      description = "Default fan profile (auto = Fn+Q + power source)";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.modules.hardware.lenovo.enable;
        message = "fan-control requires modules.hardware.lenovo.enable = true";
      }
    ];

    # Generate YAML fan curve files under /etc/legion/fan-curves/
    environment.etc = allYamls;

    # Boot-time oneshot — wait for hwmon then apply curve
    systemd.services.legion-fan-boot = {
      description = "Apply Lenovo Legion fan curve at boot";
      wantedBy = ["multi-user.target"];
      after = ["systemd-modules-load.service"];
      before = ["legion-fan-poll.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = false;
      };
      path = with pkgs; [bash coreutils findutils lenovo-legion];
      script = ''
        # Wait for legion hwmon (PNP0C09:00 under kernel 7.x)
        for i in $(seq 1 30); do
          if find /sys/module/legion_laptop/drivers/platform:legion/ -mindepth 2 -name hwmon 2>/dev/null | grep -q .; then
            break
          fi
          sleep 2
        done
        ${applyScript}/bin/legion-fan-apply
      '';
    };

    # udev rule: re-apply on AC plug/unplug
    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", ACTION=="change", RUN+="${applyScript}/bin/legion-fan-apply"
    '';

    # Minimal polling service — Fn+Q detection (no udev events for platform_profile)
    systemd.services.legion-fan-poll = {
      description = "Lenovo Legion fan curve Fn+Q watcher";
      wantedBy = ["multi-user.target"];
      after = ["legion-fan-boot.service"];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        User = "root";
      };
      path = with pkgs; [bash coreutils];
      script = ''
        LAST=""
        while true; do
          # Check thermal guard recovery signal
          if [ -f /var/run/legion-thermal-recovery ]; then
            rm -f /var/run/legion-thermal-recovery
            ${applyScript}/bin/legion-fan-apply
            LAST=""  # force re-read of platform_profile
            sleep 5
            continue
          fi
          CUR=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo "unknown")
          if [ "$CUR" != "$LAST" ]; then
            ${applyScript}/bin/legion-fan-apply
            LAST="$CUR"
          fi
          sleep 5
        done
      '';
    };

    # Ensure signal file directory for thermal guard
    systemd.tmpfiles.rules = [
      "d /var/run/legion 0755 root root -"
    ];

    # Manual override CLI — replaces old legion-fan
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "legion-fan" ''
        case "''${1:-}" in
          quiet|balanced|performance)
            ${applyScript}/bin/legion-fan-apply "$1"
            echo "Fan curve set to: $1"
            ;;
          auto)
            ${applyScript}/bin/legion-fan-apply
            echo "Fan curve: auto (Fn+Q + power source)"
            ;;
          status)
            echo "Platform profile: $(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo 'N/A')"
            for bat in /sys/class/power_supply/AC*/online /sys/class/power_supply/ADP*/online; do
              if [ -f "$bat" ]; then
                echo "AC adapter: $(cat "$bat" 2>/dev/null)"
              fi
            done
            echo "Fan speeds (RPM):"
            for hwmon in /sys/class/hwmon/hwmon*; do
              if [ -f "$hwmon/name" ] && grep -q legion "$hwmon/name" 2>/dev/null; then
                cat "$hwmon/fan1_input" 2>/dev/null && echo " RPM"
                cat "$hwmon/fan2_input" 2>/dev/null && echo " (fan2 RPM)"
              fi
            done
            ;;
          *)
            echo "Usage: legion-fan {quiet|balanced|performance|auto|status}"
            echo ""
            echo "  quiet        - Moderate cooling, good idle"
            echo "  balanced     - Aggressive cooling, fast spin-up"
            echo "  performance  - Maximum cooling, full speed at high temps"
            echo "  auto         - Follow Fn+Q key + power source"
            echo "  status       - Show current state"
            ;;
        esac
      '')
    ];
  };
}
