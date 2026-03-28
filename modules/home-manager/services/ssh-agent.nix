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

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Unit.Description = "polkit-gnome-authentication-agent-1";
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
