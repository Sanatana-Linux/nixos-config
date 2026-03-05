{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.bluetooth;
in {
  options.modules.hardware.bluetooth = {
    enable = mkEnableOption "Bluetooth hardware support";

    experimentalFeatures = mkOption {
      type = types.bool;
      default = true;
      description = "Enable experimental Bluetooth features";
    };

    autoConnect = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically connect to known devices";
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      package = mkIf cfg.experimentalFeatures pkgs.bluez5-experimental;
      settings = mkIf cfg.autoConnect {
        General = {
          AutoConnect = true;
        };
      };
    };

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      bluetuith
      bluez-tools
    ];
  };
}
