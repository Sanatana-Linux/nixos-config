{
  config,
  lib,
  ...
}:
with lib; {
  options.modules.hardware.android.enable = mkEnableOption "Android development tools";
  config = mkIf config.modules.hardware.android.enable {};
}
