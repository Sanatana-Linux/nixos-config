{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.services.poweralertd;
in {
  options.modules.services.poweralertd = {
    enable = mkEnableOption "poweralertd power management alerts";
  };

  config = mkIf cfg.enable {
    services.poweralertd.enable = true;
  };
}
