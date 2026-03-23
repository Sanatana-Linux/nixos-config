{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.services.ssh-agent;
in {
  options.modules.services.ssh-agent = {
    enable = mkEnableOption "SSH agent service";
  };

  config = mkIf cfg.enable {
    services.ssh-agent.enable = true;
  };
}
