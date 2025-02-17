{
  pkgs,
  config,
  ...
}: {
  boot.kernel.sysctl = {
    # Bufferbloat mitigations + slight improvements in throughput and latency.
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";
    # Fast Open is a TCP extension that reduces network latency by packing
    # data in the sender’s initial TCP SYN.
    # NOTE: Setting 3 = enable for both incoming and outgoing connections.
    "net.ipv4.tcp_fastopen" = 3;
  };
  networking = {
    networkmanager = {
      enable = true;
      unmanaged = ["docker0" "rndis0"];
      wifi = {
        #        macAddress = "random";
        powersave = true;
      };
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [22 69 80 443 1087 3456 11434];
      allowedUDPPortRanges = [
        {
          from = 4000;
          to = 4007;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
      allowPing = false;
      logReversePathDrops = true;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
