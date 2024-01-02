{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.librespeedtest;
in {
  options.tlh.librespeedtest = {
    enable = mkEnableOption "activate librespeedtest";
    port = mkOption {
      type = types.str;
      default = "8080";
    };
    title = mkOption {
      type = types.str;
      default = "LibreSpeed";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.librespeedtest = {
      autoStart = true;
      image = "adolfintel/speedtest";
      environment = {
        TITLE = "${cfg.title}";
        ENABLE_ID_OBFUSCATION = "true";
        WEBPORT = "${cfg.port}";
        MODE = "standalone";
      };
      ports = ["${cfg.port}:${cfg.port}/tcp"];
    };

    systemd.services.docker-librespeedtest = {
      preStop = "${pkgs.docker}/bin/docker kill librespeedtest";
    };
    # Change with option, to int not an availible method
    networking.firewall = {allowedTCPPorts = [8800];};
  };
}
