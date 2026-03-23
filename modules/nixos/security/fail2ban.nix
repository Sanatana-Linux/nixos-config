{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.security.fail2ban;
in {
  options.modules.security.fail2ban = {
    enable = mkEnableOption "fail2ban intrusion prevention system";

    maxRetry = mkOption {
      type = types.int;
      default = 5;
      description = "Number of failures before a host gets banned";
    };

    banTime = mkOption {
      type = types.str;
      default = "1h";
      description = "Duration for which a host gets banned (e.g., 10m, 1h, 1d)";
    };

    findTime = mkOption {
      type = types.str;
      default = "10m";
      description = "Time window for counting failures";
    };

    enableSSH = mkOption {
      type = types.bool;
      default = true;
      description = "Enable SSH jail protection";
    };
  };

  config = mkIf cfg.enable {
    # Enable fail2ban service
    services.fail2ban = {
      enable = true;
      maxretry = cfg.maxRetry;
      bantime = cfg.banTime;

      # SSH jail configuration using daemonSettings
      daemonSettings = mkIf cfg.enableSSH {
        DEFAULT = {
          findtime = cfg.findTime;
        };
      };
    };

    # Ensure required log files exist
    systemd.tmpfiles.rules = [
      "f /var/log/auth.log 0640 root root -"
    ];
  };
}
