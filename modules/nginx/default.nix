{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.nginx;
in {
  options.tlh.nginx = {
    enable = mkEnableOption "activate nginx";
    email = mkOption {
      type = types.str;
      default = "acme@alexanderwallau.de";
      description = ''
        Sent exipry notifications to this email address.
      '';
    };
  };

  config = mkIf cfg.enable {
    security.acme.acceptTerms = true;
    security.acme.defaults.email = "${cfg.email}";

    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;

      # both lines can help if errors occur
      # especially with using longer paths
      clientMaxBodySize = "128m";
      serverNamesHashBucketSize = 128;
    };

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
