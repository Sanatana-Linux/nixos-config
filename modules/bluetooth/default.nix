{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.bluetooth;
in {
  options.tlh.bluetooth = {
    enable = mkEnableOption "activate bluetooth";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {enable = true;};

    services.blueman.enable = true;
  };
}
