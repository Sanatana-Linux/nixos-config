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
    nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4" "9.9.9.9"];
    # make sure DHCP received nameservers don't override above
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager = {
      enable = true;
      dns = "none";
      unmanaged = ["docker0" "rndis0"];
      wifi = {
        # not while using hotel wifi at least
        # macAddress = "random";
        powersave = true;
      };
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [22 53 69 80 443 1087 3456 5572 11434];
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
