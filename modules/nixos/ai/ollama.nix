{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.ai.ollama;
in {
  options.modules.ai.ollama = {
    enable = mkEnableOption "Ollama AI service with CUDA support";

    package = mkOption {
      type = types.package;
      default = pkgs.ollama-cuda;
      description = "The Ollama package to use";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    services.ollama = {
      enable = true;
      package = cfg.package;
      user = "ollama";
      group = "ollama";
    };
  };
}
