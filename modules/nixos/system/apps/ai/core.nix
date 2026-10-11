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
      codegrab # use as `grab`
      # Image upscaling
      upscaler
      upscayl
      # Python AI packages
      python312Packages.ollama
    ];
  };
}
