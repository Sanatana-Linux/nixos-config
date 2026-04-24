{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktop.awesome;
in {
  options.modules.desktop.awesome = {
    enable = mkEnableOption "AwesomeWM user configuration with external symlink";
  };

  config = mkIf cfg.enable {
    home.activation.linkAwesomeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -L ${config.home.homeDirectory}/.config/awesome ]; then
        rm -f ${config.home.homeDirectory}/.config/awesome
      elif [ -d ${config.home.homeDirectory}/.config/awesome ]; then
        rm -rf ${config.home.homeDirectory}/.config/awesome
      fi
      mkdir -p ${config.home.homeDirectory}/.config
      $DRY_RUN_CMD ln -sfn /etc/nixos/external/awesome ${config.home.homeDirectory}/.config/awesome
    '';
  };
}
