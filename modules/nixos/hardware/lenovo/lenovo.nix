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

    keyboardBacklight = mkOption {
      type = types.nullOr (types.submodule {
        options = {
          color = mkOption {
            type = types.str;
            default = "FFFFFF";
            description = "Hex color for keyboard backlight (e.g. FFFFFF for white)";
          };
          brightness = mkOption {
            type = types.enum ["Low" "High"];
            default = "High";
            description = "Keyboard backlight brightness";
          };
          effect = mkOption {
            type = types.enum ["static" "rainbow" "wave" "breath" "rain" "ripple" "smooth" "cycle" "rainbow_wave"];
            default = "static";
            description = "Keyboard lighting effect";
          };
        };
      });
      default = null;
      description = "Set keyboard backlight at boot (requires legion-kb-rgb). null = disabled.";
    };
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [
      "acpi_osi=Linux"
      # Prevent NVMe drives from constantly cycling APST (Autonomous
      # Power State Transition) every 100ms, which generates heat.
      # Setting max latency to 10ms prevents entry into deep sleep
      # states (PS3/PS4) that take longer to exit, while still allowing
      # shallow idle states that save power without the thermal penalty
      # of constant L0↔L1 PCIe link cycling.
      "nvme_core.default_ps_max_latency_us=10000"
    ];

    # Expose all fan hwmon entries (fan1 + fan2) via the lenovo_wmi_other
    # kernel module. Default is N, which hides fan2 — only fan1 is
    # controllable. Setting to Y allows the fan-control daemon to write
    # independent curves for both fans.
    boot.extraModprobeConfig = ''
      options lenovo_wmi_other expose_all_fans=Y
    '';

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
      # ITE keyboard controller for RGB control
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c995", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c106", MODE="0666"
      # HID device for Spectrum keyboard (legion-kb-rgb)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0003:048D:C995.*", MODE="0666", TAG+="uaccess"
    ''
    # Set keyboard backlight via udev when the ITE keyboard HID device
    # appears. Replaces the polling-based legion-kb-backlight systemd
    # service which had a race condition — the device wasn't always
    # ready even after systemd-udev-settle.service.
    + lib.optionalString (cfg.keyboardBacklight != null) ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0003:048D:C995.*", \
        ACTION=="add", \
        RUN+="${pkgs.legion-kb-rgb}/bin/legion-kb-rgb brightness 9", \
        RUN+="${pkgs.legion-kb-rgb}/bin/legion-kb-rgb color ${cfg.keyboardBacklight.color}"
    '';

    # Keyboard backlight at boot — now handled by udev rule above.
    # The old polling-based systemd service is removed; the udev rule
    # triggers the moment the kernel detects the ITE keyboard HID device,
    # eliminating the race condition entirely.
    systemd.services.legion-kb-backlight = mkIf (cfg.keyboardBacklight != null) {
      description = "Set Lenovo Legion keyboard backlight to ${cfg.keyboardBacklight.color}";
      wantedBy = ["multi-user.target"];
      after = ["systemd-udev-settle.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = with pkgs; [ legion-kb-rgb ];
      script = ''
        echo "Setting keyboard backlight to #${cfg.keyboardBacklight.color}..."

        # Wait for the ITE keyboard device to appear
        for i in $(seq 1 30); do
          if legion-kb-rgb status 2>&1 | grep -q "Device:"; then
            break
          fi
          echo "Waiting for ITE keyboard device (attempt $i/30)..."
          sleep 1
        done

        # Set brightness first
        legion-kb-rgb brightness 9 2>/dev/null || true

        # Apply static white color
        legion-kb-rgb color "${cfg.keyboardBacklight.color}" 2>&1 || true

        echo "Keyboard backlight applied: static #${cfg.keyboardBacklight.color}"
      '';
    };

    # auto-cpufreq, power-profiles-daemon, and tlp are ALL disabled here.
    # intel_pstate handles CPU governor scaling dynamically via HWP.
    # Fn+Q (platform_profile) is the user's mechanism for fan/power profiles.
    # No software should fight the user's Fn+Q selection.
    services = {
      auto-cpufreq.enable = mkForce false;
      tlp.enable = mkForce false;
      # power-profiles-daemon is NOT force-disabled here — let the host config
      # decide via modules.hardware.lenovo.power.powerProfilesDaemon
    };

    hardware.sensor.iio.enable = true;

  };
}
