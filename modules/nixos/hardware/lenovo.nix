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
      "lenovo_legion" # Fan and power control for Lenovo Legion laptops
      "ideapad_laptop" # Keyboard hotkeys and ACPI support for Lenovo laptops
      "acpi_call" # Allows calling ACPI methods from userspace
    ];

    # Kernel parameters
    boot.kernelParams = [
      "lenovo-legion.force=1" # Force load the Legion driver even if not detected
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
  };
}
