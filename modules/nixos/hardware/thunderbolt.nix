{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.hardware.thunderbolt;
in {
  options.modules.hardware.thunderbolt = {
    enable = mkEnableOption "Thunderbolt hardware support";

    enableBoltDaemon = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the bolt daemon for Thunderbolt device authorization";
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.availableKernelModules = ["thunderbolt"];

    services.hardware.bolt = mkIf cfg.enableBoltDaemon (mkDefault {enable = true;});
  };
}
