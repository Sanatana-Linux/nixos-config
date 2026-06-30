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
          colors = mkOption {
            type = types.str;
            default = "255,255,255,255,255,255,255,255,255,255,255,255";
            description = "4 RGB triplets comma-separated (R,G,B per zone, 4 zones). Default: all white.";
          };
          brightness = mkOption {
            type = types.enum ["Low" "High"];
            default = "High";
            description = "Keyboard backlight brightness";
          };
          effect = mkOption {
            type = types.enum ["Static" "Breath" "Smooth" "Wave" "Lightning" "AmbientLight" "SmoothWave" "Swipe" "Disco" "Christmas" "Fade" "Temperature" "Ripple"];
            default = "Static";
            description = "Keyboard lighting effect (legion-rgb-control effect name)";
          };
        };
      });
      default = null;
      description = "Set keyboard backlight at boot (requires legion-rgb-control). null = disabled.";
    };
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [
      "acpi_osi=Linux"
      # Allow NVMe autonomous power state transitions. The default
      # max latency of 10000µs allows sleep up to PS3 (~5ms exit)
      # which balances power saving with responsiveness.  Setting
      # to 0 DISABLES APST entirely — drives never sleep, PCIe
      # links stay in L0, PCH can't enter deep C-states.
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
      path = with pkgs; [kmod coreutils];
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
      legion-rgb-control
    ];

    services.udev.extraRules = ''
      # ITE keyboard controller for RGB control
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c995", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c106", MODE="0666"
      # HID device for Spectrum keyboard (legion-rgb-control)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0003:048D:C995.*", MODE="0666", TAG+="uaccess"
    '';

    # Keyboard backlight at boot — runs after udev settles so the
    # hidraw device is available. Uses legion-rgb-control (Rust binary
    # from 4JX/L5P-Keyboard-RGB) which supports this hardware.
    systemd.services.legion-kb-rgb = mkIf (cfg.keyboardBacklight != null) {
      description = "Set Legion keyboard backlight at boot";
      wantedBy = ["multi-user.target"];
      after = ["systemd-udev-settle.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = with pkgs; [legion-rgb-control];
      script = let
        kb = cfg.keyboardBacklight;
      in ''
        for i in $(seq 1 10); do
          if legion-rgb-control set --effect ${kb.effect} --colors ${kb.colors} -b ${kb.brightness} 2>/dev/null; then
            exit 0
          fi
          sleep 1
        done
        echo "legion-rgb-control: failed to access keyboard after 10s" >&2
        exit 1
      '';
    };

    # power-profiles-daemon is NOT force-disabled here — let the host config
    # decide via modules.hardware.lenovo.power.powerProfilesDaemon

    hardware.sensor.iio.enable = true;
  };
}
