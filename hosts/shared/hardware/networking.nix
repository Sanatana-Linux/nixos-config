{pkgs, config, ...}:{
  networking = {
    networkmanager = {
      enable = true;
      unmanaged = ["docker0" "rndis0"];
         wifi = {
          macAddress = "random";
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
