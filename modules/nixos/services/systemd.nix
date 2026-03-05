{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.systemd;
in {
  options.modules.services.systemd = {
    enable = mkEnableOption "Custom systemd configuration and optimizations";
  };

  config = mkIf cfg.enable {
    systemd = {
      user.extraConfig = ''
        DefaultTimeoutStopSec=10s
        DefaultLimitNOFILE=1048576:1048576
      '';

      services = {
        # Do not create /var/lib/machines and /var/lib/portables as subvolumes
        systemd-tmpfiles-setup.environment.SYSTEMD_TMPFILES_FORCE_SUBVOL = "0";
        systemd-machine-id-commit.enable = false;
      };

      # Clean /tmp
      timers.systemd-tmpfiles-clean.enable = true;

      coredump = {
        enable = true;
        extraConfig = "Storage=none";
      };
    };
  };
}
