{
  config,
  lib,
  ...
}:
with lib; {
  options.modules.system.systemd = {
    enable = mkEnableOption "systemd hardening and tuning";
  };

  config = mkIf config.modules.system.systemd.enable {
    systemd = {
      user.settings.Manager = {
        DefaultTimeoutStopSec = "10s";
        DefaultLimitNOFILE = "1048576:1048576";
      };
      services = {
        systemd-tmpfiles-setup.environment.SYSTEMD_TMPFILES_FORCE_SUBVOL = "0";
        systemd-machine-id-commit.enable = false;

        # systemd-logind holds a connection to the system bus. A bus *restart*
        # (not the SIGHUP reload a switch normally does) severs that connection
        # while logind keeps running, so it owns no name on the bus any more:
        # loginctl hangs, and switch-to-configuration's user-unit reload blocks
        # for 25s and then exits 4, reporting every switch as failed even though
        # the configuration activated. PartOf tears logind down with the bus so it
        # cannot outlive its connection; dbus-org.freedesktop.login1.service
        # activates it again with a fresh one.
        systemd-logind.unitConfig.PartOf = ["dbus.service"];
      };
      timers.systemd-tmpfiles-clean.enable = true;
      coredump = {
        enable = true;
        settings.Coredump.Storage = "none";
      };
    };
  };
}
