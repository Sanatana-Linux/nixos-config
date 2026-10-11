{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.apps.ai.core;
in {
  options.modules.system.apps.ai.core = {
    enable = mkEnableOption "AI core tools and packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      aichat
      claude-code # Anthropic Claude Code CLI (binary: `claude`)
      code2prompt
      codegrab # use as `grab`
      chatblade

      # Image upscaling
      upscaler
      upscayl

      # Python AI packages
      python312Packages.ollama
    ];
  };
}
