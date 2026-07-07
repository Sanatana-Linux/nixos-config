{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.apps.searxng;
in {
  options.modules.system.apps.searxng = {
    enable = mkEnableOption "SearXNG self-hosted search engine (Docker container)";

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "Host port to map SearXNG's internal port 8080 to";
    };

    image = mkOption {
      type = types.str;
      default = "searxng/searxng:latest";
      description = "SearXNG Docker image tag to use";
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra options to pass to the OCI container";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.modules.system.virtualization.docker.enable;
        message = "SearXNG requires Docker (modules.system.virtualization.docker.enable = true)";
      }
    ];

    # OCI container for SearXNG — starts at boot via Docker
    virtualisation.oci-containers.containers."searxng" = {
      image = cfg.image;
      ports = ["${toString cfg.port}:8080"];
      autoStart = true;
      extraOptions = cfg.extraOptions;
    };
  };
}
