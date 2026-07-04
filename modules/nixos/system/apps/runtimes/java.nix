{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.apps.java;
in {
  options.modules.system.apps.java = {
    enable = mkEnableOption "Java runtime environment";
    package = mkOption {
      type = types.package;
      default = pkgs.jre;
      description = "Java package to use";
    };
  };

  config = mkIf cfg.enable {
    programs.java = {
      enable = true;
      package = cfg.package;
    };
  };
}
