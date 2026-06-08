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
      # Prevent NVMe drives from constantly cycling APST (Autonomous
      # Power State Transition) every 100ms, which generates heat.
      # Setting max latency to 10ms prevents entry into deep sleep
      # states (PS3/PS4) that take longer to exit, while still allowing
      # shallow idle states that save power without the thermal penalty
      # of constant L0↔L1 PCIe link cycling.
      "nvme_core.default_ps_max_latency_us=10000"
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
      # ITE keyboard controller for RGB control
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c995", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c106", MODE="0666"
      # HID device for Spectrum keyboard (legion-kb-rgb)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0003:048D:C195.*", MODE="0666", TAG+="uaccess"
    '';

    # auto-cpufreq, power-profiles-daemon, and tlp are ALL disabled here.
    # intel_pstate handles CPU governor scaling dynamically via HWP.
    # Fn+Q (platform_profile) is the user's mechanism for fan/power profiles.
    # No software should fight the user's Fn+Q selection.
    services = {
      auto-cpufreq.enable = mkForce false;
      tlp.enable = mkForce false;
      power-profiles-daemon.enable = mkForce false;
    };

    hardware.sensor.iio.enable = true;

  };
}
