{
  config,
  lib,
  pkgs,
  adblock-unbound,
  ...
}:
with lib; let
  cfg = config.tlh.unbound;

  adlist = adblock-unbound.packages.${pkgs.system};

  dns-overwrites-config = builtins.toFile "dns-overwrites.conf" (''
      # DNS overwrites
    ''
    + concatStringsSep "\n"
    (mapAttrsToList (n: v: "local-data: \"${n} A ${toString v}\"") cfg.A-records));
in {
  options.tlh.unbound = {
    enable = mkEnableOption "unbound";

    A-records = mkOption {
      type = types.attrs;
      default = {
        "pass.telekom.de" = "109.237.176.33";
        "fritz.box" = "192.168.178.1";
        "nas.wallau" = "192.168.178.5";
        "status.alexanderwallau.de" = "192.168.69.1";
      };
      description = ''
        Custom DNS A records
      '';
    };
  };

  config = mkIf cfg.enable {
    # DNS server is only available on localhost
    # make sure to configure your network manager to use it!
    # networking.nameservers = [ "127.0.0.1" ];
    # won't work in most setups, because it will be overwritten by the network manager

    services.unbound = {
      enable = true;
      settings = {
        server = {
          include = [
            "\"${dns-overwrites-config}\""
            "\"${adlist.unbound-adblockStevenBlack}\""
          ];
          interface = [
            "127.0.0.1"
          ];
          access-control = [
            "127.0.0.0/8 allow"
          ];
        };

        forward-zone = [
          {
            name = "google.*.";
            forward-addr = [
              "8.8.8.8@853#dns.google"
              "8.8.8.4@853#dns.google"
            ];
            forward-tls-upstream = "yes";
          }
          {
            name = ".";
            forward-addr = [
              "1.1.1.1@853#cloudflare-dns.com"
              "1.0.0.1@853#cloudflare-dns.com"
            ];
            forward-tls-upstream = "yes";
          }
        ];
      };
    };
  };
}
