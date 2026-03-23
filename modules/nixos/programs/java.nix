{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.java;
in {
  options.modules.programs.java = {
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
