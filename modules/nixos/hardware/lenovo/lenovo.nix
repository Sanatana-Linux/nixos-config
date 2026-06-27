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
      # Force legion_laptop to bind — DMI table doesn't include this model
      "legion_laptop.force=1"
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

    # ── Force legion_laptop to bind to the EC device ─────────────────
    # The in-kernel acpi-ec driver claims PNP0C09:00 first (during ACPI
    # init), leaving legion_laptop's driver orphaned even with force=1.
    # This service unbinds acpi-ec and binds legion_laptop instead.
    # The legion_laptop module IS the EC driver for this hardware — it
    # reads/writes the same EC registers and exposes Legion-specific
    # controls.  driver_override is set so the rebind survives module
    # reloads.
    systemd.services.legion-driver-bind = {
      description = "Force legion_laptop to bind to the ACPI EC device (PNP0C09:00)";
      wantedBy = ["multi-user.target"];
      before = ["legion-fan-control.service"];
      after = ["systemd-modules-load.service" "sysinit.target"];
      # Reload on nixos-rebuild switch — kernel module package may change
      reloadTriggers = [
        config.system.build.kernel.modules
      ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "root";
        # Restart on nixos-rebuild switch so the bind is re-applied
        X-Restart-Triggers = "${config.system.build.kernel.modules}";
      };
      script = ''
        EC_PLATFORM_DEV="PNP0C09:00"
        EC_PLATFORM_PATH="/sys/devices/pci0000:00/0000:00:1f.0/$EC_PLATFORM_DEV"
        LEGION_DRIVER="/sys/bus/platform/drivers/legion"
        ACPI_EC_DRIVER="/sys/bus/platform/drivers/acpi-ec"

        # Ensure the module is loaded (may have been unloaded during switch)
        if ! lsmod | grep -q "^legion_laptop "; then
          echo "=== legion_laptop not loaded — loading module ==="
          modprobe legion_laptop 2>/dev/null || true
          sleep 1
        fi

        # Check whether legion is already bound
        LEGION_BOUND=false
        for d in "$LEGION_DRIVER"/*; do
          basename "$d" | grep -qFx "module" && continue
          if [ -d "$d" ]; then
            LEGION_BOUND=true
            break
          fi
        done

        if ! $LEGION_BOUND && [ -d "$EC_PLATFORM_PATH" ]; then
          CURRENT_DRIVER=$(readlink "$EC_PLATFORM_PATH/driver" 2>/dev/null || echo "")
          if echo "$CURRENT_DRIVER" | grep -q "acpi-ec"; then
            echo "=== Rebinding EC from acpi-ec → legion_laptop ==="
            echo "$EC_PLATFORM_DEV" > "$ACPI_EC_DRIVER/unbind" 2>/dev/null || true
            echo "$EC_PLATFORM_DEV" > "$LEGION_DRIVER/bind" 2>/dev/null || true
            echo "legion" > "$EC_PLATFORM_PATH/driver_override" 2>/dev/null || true
          fi
        fi

        echo "legion_laptop: $(lsmod | grep -q '^legion_laptop ' && echo 'loaded' || echo 'not loaded')"
        echo "legion bound: $($LEGION_BOUND && echo 'yes' || echo 'no')"
      '';
    };

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
        RUN+="${pkgs.bash}/bin/bash -c '${pkgs.legion-kb-rgb}/bin/legion-kb-rgb brightness 9 && ${pkgs.legion-kb-rgb}/bin/legion-kb-rgb color ${cfg.keyboardBacklight.color}'"
    '';

    # Keyboard backlight at boot — handled exclusively by the udev rule above.
    # NO systemd service here: the udev RUN+= triggers the moment the ITE
    # keyboard HID device appears, avoiding the double-open conflict that
    # caused "Broken pipe" errors when both the service and udev rule tried
    # to write to /dev/hidraw* simultaneously.

    # power-profiles-daemon is NOT force-disabled here — let the host config
    # decide via modules.hardware.lenovo.power.powerProfilesDaemon
    services = {};

    hardware.sensor.iio.enable = true;

  };
}
