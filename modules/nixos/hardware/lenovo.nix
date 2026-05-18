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
    boot.kernelParams = [
      "acpi_osi=Linux"
      # Strip the built-in _OSI strings the kernel adds automatically.
      # This prevents the kernel from claiming Windows compatibility,
      # which stops Lenovo firmware from attempting Windows-specific
      # ACPI methods (DSDT) that don't exist on Linux — the source of
      # harmless but noisy ACPI errors (AE_NOT_FOUND, AE_AML, etc.)
      # visible during boot, especially without Plymouth.
      "acpi_osi="
    ];

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
      # Power management is handled by power-profiles-daemon + platform_profile (Fn+Q).
      # No userland governor polling — let intel_pstate and the kernel manage it.
      power-profiles-daemon.enable = mkForce true;
      tlp.enable = mkForce false;
      auto-cpufreq.enable = mkForce false;
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
        TEMP_LOW=65000
        FREQ_THROTTLE=2400000
        FREQ_NORMAL=5461000
        PLATFORM_PROFILE="/sys/firmware/acpi/platform_profile"
        MANUAL_OVERRIDE="/var/run/legion-profile-override"
        OVERRIDE_TTL=1800
        throttled=0
        saved_profile=""

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
          if is_manual_override; then
            if [ "$throttled" -eq 1 ]; then
              set_freq $FREQ_NORMAL
              throttled=0
            fi
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
            set_fan_profile "performance"
          fi

          if [ -n "$temp" ]; then
            if [ "$temp" -ge "$TEMP_HIGH" ] && [ "$throttled" -eq 0 ]; then
              saved_profile=$(get_fan_profile)
              set_freq $FREQ_THROTTLE
              set_fan_profile "performance"
              throttled=1
              echo "Throttling: $((temp/1000))C >= 90C, fans -> performance"
            elif [ "$temp" -lt "$TEMP_LOW" ] && [ "$throttled" -eq 1 ]; then
              set_freq $FREQ_NORMAL
              if [ -n "$saved_profile" ] && [ "$saved_profile" != "performance" ]; then
                set_fan_profile "$saved_profile"
              fi
              throttled=0
              saved_profile=""
              echo "Cooled: $((temp/1000))C < 80C, restoring max freq"
            fi
          fi
          sleep 2
        done
      '';
    };

    systemd.services.set-cpu-governor.enable = mkForce false;
  };
}
