{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.apps.appimage;
in {
  options.modules.apps.appimage = {
    enable = mkEnableOption "AppImage support";
    binfmt = mkEnableOption "AppImage binfmt support";
  };

  config = mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      binfmt = cfg.binfmt;
    };
  };
}
