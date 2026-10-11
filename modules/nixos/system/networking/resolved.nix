{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.networking.resolved;
  nmCfg = config.modules.system.networking.networkmanager;
  quad9Cfg = config.modules.system.networking.quad9;

  # systemd ships a built-in FallbackDNS of Cloudflare plus Quad9's
  # *unfiltered* tier. When Quad9 is enabled, reuse its servers instead so a
  # link-DNS failure cannot silently bypass threat blocking.
  effectiveFallbackDns =
    if cfg.fallbackDns != null
    then cfg.fallbackDns
    else if quad9Cfg.enable
    then quad9Cfg.servers
    else null;
in {
  options.modules.system.networking.resolved = {
    enable = mkEnableOption "systemd-resolved DNS resolver and stub resolver";

    dnssec = mkOption {
      type = types.enum ["false" "allow-downgrade" "true"];
      default = "allow-downgrade";
      description = "DNSSEC validation mode. 'allow-downgrade' enables DNSSEC but falls back if the upstream doesn't support it.";
    };

    dnsovertls = mkOption {
      type = types.enum ["false" "opportunistic" "true"];
      default = "opportunistic";
      description = "DNS-over-TLS mode. 'opportunistic' upgrades to DoT when the server supports it.";
    };

    fallbackDns = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = "Fallback DNS servers when no uplink provides DNS. Null reuses the Quad9 servers when that module is enabled, otherwise defers to systemd's built-in list (Cloudflare plus unfiltered Quad9).";
    };
  };

  config = mkIf cfg.enable {
    services.resolved = {
      enable = true;
      settings = {
        Resolve =
          {
            DNSSEC = cfg.dnssec;
            DNSOverTLS = cfg.dnsovertls;
          }
          // optionalAttrs (effectiveFallbackDns != null) {
            FallbackDNS = effectiveFallbackDns;
          };
      };
    };

    # Route DHCP-supplied resolvers into the stub at 127.0.0.53 so they reach
    # resolved as link DNS instead of overwriting /etc/resolv.conf directly.
    # NetworkManager performs this handoff itself when dns is set to
    # "systemd-resolved" below; this covers the dhcpcd and manual interface
    # paths, which have no equivalent mechanism.
    networking.nameservers = ["127.0.0.53"];

    # When NetworkManager is active, configure it to use resolved as DNS backend
    networking.networkmanager.dns = mkIf nmCfg.enable "systemd-resolved";
  };
}
