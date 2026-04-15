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

    enableNginx = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Nginx jail protection";
    };

    enableApache = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Apache jail protection";
    };

    ignoreIPs = mkOption {
      type = types.listOf types.str;
      default = ["127.0.0.1/8" "::1"];
      description = "IP addresses/ranges to ignore (whitelist)";
    };

    customJails = mkOption {
      type = types.attrs;
      default = {};
      description = "Custom jail configurations";
    };
  };

  config = mkIf cfg.enable {
    # Ensure firewall is enabled when fail2ban is used
    modules.security.firewall.enable = mkDefault true;

    # Enable fail2ban service
    services.fail2ban = {
      enable = true;
      maxretry = cfg.maxRetry;
      bantime = cfg.banTime;

      # Custom configuration
      daemonSettings = {
        Definition = {
          loglevel = "INFO";
          socket = "/run/fail2ban/fail2ban.sock";
        };

        DEFAULT = {
          findtime = cfg.findTime;
          maxretry = cfg.maxRetry;
          bantime = cfg.banTime;
          # Use nftables for NixOS 26.05+
          banaction = "nftables-multiport";
          banaction_allports = "nftables-allports";
          # Ignore localhost and specified IPs
          ignoreip = concatStringsSep " " cfg.ignoreIPs;
          # Use systemd journal backend
          backend = "systemd";
        };
      };

      # Jail configurations
      jails = mkMerge [
        # SSH jail
        (mkIf cfg.enableSSH {
          sshd = {
            settings = {
              enabled = true;
              port = "ssh";
              filter = "sshd";
              backend = "systemd";
              maxretry = cfg.maxRetry;
              findtime = cfg.findTime;
              bantime = cfg.banTime;
            };
          };
        })

        # Nginx jails
        (mkIf cfg.enableNginx {
          nginx-http-auth = {
            settings = {
              enabled = true;
              port = "http,https";
              filter = "nginx-http-auth";
              logpath = "/var/log/nginx/error.log";
            };
          };

          nginx-noscript = {
            settings = {
              enabled = true;
              port = "http,https";
              filter = "nginx-noscript";
              logpath = "/var/log/nginx/access.log";
            };
          };

          nginx-badbots = {
            settings = {
              enabled = true;
              port = "http,https";
              filter = "nginx-badbots";
              logpath = "/var/log/nginx/access.log";
            };
          };

          nginx-noproxy = {
            settings = {
              enabled = true;
              port = "http,https";
              filter = "nginx-noproxy";
              logpath = "/var/log/nginx/access.log";
            };
          };
        })

        # Apache jails
        (mkIf cfg.enableApache {
          apache-auth = {
            settings = {
              enabled = true;
              port = "http,https";
              filter = "apache-auth";
              logpath = "/var/log/httpd/error_log";
            };
          };

          apache-badbots = {
            settings = {
              enabled = true;
              port = "http,https";
              filter = "apache-badbots";
              logpath = "/var/log/httpd/access_log";
            };
          };

          apache-noscript = {
            settings = {
              enabled = true;
              port = "http,https";
              filter = "apache-noscript";
              logpath = "/var/log/httpd/access_log";
            };
          };
        })

        # Custom jails
        cfg.customJails
      ];
    };

    # Ensure required directories exist
    systemd.tmpfiles.rules = [
      "d /var/log/fail2ban 0755 root root -"
      "f /var/log/fail2ban/fail2ban.log 0640 root root -"
      "d /var/log/nginx 0755 root root -"
      "f /var/log/nginx/access.log 0644 root root -"
      "f /var/log/nginx/error.log 0644 root root -"
    ];

    # Install fail2ban client tools
    environment.systemPackages = with pkgs; [
      fail2ban
    ];

    # Create fail2ban status script
    environment.etc."fail2ban/status.sh" = {
      text = ''
        #!/bin/bash
        # Fail2ban status script

        echo "=== Fail2ban Status ==="
        fail2ban-client status

        echo ""
        echo "=== Active Jails ==="
        for jail in $(fail2ban-client status | grep "Jail list" | sed 's/.*Jail list:\s*//'); do
          echo "--- $jail ---"
          fail2ban-client status "$jail"
        done

        echo ""
        echo "=== Recent Bans ==="
        tail -n 20 /var/log/fail2ban.log | grep Ban
      '';
      mode = "0755";
    };

    # Systemd service to ensure fail2ban starts after firewall
    systemd.services.fail2ban = {
      after = ["firewall.service"];
      wants = ["firewall.service"];
    };
  };
}
