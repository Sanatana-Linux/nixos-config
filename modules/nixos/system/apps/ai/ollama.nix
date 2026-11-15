{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.apps.ai.ollama;
in {
  options.modules.system.apps.ai.ollama = {
    enable = mkEnableOption "Ollama AI service with CUDA support";

    package = mkOption {
      type = types.package;
      default = pkgs.ollama-cuda;
      description = "The Ollama package to use";
    };

    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "The host Ollama listens on";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to open the Ollama API port in the firewall";
    };
  };

  config = mkIf cfg.enable {
    environment.variables = {
      OLLAMA_API_BASE = "http://127.0.0.1:11434";
      OPENAI_API_BASE = "http://localhost:11434";
    };

    environment.systemPackages = [cfg.package];

    services.ollama = {
      enable = true;
      package = cfg.package;
      user = "ollama";
      group = "ollama";
      host = cfg.host;
    };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [11434];
  };
}
