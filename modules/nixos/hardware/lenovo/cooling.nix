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
    enable = mkEnableOption "Aggressive laptop cooling — sets EC thermal/power modes and aggressive fan curves";

    thermalMode = mkOption {
      type = types.int;
      default = 3;
      description = ''
        EC thermal mode (0=quiet, 1=balanced, 2=performance, 3=extreme).
        NOTE: thermalmode is READ-ONLY on g8cn/N0CN — the EC controls it internally.
        This option only reports the expected value; the actual mode is set by Fn+Q.
      '';
    };

    powerMode = mkOption {
      type = types.int;
      default = 3;
      description = ''
        EC power mode (0=low power, 1=balanced, 2=performance, 3=turbo).
        NOTE: Value 4 (custom) is rejected by the EC on g8cn/N0CN — max is 3.
      '';
    };

    platformProfile = mkOption {
      type = types.enum ["low-power" "balanced" "performance" "custom"];
      default = "performance";
      description = "Platform profile to set at boot.";
    };

    fanFullSpeed = mkOption {
      type = types.bool;
      default = false;
      description = "Force both fans to full speed immediately at boot.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.modules.hardware.lenovo.enable;
        message = "cooling requires modules.hardware.lenovo.enable = true (for the legion_laptop kernel module)";
      }
    ];

    systemd.services.legion-cooling = {
      description = "Lenovo Legion aggressive cooling — sets EC thermal/power modes and fan curves";
      wantedBy = ["multi-user.target"];
      after = ["systemd-modules-load.service" "sysinit.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "root";
      };
      path = with pkgs; [coreutils];
      script = ''
        LEGION=""
        HWMON=""

        # Find legion sysfs path — try standard path first, then driver-path fallback
        if [ -d "/sys/devices/platform/legion" ]; then
          LEGION="/sys/devices/platform/legion"
        else
          for d in /sys/module/legion_laptop/drivers/platform:legion/*; do
            # Skip the module symlink — it's a backlink to the module dir, not a device
            basename "$d" | grep -qFx "module" && continue
            if [ -d "$d" ]; then
              LEGION="$d"
              break
            fi
          done
        fi

        # Verify this is a real device — check for characteristic files
        if [ -n "$LEGION" ] && [ ! -f "$LEGION/thermalmode" ] && [ ! -f "$LEGION/powermode" ]; then
          echo "WARNING: Found '$LEGION' but it lacks legion device files — not a bound device"
          LEGION=""
        fi

        # Find hwmon — try by name, then driver-path fallback
        for d in /sys/class/hwmon/hwmon*; do
          if [ -f "$d/name" ] && grep -q "legion" "$d/name" 2>/dev/null; then
            HWMON="$d"
            break
          fi
        done
        if [ -z "$HWMON" ] && [ -n "$LEGION" ]; then
          for d in "$LEGION"/hwmon/hwmon*; do
            if [ -d "$d" ]; then
              HWMON="$d"
              break
            fi
          done
        fi

        if [ -z "$LEGION" ]; then
          echo "ERROR: legion_laptop module not bound — check boot.kernelParams for legion_laptop.force=1"
          exit 1
        fi

        echo "=== Legion Cooling ==="
        echo "legion: $LEGION"
        echo "hwmon: $HWMON"

        # Set thermal mode (0-4, higher = more aggressive)
        if [ -f "$LEGION/thermalmode" ]; then
          echo ${toString cfg.thermalMode} > "$LEGION/thermalmode" 2>/dev/null || true
          echo "thermalmode: $(cat $LEGION/thermalmode 2>/dev/null || echo 'unavailable')"
        else
          echo "thermalmode: unavailable (EC read-only on g8cn/N0CN)"
        fi

        # Set power mode (0-4, higher = more power)
        if [ -f "$LEGION/powermode" ]; then
          echo ${toString cfg.powerMode} > "$LEGION/powermode" 2>/dev/null || true
          echo "powermode: $(cat $LEGION/powermode 2>/dev/null || echo 'unavailable')"
        fi

        # Set platform profile
        if [ -f "$LEGION/platform-profile/platform-profile-0/profile" ]; then
          echo "${cfg.platformProfile}" > "$LEGION/platform-profile/platform-profile-0/profile" 2>/dev/null || true
          echo "platform-profile: $(cat $LEGION/platform-profile/platform-profile-0/profile)"
        fi

        # Optionally force full fan speed
        if [ -f "$LEGION/fan_fullspeed" ]; then
          ${if cfg.fanFullSpeed then ''
            echo 1 > "$LEGION/fan_fullspeed" 2>/dev/null || true
            echo "fan_fullspeed: $(cat $LEGION/fan_fullspeed)"
          '' else ''
            echo 0 > "$LEGION/fan_fullspeed" 2>/dev/null || true
          ''}
        fi

        echo "=== Cooling applied ==="
      '';
    };
  };
}
