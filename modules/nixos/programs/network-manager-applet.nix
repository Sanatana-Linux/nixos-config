{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.programs.network-manager-applet;
in {
  options.modules.programs.network-manager-applet = {
    enable = mkEnableOption "NetworkManager applet";
  };

  config = mkIf cfg.enable {
    programs.nm-applet.enable = true;
  };
}
