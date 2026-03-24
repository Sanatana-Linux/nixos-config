{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.mango;
in {
  imports = [
    inputs.mango.nixosModules.mango
  ];
  options.modules.mango = {
    enable = lib.mkEnableOption "Enable the mangowc feature";
  };

  config = lib.mkIf cfg.enable {
    programs.mango.enable = true;
    xdg.portal.wlr.enable = true;
  };
}
