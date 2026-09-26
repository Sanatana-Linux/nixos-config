{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.devices.logitech;
in {
  options.modules.hardware.devices.logitech = {
    enable = mkEnableOption "Logitech wireless hardware support";
    enableGraphical = mkEnableOption "Logitech graphical tools";
  };

  config = mkIf cfg.enable {
    hardware.logitech.wireless.enable = true;

    # Graphical Solaar tool — option renamed from hardware.logitech.wireless.enableGraphical
    programs.solaar.enable = cfg.enableGraphical;

    environment.systemPackages = with pkgs; [
      ltunify
    ];

    services.udev.packages = with pkgs; [
      logitech-udev-rules
    ];
  };
}
