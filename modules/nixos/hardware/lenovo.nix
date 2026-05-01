{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.lenovo;
in {
  options.modules.hardware.lenovo = {
    enable = mkEnableOption "Lenovo Legion hardware support";
  };

  config = mkIf cfg.enable {
    boot.kernelParams = ["acpi_osi=Linux"];

    boot.kernelModules = [
      "legion_laptop"
      "ideapad_laptop"
      "acpi_call"
    ];

    boot.extraModulePackages = with config.boot.kernelPackages; [
      lenovo-legion-module
      acpi_call
    ];

    environment.systemPackages = with pkgs; [
      lenovo-legion
      config.boot.kernelPackages.acpi_call
      legion-kb-rgb
    ];

    services.udev.extraRules = ''
      KERNEL=="no_turbo", SUBSYSTEM=="intel_pstate", MODE="0664", GROUP="wheel"
      KERNEL=="boost", SUBSYSTEM=="cpufreq", MODE="0664", GROUP="wheel"
      KERNEL=="platform_profile", SUBSYSTEM=="acpi", MODE="0664", GROUP="wheel"
      # ITE keyboard controller for RGB control
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c995", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c106", MODE="0666"
      # HID device for Spectrum keyboard (legion-kb-rgb)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0003:048D:C195.*", MODE="0666", TAG+="uaccess"
      # Detect Fn+Q platform profile changes and set manual override marker
      ACTION=="change", SUBSYSTEM=="acpi", KERNEL=="platform_profile", RUN+="${pkgs.bash}/bin/bash -c 'touch /var/run/legion-profile-override'"
    '';

    services = {
      auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
            energy_performance_preference = "power";
          };
          charger = {
            governor = "performance";
            turbo = "auto";
          };
        };
      };
      tlp.enable = mkForce false;
      power-profiles-daemon.enable = mkForce false;
    };

    hardware.sensor.iio.enable = true;

    systemd.services.thermal-guard = {
      description = "Throttle CPU and manage fans when temperature exceeds 90C (respects manual override)";
      wantedBy = ["multi-user.target"];
      after = ["systemd-modules-load.service" "systemd-udevd.service" "sysinit.target"];
      wants = ["systemd-udevd.service"];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        User = "root";
      };
      script = ''
        TEMP_HIGH=90000
        TEMP_LOW=80000
        FREQ_THROTTLE=2400000
        FREQ_NORMAL=5461000
        PLATFORM_PROFILE="/sys/firmware/acpi/platform_profile"
        MANUAL_OVERRIDE="/var/run/legion-profile-override"
        OVERRIDE_TTL=300
        throttled=0

        set_freq() {
          for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do
            echo "$1" > "$cpu" 2>/dev/null || true
          done
        }

        set_fan_profile() {
          echo "$1" > "$PLATFORM_PROFILE" 2>/dev/null || true
        }

        get_fan_profile() {
          cat "$PLATFORM_PROFILE" 2>/dev/null || echo "unknown"
        }

        is_manual_override() {
          if [ -f "$MANUAL_OVERRIDE" ]; then
            local mtime=$(stat -c %Y "$MANUAL_OVERRIDE" 2>/dev/null || echo 0)
            local now=$(date +%s)
            local age=$(( now - mtime ))
            if [ "$age" -lt "$OVERRIDE_TTL" ]; then
              return 0
            else
              rm -f "$MANUAL_OVERRIDE"
              return 1
            fi
          fi
          return 1
        }

        while true; do
          # Skip all profile changes if user has manually set a profile via Fn+Q
          if is_manual_override; then
            echo "Manual profile override active, skipping automatic changes"
            sleep 30
            continue
          fi

          temp=""
          for hwmon in /sys/class/hwmon/hwmon*; do
            if [ "$(cat "$hwmon/name" 2>/dev/null)" = "coretemp" ]; then
              temp=$(cat "$hwmon/temp1_input" 2>/dev/null)
              break
            fi
          done

          current_profile=$(get_fan_profile)
          if [ "$current_profile" = "quiet" ]; then
            set_fan_profile "balanced"
            echo "Fan profile: quiet -> balanced (quiet not allowed)"
          fi

          if [ -n "$temp" ]; then
            if [ "$temp" -ge "$TEMP_HIGH" ] && [ "$throttled" -eq 0 ]; then
              set_freq $FREQ_THROTTLE
              set_fan_profile "performance"
              throttled=1
              echo "Throttling: $((temp/1000))C >= 90C, fans -> performance"
            elif [ "$temp" -lt "$TEMP_LOW" ] && [ "$throttled" -eq 1 ]; then
              set_freq $FREQ_NORMAL
              set_fan_profile "balanced"
              throttled=0
              echo "Restored: $((temp/1000))C < 80C, fans -> balanced"
            fi
          fi
          sleep 2
        done
      '';
    };

    systemd.services.set-cpu-governor = {
      description = "Set CPU governor to performance on boot";
      wantedBy = ["multi-user.target"];
      serviceConfig.Type = "oneshot";
      script = "echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor";
    };
  };
}
