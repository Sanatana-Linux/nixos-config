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
      rtl88x2bu = {
        enable = mkEnableOption "Realtek RTL88x2BU USB WiFi adapter driver (for monitor mode, aircrack, etc.)";
      };
    };

    quad9 = {
      enable = mkEnableOption "Quad9 DNS servers with ECS and threat blocking";
    };
  };

  config = mkIf config.modules.hardware.networking.enable {
    networking = {
      hostName = config.modules.hardware.networking.hostName;
      nameservers =
        if config.modules.hardware.networking.quad9.enable
        then ["9.9.9.11" "149.112.112.11" "2620:fe::11" "2620:fe::fe:11"]
        else ["1.1.1.1" "8.8.8.8" "8.8.4.4" "9.9.9.9"];
      networkmanager = {
        enable = true;
        dns = "default";
        unmanaged = ["docker0" "rndis0"];
        wifi = {
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

    boot.extraModulePackages = mkIf config.modules.hardware.networking.wifi.rtl88x2bu.enable [
      config.boot.kernelPackages.rtl88x2bu
    ];

    boot.kernelModules = mkIf config.modules.hardware.networking.wifi.rtl88x2bu.enable [
      "88x2bu"
    ];

    boot.kernelParams = mkIf config.modules.hardware.networking.wifi.rtl88x2bu.enable [
      "rtw_switch_usb_mode=1"
    ];

    boot.blacklistedKernelModules = mkIf config.modules.hardware.networking.wifi.rtl88x2bu.enable [
      "rtw88_core"
      "rtw_usb"
    ];
  };
}
