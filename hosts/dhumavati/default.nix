{
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
        # Headless Pi — Ethernet + WiFi both available, use NetworkManager.
        wifi = {
          randomMac = false;
          powersave = false;
        };
      };
      apps = {
        nix-ld.enable = true;
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
        tpm.enable = false;

        firewall = {
          enable = true;
          allowSSH = true;
          allowHTTP = false;
          allowHTTPS = false;
          allowDevelopment = false;
          customTcpPorts = [3000]; # AdGuard Home web UI
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
    users.tlh.enable = true;

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
    base16Scheme = "/etc/nixos/external/base16_monokai_pro/base16-sanatana-linux.yml";
  };

  # Pi 3 boots via U-Boot + extlinux, not GRUB.
  boot.loader.grub.enable = lib.mkForce false;

  # AdGuard Home — network-wide adblocking DNS server.
  services.adguardhome = {
    enable = true;
    settings.http.address = "0.0.0.0:3000";
    settings.dns.bootstrap_dns = [
      "9.9.9.9:53"
      "149.112.112.112:53"
    ];
    settings.filters_enabled = true;
    settings.protection_enabled = true;
    mutableSettings = true;
  };

  system.stateVersion = "24.11";
  nixpkgs.config = { allowUnsupportedSystem = true; allowUnfree = true; };
}
