{
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.home;
in {
  options.modules.services.home = {
    enable = lib.mkEnableOption "home user services configuration";
  };

  config = lib.mkIf cfg.enable {
    services = {
      poweralertd.enable = true;
      ssh-agent.enable = true;
    };
  };
}
