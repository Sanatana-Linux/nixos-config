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

    boot.kernel.sysctl = {
      "net.core.netdev_max_backlog" = 16384;
      "net.core.somaxconn" = 8192;
      "net.core.rmem_default" = 31457280;
      "net.core.rmem_max" = 268435456;
      "net.core.wmem_default" = 31457280;
      "net.core.wmem_max" = 268435456;
      "net.core.optmem_max" = 25165824;
      "net.ipv4.tcp_rmem" = "8192 262144 536870912";
      "net.ipv4.tcp_wmem" = "4096 65536 536870912";
      "net.ipv4.tcp_adv_win_scale" = -2;
      "net.ipv4.tcp_notsent_lowat" = 131072;
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_max_syn_backlog" = 8192;
      "net.ipv4.tcp_max_tw_buckets" = 2000000;
      "net.ipv4.tcp_tw_reuse" = 1;
      "net.ipv4.tcp_fin_timeout" = 10;
      "net.ipv4.tcp_slow_start_after_idle" = 0;
      "net.ipv4.tcp_keepalive_time" = 60;
      "net.ipv4.tcp_keepalive_intvl" = 10;
      "net.ipv4.tcp_keepalive_probes" = 6;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.tcp_timestamps" = 0;
      "net.ipv4.tcp_sack" = 1;
      "net.ipv4.tcp_fack" = 1;
      "net.ipv4.tcp_window_scaling" = 1;
      "net.ipv4.tcp_no_metrics_save" = 1;
      "net.ipv4.tcp_moderate_rcvbuf" = 1;
      "net.core.busy_poll" = 50;
      "net.core.busy_read" = 50;
      "net.core.netdev_budget" = 600;
      "net.ipv4.tcp_mem" = "1048576 1572864 2097152";
      "net.ipv4.udp_mem" = "1048576 1572864 2097152";
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };
}
