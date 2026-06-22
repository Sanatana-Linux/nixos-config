{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.system.networking = {
    enable = mkEnableOption "Network hardware support";

    hostName = mkOption {
      type = types.str;
      description = "The hostname for this machine";
    };

    wifi = {
      powersave = mkOption {
        type = types.bool;
        default = false;
        description = "Enable WiFi power saving";
      };
      randomMac = mkOption {
        type = types.bool;
        default = false;
        description = "Randomize WiFi MAC address";
      };
      regulatoryDomain = mkOption {
        type = types.str;
        default = "US";
        description = "Wireless regulatory domain (country code). Realtek USB adapters often fail to auto-detect and default to restrictive 'world' domain.";
      };
      rtl88x2bu = {
        enable = mkEnableOption "Realtek RTL88x2BU USB WiFi adapter driver (for monitor mode, aircrack, etc.)";
      };
    };

    quad9 = {
      enable = mkEnableOption "Quad9 DNS servers with ECS and threat blocking";
    };

    packages = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Network utility packages (git, wireless, download tools, compression libs)";
      };
      gitTools = mkOption {
        type = types.bool;
        default = true;
        description = "Git network tools";
      };
      wirelessTools = mkOption {
        type = types.bool;
        default = true;
        description = "Wireless network tools";
      };
      downloadTools = mkOption {
        type = types.bool;
        default = true;
        description = "Download utilities";
      };
      compressionLibs = mkOption {
        type = types.bool;
        default = true;
        description = "Network compression libraries";
      };
    };
  };

  config = mkIf config.modules.system.networking.enable {
    networking = {
      hostName = config.modules.system.networking.hostName;

      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
        # insertNameservers =
        #   if config.modules.system.networking.quad9.enable
        #   then ["9.9.9.11" "149.112.112.11" "2620:fe::11" "2620:fe::fe:11"]
        #   else ["1.1.1.1" "8.8.8.8" "8.8.4.4" "9.9.9.9"];
        unmanaged = ["docker0" "rndis0"];
        wifi = {
          powersave = config.modules.system.networking.wifi.powersave;
          # Realtek USB WiFi adapters (rtw88 in-kernel and rtl88x2bu
          # out-of-tree) cannot handle NetworkManager's default MAC
          # randomization during scans. This causes connection failures,
          # dropped associations, and the adapter entering a broken state
          # that requires physical replugging to recover.
          scanRandMacAddress = false;
          macAddress = "permanent";
        };
      };
    };

    services.resolved.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;

    # Disable openresolv's resolvconf.service — NetworkManager manages
    # /etc/resolv.conf via systemd-resolved. The resolvconf service conflicts
    # with NM's own DNS handling and fails with "Operation not permitted"
    # when trying to chgrp /etc/resolv.conf.
    systemd.services.resolvconf.enable = false;

    # Realtek USB WiFi adapters (both in-kernel rtw88 and out-of-tree
    # rtl88x2bu) often fail to auto-detect the regulatory domain from
    # the AP, defaulting to the restrictive "world" domain (00) which
    # limits available channels and transmit power. Setting this
    # explicitly fixes channel availability and connection stability.
    # Equivalent to: iw reg set US
    boot.kernelParams = ["cfg80211.ieee80211_regdom=${config.modules.system.networking.wifi.regulatoryDomain}"];

    # ── Realtek USB WiFi: NM dispatcher script ──────────────────────
    # In AwesomeWM (no GNOME Keyring/Polkit secret agent), NM cannot
    # store WiFi passwords in a user keyring. It falls back to WPS
    # button prompts ("push of wps button or a password required")
    # even when the correct password was provided. This dispatcher
    # script runs on every WiFi connection "up" event and:
    #   1. Sets psk-flags=0 → secret is system-owned, stored directly
    #      in /etc/NetworkManager/system-connections/ (no agent needed)
    #   2. Sets wps-method=1 → WPS strictly disabled (prevents the
    #      "push WPS button" fallback prompt)
    networking.networkmanager.dispatcherScripts = [
      {
        source = pkgs.writeText "nm-realtek-wifi-fix" ''
          INTERFACE="$1"
          ACTION="$2"

          if [ "$ACTION" != "up" ]; then
            exit 0
          fi

          # Only act on WiFi interfaces
          if ! iw dev "$INTERFACE" info >/dev/null 2>&1; then
            exit 0
          fi

          CONNECTION=$(nmcli -t -f GENERAL.CONNECTION device show "$INTERFACE" 2>/dev/null | cut -d: -f2)
          if [ -n "$CONNECTION" ]; then
            nmcli connection modify "$CONNECTION" \
              wifi-sec.psk-flags 0 \
              wifi-sec.wps-method 1
          fi
        '';
        type = "basic";
      }
    ];

    # ── Realtek USB WiFi: disable USB autosuspend ────────────────────
    # The kernel's USB power management cuts power to the USB port when
    # the WiFi card draws high voltage for the cryptographic handshake
    # (WPA2 4-way handshake, WPA3 SAE). The radio crashes mid-handshake
    # and sends a DEAUTH_LEAVING (Reason Code 3), causing NM to report
    # "association took too long, failing activation."
    #
    # This udev rule targets Realtek USB devices (vendor 0bda) and
    # sets power/control=on to prevent autosuspend. More targeted than
    # the global usbcore.autosuspend=-1 kernel parameter.
    services.udev.extraRules = ''
      # Realtek USB WiFi adapters: disable USB autosuspend
      SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", TEST=="power/control", ATTR{power/control}="on"
    '';

    #   config.boot.kernelPackages.rtl88x2bu
    # ];

    # boot.kernelModules = mkIf config.modules.system.networking.wifi.rtl88x2bu.enable [
    #   "88x2bu"
    # ];
    #
    # boot.kernelParams = mkIf config.modules.system.networking.wifi.rtl88x2bu.enable [
    #   "rtw_switch_usb_mode=1"
    # ];
    #
    # boot.blacklistedKernelModules = mkIf config.modules.system.networking.wifi.rtl88x2bu.enable [
    #   "rtw88_core"
    #   "rtw_usb"
    # ];

    # Network utility packages (git, wireless, download, compression)
    environment.systemPackages = with pkgs;
      optionals config.modules.system.networking.packages.enable (
        optionals config.modules.system.networking.packages.gitTools [
          git
          git-extras
          git-lfs
          gh
          libgit2
          libgit2-glib
        ]
        ++ optionals config.modules.system.networking.packages.wirelessTools [
          iw
          wirelesstools
        ]
        ++ optionals config.modules.system.networking.packages.downloadTools [
          aria2
          rclone
          transmission_4
          yt-dlp
        ]
        ++ optionals config.modules.system.networking.packages.compressionLibs [
          zlib
        ]
      );

    boot.kernel.sysctl = {
      # ── Receive buffer tuning ──────────────────────────────
      "net.core.netdev_max_backlog" = 16384; # Max packets queued at NIC before kernel drops
      "net.core.rmem_default" = 31457280; # Default socket receive buffer (bytes)
      "net.core.rmem_max" = 268435456; # Max socket receive buffer (bytes)
      "net.core.wmem_default" = 31457280; # Default socket send buffer (bytes)
      "net.core.wmem_max" = 268435456; # Max socket send buffer (bytes)
      "net.core.optmem_max" = 25165824; # Max ancillary buffer size per socket

      # ── TCP stack tuning ──────────────────────────────────
      "net.core.somaxconn" = 8192; # Max pending connections (backlog)
      "net.ipv4.tcp_max_syn_backlog" = 8192; # Max half-open SYN backlog
      "net.ipv4.tcp_max_tw_buckets" = 2000000; # Max TIME_WAIT sockets (prevents port exhaustion)
      "net.ipv4.tcp_tw_reuse" = 1; # Allow reuse of TIME_WAIT sockets for new connections
      "net.ipv4.tcp_fin_timeout" = 10; # Seconds before closing orphaned FIN_WAIT2

      # ── TCP buffer auto-tuning ─────────────────────────────
      # Format: min default max (bytes)
      "net.ipv4.tcp_rmem" = "8192 262144 536870912"; # Auto-tuned receive buffer range
      "net.ipv4.tcp_wmem" = "4096 65536 536870912"; # Auto-tuned send buffer range
      "net.ipv4.tcp_mem" = "1048576 1572864 2097152"; # TCP stack memory limits (pages)
      "net.ipv4.udp_mem" = "1048576 1572864 2097152"; # UDP stack memory limits (pages)
      "net.ipv4.tcp_adv_win_scale" = -2; # Auto-tune receive window (log2 scaling, negative=larger)
      "net.ipv4.tcp_moderate_rcvbuf" = 1; # Auto-tune receive buffer based on actual throughput

      # ── TCP features ───────────────────────────────────────
      "net.ipv4.tcp_mtu_probing" = 1; # Discover path MTU (1=try once, avoids PMTU black holes)
      "net.ipv4.tcp_fastopen" = 3; # TCP Fast Open (client+server, reduces 1 RTT)
      "net.ipv4.tcp_slow_start_after_idle" = 0; # Resume at full speed after idle (don't reset cwnd)
      "net.ipv4.tcp_notsent_lowat" = 131072; # Push unsent data when 128KB buffered (lower latency)
      "net.ipv4.tcp_syncookies" = 1; # SYN cookie flood protection
      "net.ipv4.tcp_rfc1337" = 1; # TIME_WAIT assassination protection
      "net.ipv4.tcp_timestamps" = 0; # Disable timestamps (reduces per-packet overhead)
      "net.ipv4.tcp_sack" = 1; # Selective ACK (efficient loss recovery)
      "net.ipv4.tcp_fack" = 1; # Forward ACK (improved SACK-based recovery)
      "net.ipv4.tcp_window_scaling" = 1; # RFC 1323 window scaling (>64KB windows)
      "net.ipv4.tcp_no_metrics_save" = 1; # Don't cache per-route TCP metrics (avoids stale tuning)

      # ── TCP keepalive ──────────────────────────────────────
      "net.ipv4.tcp_keepalive_time" = 60; # Idle seconds before first keepalive probe
      "net.ipv4.tcp_keepalive_intvl" = 10; # Seconds between keepalive probes
      "net.ipv4.tcp_keepalive_probes" = 6; # Probes before declaring connection dead

      # ── Low-latency polling ────────────────────────────────
      "net.core.busy_poll" = 50; # Busy-poll for low-latency sockets (µs)
      "net.core.busy_read" = 50; # Busy-read timeout (µs)
      "net.core.netdev_budget" = 600; # Packets per NAPI poll cycle (higher = better throughput)

      # ── Congestion control (BBR + fair queuing) ────────────
      "net.core.default_qdisc" = "fq"; # Fair Queuing qdisc (pacing for BBR)
      "net.ipv4.tcp_congestion_control" = "bbr"; # BBR congestion control (throughput-based)
    };
  };
}
