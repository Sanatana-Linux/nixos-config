{
  config,
  lib,
  ...
}:
with lib; {
  options.modules.desktop.newm.enable = mkEnableOption "Newm Wayland compositor";
  config = mkIf config.modules.desktop.newm.enable {};
}
