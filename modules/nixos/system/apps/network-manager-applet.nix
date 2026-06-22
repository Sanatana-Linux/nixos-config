{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.system.apps.network-manager-applet;
in {
  options.modules.system.apps.network-manager-applet = {
    enable = mkEnableOption "NetworkManager applet";
  };

  config = mkIf cfg.enable {
    programs.nm-applet.enable = true;
  };
}
