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
      # Listen on the LAN so SwarmUI on kamala (192.168.1.203) can use the
      # API for MagicPrompt and other integrations.
      host = "0.0.0.0";
    };

    # Ollama API port, reachable from the LAN.
    networking.firewall.allowedTCPPorts = [11434];
  };
}
