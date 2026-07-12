{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.networking.resolved;
  nmCfg = config.modules.system.networking.networkmanager;
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
      description = "Fallback DNS servers when no uplink provides DNS. Null uses systemd defaults (Cloudflare + Quad9).";
    };
  };

  config = mkIf cfg.enable {
    services.resolved = {
      enable = true;
      settings = {
        Resolve = {
          DNSSEC = cfg.dnssec;
          DNSOverTLS = cfg.dnsovertls;
        } // optionalAttrs (cfg.fallbackDns != null) {
          FallbackDNS = cfg.fallbackDns;
        };
      };
    };

    # When NetworkManager is active, configure it to use resolved as DNS backend
    networking.networkmanager.dns = mkIf nmCfg.enable "systemd-resolved";
  };
}
