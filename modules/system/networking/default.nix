{ config, pkgs, ... }:

{

  
services.gnome.glib-networking.enable = true;
  # Network settings.
  networking = {
     # Enable networkmanager
     networkmanager.enable = true;
    
    firewall.enable = false;
    firewall.allowedTCPPorts = [
      22
      88
      1701
    ];
    firewall.allowedUDPPorts = [
      2234
      4445
    ];
  };
}