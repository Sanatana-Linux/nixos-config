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
      default = false;
      description = "Enable experimental Bluetooth features";
    };

    powerOnBoot = mkOption {
      type = types.bool;
      default = true;
      description = "Power on Bluetooth adapter on boot";
    };

    fastConnectable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable FastConnectable for quicker device connections";
    };

    autoEnable = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically enable Bluetooth adapter";
    };

    reconnectAttempts = mkOption {
      type = types.int;
      default = 7;
      description = "Number of reconnection attempts";
    };

    reconnectIntervals = mkOption {
      type = types.str;
      default = "1,2,3,4,8";
      description = "Reconnection interval pattern in seconds";
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      package = mkIf cfg.experimentalFeatures pkgs.bluez5-experimental;
      powerOnBoot = cfg.powerOnBoot;
      settings = {
        General = {
          FastConnectable = cfg.fastConnectable;
        };
        Policy = {
          ReconnectAttempts = cfg.reconnectAttempts;
          ReconnectIntervals = cfg.reconnectIntervals;
          AutoEnable = cfg.autoEnable;
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
