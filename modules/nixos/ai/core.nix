{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.ai.core;
in {
  options.modules.ai.core = {
    enable = mkEnableOption "AI core tools and packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      aichat
      gemini-cli
      code2prompt
      codegrab # use as `grab`
      chatblade
      tgpt

      # Python AI packages
      python312Packages.ollama
    ];
  };
}
