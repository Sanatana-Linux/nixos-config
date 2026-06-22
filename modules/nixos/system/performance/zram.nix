{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.performance.zram;
in {
  options.modules.system.performance.zram = {
    enable = mkEnableOption "ZRAM swap compression";
  };

  config = mkIf cfg.enable {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 33;
      priority = 999;
    };
  };
}
