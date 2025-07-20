{
  config,
  lib,
  pkgs,
  ...
}: {
  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec=10s
      DefaultLimitNOFILE=1048576:1048576
    '';
    user.extraConfig = "DefaultTimeoutStopSec=10s";
    services = {
      # do not create /var/lib/machines and /var/lib/portables as subvolumes
      #systemd-tmpfiles-setup.environment.SYSTEMD_TMPFILES_FORCE_SUBVOL = "0";
      # useless
      systemd-machine-id-commit.enable = false;
    };
    # clean /tmp
    timers.systemd-tmpfiles-clean.enable = true;
    coredump = {
      enable = true;
      extraConfig = "Storage=none";
    };
  };
}
