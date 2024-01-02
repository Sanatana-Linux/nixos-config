{
  lib,
  pkgs,
  config,
  self,
  ...
}:
with lib; let
  cfg = config.tlh.metrics.node;
in {
  options.tlh.metrics.node = {
    enable = mkEnableOption "prometheus node-exporter metrics collection";

    flake = mkEnableOption "prometheus node-exporter metrics for flake inputs";

    configure-prometheus = mkEnableOption "enable node-exporter in prometheus";

    targets = mkOption {
      type = types.listOf types.str;
      default = ["localhost:9100"];
      example = ["hostname.wireguard:9100"];
      description = "Targets to monitor with the node-exporter";
    };
  };

  config = {
    services.prometheus = {
      exporters = {
        node = mkIf cfg.enable {
          enable = true;
          openFirewall = false;
          enabledCollectors = ["systemd"];
          extraFlags =
            mkIf cfg.flake ["--collector.textfile.directory=/etc/nix"];
        };
      };

      scrapeConfigs = mkIf cfg.configure-prometheus [
        {
          job_name = "node-stats";
          scrape_interval = "15s";
          static_configs = [{targets = cfg.targets;}];
        }
      ];
    };

    environment.etc."nix/flake_inputs.prom" = mkIf cfg.flake {
      mode = "0555";
      text = ''
        # HELP flake_registry_last_modified Last modification date of flake input in unixtime
        # TYPE flake_input_last_modified gauge
        flake_input_last_modified{input="nixpkgs",_type="flake", lastModifiedDate="${toString self.inputs.nixpkgs.lastModified}", narHash="${self.inputs.nixpkgs.narHash}", outPath="${self.inputs.nixpkgs.outPath}", rev="${self.inputs.nixpkgs.rev}", shortRev="${self.inputs.nixpkgs.shortRev}"} ${toString self.inputs.nixpkgs.lastModified}
      '';
    };

    # Open firewall ports on the wireguard interface
    networking.firewall.interfaces.wg0.allowedTCPPorts = lib.optional cfg.enable 9100;
  };
}
