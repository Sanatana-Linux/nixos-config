{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.virtualization.lxc = {
    enable = mkEnableOption "LXC/LXD container virtualization";
  };

  config = mkIf config.modules.virtualization.lxc.enable {
    virtualisation.lxc.enable = true;
    virtualisation.lxc.lxcfs.enable = true;

    # Waydroid / LXC networking fix for some kernels
    environment.etc."ethertypes".source = lib.mkForce (pkgs.writeText "ethertypes" ''
      # Ethernet type numbers
      #
      # Name       Hex         Description
      #
      IPv4       0800        Internet Protocol version 4
      ARP        0806        Address Resolution Protocol
      Wake-on-LAN 0842       Wake-on-LAN
      IETF-TRILL 22F3        IETF TRILL Protocol
      DECnet     6003        DECnet Phase IV
      RARP       8035        Reverse Address Resolution Protocol
      AppleTalk  809B        AppleTalk (Ethertalk)
      AARP       80F3        AppleTalk Address Resolution Protocol
      VLAN       8100        IEEE 802.1Q VLAN-tagged frames
      IPX        8137        IPX
      Q-in-Q     88A8        IEEE 802.1ad Provider Bridge
      IPv6       86DD        Internet Protocol version 6
      MACControl 8808        MAC Control
      Slow       8809        Slow Protocols (IEEE 802.3)
      CobraNet   8819        CobraNet
      MPLS-uc    8847        MPLS unicast
      MPLS-mc    8848        MPLS multicast
      PPPoE-Disc 8863        PPPoE Discovery Stage
      PPPoE-Sess 8864        PPPoE Session Stage
      Jumbo      8870        Jumbo Frames
      HomePlug   887B        HomePlug 1.0 MME
      EAPOL      888E        EAP over LAN (IEEE 802.1X)
      PROFINET   8892        PROFINET
      HyperSCSI  889A        HyperSCSI (SCSI over Ethernet)
      AoE        88A2        ATA over Ethernet
      EtherCAT   88A4        EtherCAT
      Powerlink  88AB        Ethernet Powerlink
      LLDP       88CC        Link Layer Discovery Protocol (LLDP)
      SERCOS     88CD        SERCOS III
      HomePlugAV 88E1        HomePlug AV MME
      MRP        88E3        Media Redundancy Protocol (IEC62439-2)
      MACSec     88E5        MAC security (IEEE 802.1AE)
      PTP        88F7        Precision Time Protocol (IEEE 1588)
      CFM        8902        IEEE 802.1ag Connectivity Fault Management
      FCoE       8906        Fibre Channel over Ethernet
      FCoE-Init  8914        FCoE Initialization Protocol
      RoCE       8915        RDMA over Converged Ethernet
      HSR        892F        High-availability Seamless Redundancy
      CTP        9000        Configuration Test Protocol
      VLAN-double 9100       VLAN Double Tagging
    '');

    environment.systemPackages = with pkgs; [
      lxc
    ];
  };
}
