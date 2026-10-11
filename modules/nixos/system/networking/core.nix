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
        description = ''
          Enable WiFi power saving. Leave false: NetworkManager re-applies this on
          every association, and it overrides the driver's own power_save=0 set
          below in extraModprobeConfig. With it on, the adapter sleeps between
          beacons, which stalls throughput and lengthens the gap on every roam
          between access points.
        '';
      };
      randomMac = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Randomize the WiFi MAC address. Leave false on a machine that roams
          between known access points: a changing station address makes each
          association look like a new client, which defeats the fast-roaming
          state kept by the previous one.
        '';
      };
      regulatoryDomain = mkOption {
        type = types.str;
        default = "US";
        description = "Wireless regulatory domain (country code). Pinned on the kernel command line so the radio does not fall back to the restrictive 'world' domain when an access point advertises none.";
      };
    };

    networkmanager = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable NetworkManager. Set to false to use manual wpa_supplicant + dhclient instead.";
      };
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
    };

    # ── NetworkManager ─────────────────────────────────────────────────
    # Uses wpa_supplicant (default) for WiFi backend — iwd backend
    # did not discover WiFi modules on this hardware.
    networking.networkmanager = mkIf config.modules.system.networking.networkmanager.enable {
      enable = true;
      unmanaged = ["docker0" "rndis0"];
      wifi = {
        powersave = config.modules.system.networking.wifi.powersave;
        scanRandMacAddress = config.modules.system.networking.wifi.randomMac;
        macAddress =
          if config.modules.system.networking.wifi.randomMac
          then "random"
          else "preserve";
      };
    };

    warnings = [
      (
        lib.optionalString config.modules.system.networking.wifi.powersave
        "networking.wifi.powersave is enabled: NetworkManager will re-enable adapter power saving on every association, overriding the iwlwifi power_save=0 in extraModprobeConfig. Expect stalled throughput and longer outages on each roam."
      )
    ];

    systemd.services.NetworkManager-wait-online.enable = mkIf config.modules.system.networking.networkmanager.enable false;

    # openresolv's resolvconf service is not used — DNS is handled by
    # NetworkManager directly or by systemd-resolved (resolved module),
    # which owns the /etc/resolv.conf symlink.
    systemd.services.resolvconf.enable = false;

    # Pin the regulatory domain from the kernel command line. Without it a radio
    # that cannot read the domain from the AP association falls back to "world"
    # (00), which restricts channels and transmit power. Equivalent to:
    # iw reg set US
    boot.kernelParams = ["cfg80211.ieee80211_regdom=${config.modules.system.networking.wifi.regulatoryDomain}"];

    # Adapter power management for the internal CNVi radio (iwlwifi/iwlmvm).
    # power_save=0 keeps the radio out of PS mode; iwlmvm power_scheme=2 selects
    # the power-scheme table tuned for continuous association. Both must agree
    # with networking.wifi.powersave above, which takes precedence over them.
    boot.extraModprobeConfig = ''
      options iwlwifi power_save=0
      options iwlmvm power_scheme=2
    '';

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
          # NetworkManager's supplicant backend
          wpa_supplicant
          iw
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
