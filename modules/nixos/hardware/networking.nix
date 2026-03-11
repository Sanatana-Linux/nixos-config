{
  config,
  lib,
  ...
}:
with lib; {
  options.modules.hardware.networking = {
    enable = mkEnableOption "Network hardware support";

    hostName = mkOption {
      type = types.str;
      description = "The hostname for this machine";
    };

    firewall = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable firewall";
      };
      allowedTCPPorts = mkOption {
        type = types.listOf types.port;
        default = [];
        description = "Allowed TCP ports";
      };
      allowedUDPPorts = mkOption {
        type = types.listOf types.port;
        default = [];
        description = "Allowed UDP ports";
      };
    };

    wifi = {
      powersave = mkOption {
        type = types.bool;
        default = true;
        description = "Enable WiFi power saving";
      };
      randomMac = mkOption {
        type = types.bool;
        default = true;
        description = "Randomize WiFi MAC address";
      };
    };
  };

  config = mkIf config.modules.hardware.networking.enable {
    networking = {
      hostName = config.modules.hardware.networking.hostName;
      nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4" "9.9.9.9"];
      networkmanager = {
        enable = true;
        dns = "default";
        unmanaged = ["docker0" "rndis0"];
        wifi = {
          #          macAddress = "random";
          powersave = config.modules.hardware.networking.wifi.powersave;
        };
      };

      firewall = {
        enable = config.modules.hardware.networking.firewall.enable;
        allowedTCPPorts = config.modules.hardware.networking.firewall.allowedTCPPorts;
        allowedUDPPorts = config.modules.hardware.networking.firewall.allowedUDPPorts;
      };
    };

    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
