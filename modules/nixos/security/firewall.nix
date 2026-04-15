{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.security.firewall;
in {
  options.modules.security.firewall = {
    enable = mkEnableOption "NixOS firewall with secure defaults";

    allowSSH = mkOption {
      type = types.bool;
      default = true;
      description = "Allow SSH connections (port 22)";
    };

    allowHTTP = mkOption {
      type = types.bool;
      default = false;
      description = "Allow HTTP connections (port 80)";
    };

    allowHTTPS = mkOption {
      type = types.bool;
      default = false;
      description = "Allow HTTPS connections (port 443)";
    };

    allowDevelopment = mkOption {
      type = types.bool;
      default = false;
      description = "Allow common development ports (8000, 8080, 3000, etc.)";
    };

    customTcpPorts = mkOption {
      type = types.listOf types.int;
      default = [];
      description = "Additional TCP ports to allow";
    };

    customUdpPorts = mkOption {
      type = types.listOf types.int;
      default = [];
      description = "Additional UDP ports to allow";
    };

    trustedInterfaces = mkOption {
      type = types.listOf types.str;
      default = ["lo"]; # localhost interface
      description = "Network interfaces to trust completely";
    };

    allowedTCPPortRanges = mkOption {
      type = types.listOf (types.submodule {
        options = {
          from = mkOption {
            type = types.int;
            description = "Start of TCP port range";
          };
          to = mkOption {
            type = types.int;
            description = "End of TCP port range";
          };
        };
      });
      default = [];
      description = "TCP port ranges to allow";
    };

    logRefusedConnections = mkOption {
      type = types.bool;
      default = true;
      description = "Log refused connections for security analysis";
    };

    logRefusedPackets = mkOption {
      type = types.bool;
      default = false;
      description = "Log refused packets (can be noisy)";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = mkForce true;

      # Always allow localhost traffic
      trustedInterfaces = cfg.trustedInterfaces;

      # Basic allowed ports
      allowedTCPPorts =
        (optional cfg.allowSSH 22)
        ++ (optional cfg.allowHTTP 80)
        ++ (optional cfg.allowHTTPS 443)
        ++ (optionals cfg.allowDevelopment [
          3000 # Common dev server (React, etc.)
          5173 # Vite dev server
          8000 # Common development port
          8080 # Alternative HTTP port
          8443 # Alternative HTTPS port
        ])
        ++ cfg.customTcpPorts;

      # UDP ports (mainly for development tools)
      allowedUDPPorts = cfg.customUdpPorts;

      # Port ranges
      allowedTCPPortRanges = cfg.allowedTCPPortRanges;

      # Logging settings
      logRefusedConnections = cfg.logRefusedConnections;
      logRefusedPackets = cfg.logRefusedPackets;

      # Enable connection tracking and rate limiting
      checkReversePath = "strict";
    };

    # Install required packages
    environment.systemPackages = with pkgs; [
      iptables
      nftables
      nettools
      nmap
    ];

    # Enable connection tracking and security settings
    boot.kernel.sysctl = {
      "net.netfilter.nf_conntrack_max" = 262144;
      # Security-specific settings (avoiding duplicates with networking module)
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.default.accept_source_route" = 0;
    };
  };
}
