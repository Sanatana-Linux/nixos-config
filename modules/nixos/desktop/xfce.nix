{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.desktop.xfce.enable = mkEnableOption "XFCE desktop environment";
  config = mkIf config.modules.desktop.xfce.enable {
    services.xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
    };
    services.devmon.enable = true;
    services.udisks2.enable = true;
    services.acpid.enable = true;
  };
}
