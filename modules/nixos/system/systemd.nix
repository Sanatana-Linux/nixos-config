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
      user.extraConfig = ''
        DefaultTimeoutStopSec=10s
        DefaultLimitNOFILE=1048576:1048576
      '';
      services = {
        systemd-tmpfiles-setup.environment.SYSTEMD_TMPFILES_FORCE_SUBVOL = "0";
        systemd-machine-id-commit.enable = false;
      };
      timers.systemd-tmpfiles-clean.enable = true;
      coredump = {
        enable = true;
        extraConfig = "Storage=none";
      };
    };
  };
}
