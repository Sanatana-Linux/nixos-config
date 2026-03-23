{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.services.polkit-agent = {
    enable = mkEnableOption "Polkit authentication agent for GUI authentication dialogs";
  };

  config = mkIf config.modules.services.polkit-agent.enable {
    # Polkit authentication agent service
    # Required for GUI applications to request authentication for privileged operations
    # This includes mounting encrypted drives, running sudo commands, etc.
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "Polkit GNOME Authentication Agent";
        Documentation = ["man:polkit(8)" "man:polkitd(8)"];
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
        ConditionEnvironment = "WAYLAND_DISPLAY DISPLAY";
      };

      Service = {
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = "5sec";
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
