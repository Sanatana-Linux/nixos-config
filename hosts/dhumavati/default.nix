{
  config,
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../../modules/nixos/system/users/tlh.nix
  ];

  # Overlays
  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.stable-packages
    inputs.nur.overlays.default
    inputs.llm-agents.overlays.shared-nixpkgs
  ];

  # om — NixOS Operations Manager (Zig)
  programs.om.enable = true;

  # SSH keys from bagalamukhi (this build device) so the Pi is reachable
  # immediately on first boot, before sops provisioning can run.
  users.users.tlh.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMURzKV2nYHMRn7/EDth3ghVUFSo259R++qezrDxqYVr tlh@bagalamukhi"
    "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAHp9kjAO8N2QAsKAXotUpLdOw09kJkoIfsbj/jnImg8UdJL8fDOd+wQuH3PwDhfohTNcDH90JUe5Xn9fa69DUG7zwBFcPkT6jE765bCpoXU//lenupzBiLvvA0C0TNyxKIC9Q+4zeu8Fr/2E9k8ef4iKbcXBUf3U7AkZwoIRID/BkZEgw== tlh@bagalamukhi"
  ];

  modules = {
    # System
    system = {
      systemd.enable = true;
      # Cron GC disabled — SD cards hate constant write churn.
      cron.enable = false;
      boot = {
        enable = true;
        theme.enable = false;
        advancedBios.enable = false;
        development.enable = false;
        configurationLimit = 3;
        # Raspberry Pi boot: firmware → U-Boot → extlinux.conf → NixOS.
        # The nixos-hardware raspberry-pi-3 profile sets:
        #   boot.loader.grub.enable = false
        #   boot.loader.generic-extlinux-compatible.enable = true
      };
      networking = {
        enable = true;
        hostName = "dhumavati";
        # The LAN's resolver: AdGuard Home filters DNS for every client.
        adguard = {
          enable = true;
          # The router advertises this box as the LAN's first resolver, so this
          # box's own DHCP lease names itself — AdGuard must never inherit that
          # or it forwards to itself. Point it at the gateway instead: the router
          # owns the public fallback tier (Quad9, Cloudflare) from there.
          upstreamDns = ["192.168.1.1"];
        };
        # Headless Pi — Ethernet + WiFi both available, use NetworkManager.
        wifi = {
          randomMac = false;
          powersave = false;
        };
      };
      apps = {
        # Headless Pi: nix-ld pulls in heavyweight GUI libraries (PyQt6,
        # GStreamer, GTK, Intel/NVIDIA) that compile for hours on aarch64 and
        # are never used by a DNS server. Disabled to keep the image lean.
        nix-ld.enable = false;
        appimage.enable = false;
        ai = {
          ollama.enable = false;
          core.enable = false;
        };
      };
      performance = {
        default.enable = true;
        undervolt.enable = false;
        cachy.enable = false;
        oomd.enable = true;
        zram.enable = true;
      };
      security = {
        doas = {
          enable = true;
          adminUser = "tlh";
        };
        sudo.enable = true;
        polkit.enable = true;
        tpm.enable = false;

        firewall = {
          enable = true;
          allowSSH = true;
          allowHTTP = false;
          allowHTTPS = false;
          allowDevelopment = false;
          # 53 is AdGuard's resolver, not just its UI: LAN clients point their
          # DNS here, so both TCP and UDP have to be open. `openFirewall` on
          # the AdGuard module only covers the web port.
          customTcpPorts = [53 3000];
          customUdpPorts = [53];
          logRefusedConnections = true;
          trustedInterfaces = ["lo" "localhost" "127.0.0.1"];
        };

        ssh = {
          enable = true;
          passwordAuthentication = true;
          permitRootLogin = "no";
          maxAuthTries = 3;
          port = 2222;
        };

        fail2ban = {
          enable = true;
          maxRetry = 5;
          banTime = "1h";
          findTime = "10m";
          enableSSH = true;
          ignoreIPs = ["127.0.0.1/8" "::1" "192.168.1.0/24"];
        };
      };
    };

    # User
    users.tlh = {
      enable = true;
      # Temporary first-boot password for SSH/console access; change with
      # `passwd` after logging in. mutableUsers = true lets that stick.
      initialPassword = "password";
    };

    base.shell = {
      enable = true;
      zsh = true;
      variables.enable = true;
    };

    # Stylix disabled — headless, no GUI theming needed.
    stylix.enable = false;
  };

  # Raspberry Pi — headless Pi, no GPU/desktop/bluetooth/lenovo/intel/nvidia.
  hardware = {
    bluetooth.enable = true;
    raspberry-pi = {
      # Raspberry Pi firmware partition (mounted at /boot/firmware).
      firmware = {
        enable = true;
        uboot.enable = true;
      };
      # config.txt rendered declaratively.
      configtxt = {
        settings = {
          all = {
            dtparam = ["audio=on"];
            enable_uart = true;
            # Disable Bluetooth to free the UART and reduce power.
            disable_bt = true;
          };
        };
        deviceTreeOverlays = {
          all = [{disable-bt = {};}];
        };
      };
    };
  };

  # ── AdGuard Home — network-wide adblocking DNS server ───────────────────
  # mDNS so `ssh dhumavati.local` works from bagalamukhi/kamala on the LAN.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    settings.publish = {
      "disable-publishing" = false;
      "publish-addresses" = true;
    };
  };

  # Stylix declared at NixOS level so the local modules/nixos/stylix module
  # can reference config.stylix without error. Enabled here so stylix's
  # home-manager integration module is loaded and declares stylix options
  # at user level; then disabled via tlh-dhumavati override so no theming runs.
  stylix = {
    enable = true;
    base16Scheme = ../../external/base16_monokai_pro/base16-sanatana-linux.yml;
  };

  # The Pi 3's onboard Ethernet is a LAN9514 hung off the dwc2 USB controller.
  # The vendor device tree carries no `dr_mode`, so mainline dwc2 comes up in
  # OTG mode and the chip never enumerates — no interface, no DHCP, no SSH.
  # The stock dwc2 overlay pins the controller to host mode, which also has to
  # be set here (not only in the SD image) because the firmware installer
  # rewrites config.txt on every activation.
  hardware.raspberry-pi.configtxt.deviceTreeOverlays.pi3 = [
    {dwc2.dr_mode = "host";}
  ];

  # Pi 3 boots via U-Boot + extlinux, not GRUB.
  boot.loader.grub.enable = lib.mkForce false;

  # No display to splash on. Plymouth would only hide the kernel log, which over
  # the UART is the one place this box can report a failed mount, and it drags a
  # theme engine plus a KDE control module into the closure for nothing.
  boot.plymouth.enable = lib.mkForce false;

  # A bootable menu, not a dead end. With no menu a generation that cannot boot
  # is unreachable and the only way back is pulling the card. U-Boot reads
  # TIMEOUT 0 as "wait forever" (the fleet default renders exactly that, which is
  # what this used to force), so keep a short non-zero wait and reach the menu
  # over the serial console configured below.
  boot.loader.timeout = lib.mkForce 5;

  # Console on HDMI and on the UART. The Raspberry Pi modules already put
  # console=tty0, console=ttyS0 and console=ttyAMA0 on the kernel command line,
  # so this only has to keep initrd's emergency shell answerable on a board with
  # no keyboard: the UART is enabled in config.txt and those console entries are
  # what make it reachable.
  boot.initrd.systemd.emergencyAccess = true;

  # AdGuard Home itself lives in modules.system.networking.adguard, which this
  # host enables above. What stays here describes this board rather than the
  # resolver: how much memory it may hold and what must not be killed under
  # pressure.

  # The shared oomd module marks *system.slice* (and the root slice) with
  # ManagedOOMMemoryPressure=kill at 80%. On a 1 GiB Pi 3 with zram those
  # thresholds are reached routinely, and oomd then SIGKILLs whole system
  # services — it took out AdGuard, NetworkManager and even getty/sshd. Keep
  # oomd watching user slices (a runaway build still gets reclaimed) but stop
  # it from killing system units.
  systemd.oomd = {
    enableRootSlice = lib.mkForce false;
    enableSystemSlice = lib.mkForce false;
  };

  # The Pi 3 has 1 GiB of RAM and runs systemd-oomd. The LAN's resolver and
  # the uplink must never be what gets sacrificed under memory pressure:
  # a negative OOMScoreAdjust makes the kernel pick something else, and
  # ManagedOOMPreference=avoid keeps systemd-oomd off these cgroups entirely.
  # MemoryMin reserves a floor so they survive even a hard squeeze.
  systemd.services.adguardhome.serviceConfig = {
    OOMScoreAdjust = -900;
    ManagedOOMPreference = "avoid";
    MemoryMin = "64M";
    # AdGuard grows with filter lists and the query log. MemoryHigh is a soft
    # ceiling: reclaim starts there, but nothing is killed — MemoryMax would
    # SIGKILL the resolver, which is the failure this box is being tuned to
    # avoid.
    MemoryHigh = "192M";
  };

  # --- Resilience: the resolver must always come back ---
  # Restart policy and the answering-nothing healthcheck both come from
  # modules.system.networking.adguard, so they cannot drift per host.

  # --- Power loss: return to service without a human ---
  # The watchdog, kernel.panic and the healthcheck timer below already cover a
  # wedged kernel and a wedged resolver. What is left is the card itself: it is
  # the only state that survives a cut, so avoid writing to it needlessly and do
  # not hold writes back — the boot menu (boot.loader.timeout above) and the
  # labels in hardware-configuration.nix are what make the next boot find its
  # root and stay selectable.

  # A fresh card boots at 97% full because the stock expand-root-partition runs
  # `partprobe` under `set -e`; against a mounted root it returns non-zero and the
  # script dies before resize2fs. partx updates the live table instead, and both
  # steps are idempotent, so the failures here cannot abort the boot either.
  systemd.services.expand-root-partition.script = lib.mkForce ''
    rootPart=$(${pkgs.util-linux}/bin/findmnt -n -o SOURCE /)
    bootDevice=$(${pkgs.util-linux}/bin/lsblk -npo PKNAME "$rootPart")
    partNum=$(${pkgs.util-linux}/bin/lsblk -npo MAJ:MIN "$rootPart" | ${pkgs.gawk}/bin/gawk -F: '{print $2}')
    echo ",+," | ${pkgs.util-linux}/bin/sfdisk -N"$partNum" --no-reread "$bootDevice" || true
    ${pkgs.util-linux}/bin/partx -u "$bootDevice" || ${pkgs.parted}/bin/partprobe "$bootDevice" || true
    ${pkgs.e2fsprogs}/bin/resize2fs "$rootPart" || true
  '';

  # AdGuard retention is an option of the adguard module (querylogInterval).

  # Bound the journal rather than letting it grow across months of uptime.
  services.journald.settings.Journal.SystemMaxUse = "64M";

  # Same for the uplink: losing NetworkManager means losing the box.
  systemd.services.NetworkManager.serviceConfig = {
    Restart = lib.mkForce "always";
    RestartSec = lib.mkForce "2s";
    MemoryHigh = lib.mkForce "96M";
  };

  # fail2ban is a Python daemon (~43 MB); it may be throttled but never killed.
  systemd.services.fail2ban.serviceConfig.MemoryHigh = "96M";

  # The BCM2835 hardware watchdog is built into the kernel, so a wedged kernel
  # or a systemd main loop that stops making progress reboots the board instead
  # of leaving it dark on the LAN. kernel.panic then guarantees a reboot even
  # for a panic that never reaches systemd.
  systemd.settings.Manager.RuntimeWatchdogSec = "60s";
  boot.kernel.sysctl."kernel.panic" = lib.mkForce 10;

  # Crash dumps are useless on a DNS appliance and cost RAM plus SD writes at
  # the worst possible moment.
  systemd.coredump.enable = lib.mkForce false;

  # Restart=always covers a resolver that dies. This covers the other half: the
  # process is alive but wedged (stalled upstream, poisoned cache, deadlock
  # after a memory squeeze) and silently answers nothing. A failed lookup on
  # loopback restarts it; the timer is what makes it self-healing without a
  # human noticing.
  systemd.services.adguardhome-healthcheck = {
    description = "Restart AdGuard Home when DNS stops answering";
    after = ["adguardhome.service"];
    wants = ["adguardhome.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "adguardhome-healthcheck" ''
        set -eu
        if ! ${pkgs.dnsutils}/bin/dig +time=2 +tries=1 +short @127.0.0.1 example.com >/dev/null 2>&1; then
          ${config.systemd.package}/bin/systemctl try-restart adguardhome.service
        fi
      '';
    };
  };
  systemd.timers.adguardhome-healthcheck = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "60s";
    };
  };

  # Fleet default is 33% of RAM for zram. A headless DNS box has no desktop
  # working set to protect, so a larger compressed swap pool gives the kernel
  # somewhere to park cold anonymous pages instead of evicting page cache or
  # touching the SD card.
  zramSwap.memoryPercent = lib.mkForce 50;

  # Builds are the one workload that can consume the whole board; throttle them
  # before they can push the resolver out of memory.
  systemd.services.nix-daemon.serviceConfig.MemoryHigh = "256M";
  systemd.services.NetworkManager.serviceConfig = {
    OOMScoreAdjust = -800;
    ManagedOOMPreference = "avoid";
    MemoryMin = "32M";
  };
  # Keeping sshd alive is what keeps the box remotely recoverable.
  systemd.services.sshd.serviceConfig = {
    OOMScoreAdjust = -600;
    ManagedOOMPreference = "avoid";
  };

  system.stateVersion = "24.11";
  # The sd-image base profile enables ZFS by default when the package is
  # "available" on the platform, but ZFS 2.4.4 does not build against kernel
  # 7.3.4 (max supported 7.2) and the Pi uses ext4 root only. Force it off.
  boot.supportedFilesystems.zfs = lib.mkForce false;
  # zfs-kernel is broken on aarch64 but dhumavati doesn't need ZFS — allow
  # evaluation so the SD card image builds. The Pi uses ext4 root only.
  nixpkgs.config = {
    allowUnsupportedSystem = true;
    allowUnfree = true;
    problems.handlers = {
      zfs.broken = "warn";
    };
  };
}
