{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.system.security.clamav;
in {
  options.modules.system.security.clamav = {
    enable = mkEnableOption "ClamAV antivirus scanner with daily scans";

    scanDirectories = mkOption {
      type = types.listOf types.str;
      default = [
        "/home"
        "/tmp"
        "/var/tmp"
      ];
      description = "Directories to scan during the daily scan";
    };

    extraScanArgs = mkOption {
      type = types.str;
      default = "--multiscan --fdpass --infected --allmatch";
      description = "Additional arguments for clamdscan";
    };
  };

  config = mkIf cfg.enable {
    services.clamav = {
      # ClamAV daemon — required for the scanner to operate
      daemon.enable = true;

      # fangfrisch: third-party signature database updater
      fangfrisch = {
        enable = true;
        interval = "daily";
      };

      # freshclam: official virus definition updater
      updater = {
        enable = true;
        # How often freshclam is invoked (see man systemd.time)
        interval = "daily";
        # Number of database checks per day
        frequency = 12;
      };

      # Scanner runs daily at 11:00 PM
      scanner = {
        enable = true;
        interval = "*-*-* 23:00:00";
        scanDirectories = cfg.scanDirectories;
      };
    };

    # clamav client tools are provided by services.clamav.daemon.enable
  };
}
