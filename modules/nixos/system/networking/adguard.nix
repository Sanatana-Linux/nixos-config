{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.networking.adguard;
in {
  options.modules.system.networking.adguard = {
    enable = mkEnableOption "AdGuard Home, a network-wide DNS adblocker";

    address = mkOption {
      type = types.str;
      default = "0.0.0.0:3000";
      description = "Address the web interface listens on.";
    };

    upstreamDns = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Resolvers AdGuard forwards filtered queries to. Empty means AdGuard uses
        the system resolver — the LAN gateway — so the box that owns the public
        fallback tier stays the gateway, not this one.
      '';
    };

    fallbackDns = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Resolvers used only when none of upstreamDns answers. Empty by default:
        public resolvers are the router's business, and naming them here would
        quietly bypass its fallback ordering.
      '';
    };

    bootstrapDns = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Resolvers used to bootstrap upstreams given as bare IPs. Empty when the upstreams are plain hostnames of the gateway.";
    };

    querylogInterval = mkOption {
      type = types.str;
      default = "24h";
      description = ''
        Query log retention, as a Go duration. AdGuard exits at startup on
        anything under an hour ("init querylog: unsupported interval: less than
        an hour"), and an integer is parsed as nanoseconds — so 0 means "0s" and
        a crash loop, not "keep nothing".
      '';
    };

    healthcheck.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Restart the resolver when a loopback lookup stops answering. Covers the
        process that is alive but wedged, which Restart= cannot see.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      # The UI owns /var/lib/AdGuardHome/AdGuardHome.yaml after first boot; keep
      # it writable so rule and filter changes made in the browser survive.
      mutableSettings = true;
      settings = {
        http.address = cfg.address;
        dns = {
          upstream_dns = cfg.upstreamDns;
          fallback_dns = cfg.fallbackDns;
          bootstrap_dns = cfg.bootstrapDns;
        };
        querylog.interval = cfg.querylogInterval;
        filters_enabled = true;
        protection_enabled = true;
      };
    };

    # A resolver that dies has to come back without anyone noticing. Two seconds
    # between restarts stays inside nixpkgs' 5s window / 10-start burst, so the
    # rate limiter can never latch and leave DNS dead until a human intervenes.
    systemd.services.adguardhome.serviceConfig = {
      Restart = lib.mkForce "always";
      RestartSec = lib.mkForce "2s";
    };

    # The other half: alive but answering nothing (stalled upstream, wedged
    # cache). Only a failed lookup can tell those apart, so that is the probe.
    systemd.services.adguardhome-healthcheck = mkIf cfg.healthcheck.enable {
      description = "Restart AdGuard Home when DNS stops answering";
      after = ["adguardhome.service"];
      wants = ["adguardhome.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "adguardhome-healthcheck" ''
          set -eu
          if ! ${pkgs.dnsutils}/bin/dig +time=2 +tries=1 +short @127.0.0.1 example.com >/dev/null 2>&1; then
            ${config.systemd.package}/bin/systemctl try-restart adguardhome.service
          fi
        '';
      };
    };
    systemd.timers.adguardhome-healthcheck = mkIf cfg.healthcheck.enable {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = "60s";
      };
    };
  };
}
