{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.xscreensaver;
in {
  options.modules.services.xscreensaver = {
    enable = mkEnableOption "XScreenSaver screen blanking service";

    timeout = mkOption {
      type = types.str;
      default = "9";
      description = "Timeout in minutes before screen blanks";
    };

    mode = mkOption {
      type = types.str;
      default = "blank";
      description = "Screensaver mode";
    };
  };

  config = mkIf cfg.enable {
    services.xscreensaver = {
      enable = true;
      settings = {
        timeout = cfg.timeout;
        mode = cfg.mode;
      };
    };
  };
}
