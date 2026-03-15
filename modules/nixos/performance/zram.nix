{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.performance.zram;
in {
  options.modules.performance.zram = {
    enable = mkEnableOption "ZRAM swap compression";
  };

  config = mkIf cfg.enable {
    # Enable ZRAM swap for better performance
    zramSwap = {
      enable = true;
      algorithm = "lz4";
      memoryPercent = 33;
      priority = 999;
    };
  };
}
