{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.logitech;
in {
  options.modules.hardware.logitech = {
    enable = mkEnableOption "Logitech wireless hardware support";
    enableGraphical = mkEnableOption "Logitech graphical tools";
  };

  config = mkIf cfg.enable {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = cfg.enableGraphical;
    };

    environment.systemPackages = with pkgs; [
      ltunify
      solaar
    ];

    services.udev.packages = with pkgs; [
      logitech-udev-rules
    ];
  };
}
