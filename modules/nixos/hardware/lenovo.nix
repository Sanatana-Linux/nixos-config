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
    # Kernel modules for Lenovo hardware
    boot.kernelModules = [
      "legion_laptop" # Fan and power control for Lenovo Legion laptops
      "ideapad_laptop" # Keyboard hotkeys and ACPI support for Lenovo laptops
      "acpi_call" # Allows calling ACPI methods from userspace
    ];

    # Extra module packages
    boot.extraModulePackages = with config.boot.kernelPackages; [
      lenovo-legion-module
      acpi_call
    ];

    # System packages
    environment.systemPackages = with pkgs; [
      lenovo-legion
      config.boot.kernelPackages.acpi_call
    ];

    # Udev rules for CPU boost and platform profile
    services.udev.extraRules = ''
      KERNEL=="no_turbo", SUBSYSTEM=="intel_pstate", MODE="0664", GROUP="wheel"
      KERNEL=="boost", SUBSYSTEM=="cpufreq", MODE="0664", GROUP="wheel"
      KERNEL=="platform_profile", SUBSYSTEM=="acpi", MODE="0664", GROUP="wheel"
      # ITE keyboard controller for RGB control
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c995", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c106", MODE="0666"
    '';

    systemd.services.legion-longevity = {
      description = "Set Legion laptop to longevity mode (boost off, fans max)";
      wantedBy = ["multi-user.target"];
      after = ["systemd-modules-load.service" "systemd-udevd.service" "sysinit.target"];
      wants = ["systemd-udevd.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/bash -c 'echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo && echo performance > /sys/firmware/acpi/platform_profile'";
      };
    };

    systemd.services.thermal-guard = {
      description = "Throttle CPU and manage fans when temperature exceeds 90C";
      wantedBy = ["multi-user.target"];
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

        while true; do
          temp=""
          for hwmon in /sys/class/hwmon/hwmon*; do
            # Check for Intel coretemp sensor instead of AMD k10temp
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
  };
}
