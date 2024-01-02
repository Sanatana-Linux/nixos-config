{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.logitech;
in {
  options.tlh.logitech = {
    enable = mkEnableOption "activate logitech settings";
  };

  config = mkIf cfg.enable {
    hardware = {
      logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };
    };
  };
}
