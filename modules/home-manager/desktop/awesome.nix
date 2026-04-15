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
    xdg.configFile."awesome" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/external/awesome";
    };
  };
}
