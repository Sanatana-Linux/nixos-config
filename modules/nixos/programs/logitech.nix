{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.programs.logitech;
in {
  options.modules.programs.logitech = {
    enable = mkEnableOption "Logitech wireless hardware support";
    enableGraphical = mkEnableOption "Logitech graphical tools";
  };

  config = mkIf cfg.enable {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = cfg.enableGraphical;
    };
  };
}
