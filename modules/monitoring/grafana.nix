{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.monitoring.grafana;
in {
  options.tlh.monitoring.grafana = {
    enable = mkEnableOption "Grafana dashboard";

    nginx = mkEnableOption "enable nginx for grafana";

    domain = mkOption {
      type = types.str;
      default = "status.alexanderwallau.de";
      example = "dashboards.myhost.com";
      description = "Domain for grafana";
    };
  };

  config = mkIf cfg.enable {
    # No need to support plain HTTP, forcing TLS for all vhosts. Certificates
    # provided by Let's Encrypt via ACME. Generation and renewal is automatic
    # if DNS is set up correctly for the (sub-)domains.
    services.nginx.virtualHosts = mkIf cfg.nginx {
      # Graphana
      "${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          allow 192.168.69.0/24;
          deny all;
        '';
        locations."/" = {proxyPass = "http://127.0.0.1:9005";};
      };
    };

    # Graphana fronend
    services.grafana = {
      enable = true;

      settings = {
        server = {
          http_port = 9005;
          http_addr = "127.0.0.1";
          domain = cfg.domain;
        };
        "auth.anonymous".enabled' = true;
      };

      # Provisioning dashboards and datasources declaratively by
      # setting `dashboards` or `datasources` to a list is not supported
      # anymore. Use `services.grafana.provision.datasources.settings.datasources`
      # (or `services.grafana.provision.dashboards.settings.providers`) instead.
      provision.datasources = {
        settings.datasources = [
          {
            name = "Prometheus localhost";
            url = "http://localhost:9090";
            type = "prometheus";
            isDefault = true;
          }
        ];
      };
    };
  };
}
