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
    inputs.nix-cachyos-kernel.overlays.pinned
    outputs.overlays.cachyos-patches
  ];

  # om — NixOS Operations Manager (Zig), replaces the old bash wrapper
  programs.om.enable = true;

  modules = {
    # System
    system = {
      systemd.enable = true;
      # Cron GC disabled — nix garbage collection is CPU/disk intensive
      # and contributes unnecessary chassis heat. Run manually when needed.
      cron.enable = false;
      boot = {
        enable = true;
        theme.enable = true;
        advancedBios.enable = true;
        development.enable = true;
        configurationLimit = 10;
      };
      networking = {
        enable = true;
        # networkmanager.enable = false;
        hostName = "bagalamukhi";
        quad9.enable = true;
        resolved.enable = true;
      };
      virtualization = {
        docker = {
          enable = true;
          rootless = true;
          nvidia = true;
        };
        virt-manager = {
          enable = true;
          libguestfsIntrospection = true;
        };
        quickemu.enable = true;
        waydroid = {
          enable = true;
          users = ["tlh"];
        };
        lxc.enable = true;
      };
      apps = {
        nix-ld.enable = true;
        appimage = {
          enable = true;
          binfmt = true;
        };
        searxng.enable = true;
        thunar.enable = true;
        browsers = {
          googleChrome = true;
        };
        ai = {
          ollama.enable = true;
          core.enable = true;
        };
      };
      desktop = {
        awesomewm.enable = true;
        lightdm.enable = true;
      };
      performance = {
        default.enable = true;
        undervolt.enable = true;
        cachy.enable = true;
        oomd.enable = true;
        zram.enable = true;
      };
      multimedia.enable = true;
      sleep = {
        enable = true;
        lidCloseAction = "suspend";
        lidCloseActionExternalPower = "lock";
        powerKeyAction = "suspend";
        powerKeyLongPressAction = "poweroff";
        idleAction = "suspend";
        idleTimeout = "20min";
        criticalBatteryAction = "Hibernate";
      };
      security = {
        doas = {
          enable = true;
          adminUser = "tlh";
        };
        sudo.enable = true;
        tpm.enable = true;

        # Firewall configuration
        firewall = {
          enable = true;
          allowSSH = true;
          allowHTTP = true; # Port 80
          allowHTTPS = true; # Port 443
          allowDevelopment = true; # Ports 3000, 5173, 8000, 8080 (SearXNG/dev), 8443
          logRefusedConnections = true;
          trustedInterfaces = ["lo"]; # localhost (127.0.0.1)
        };

        # SSH configuration with password authentication enabled
        ssh = {
          enable = true;
          passwordAuthentication = true; # Allow password login as requested
          permitRootLogin = "no"; # Keep root login disabled for security
          maxAuthTries = 3;
          port = 2222;
        };

        # Fail2ban for intrusion prevention
        fail2ban = {
          enable = true;
          maxRetry = 5;
          banTime = "1h";
          findTime = "10m";
          enableSSH = true;
          ignoreIPs = ["127.0.0.1/8" "::1" "192.168.1.0/24"]; # Whitelist localhost and local network
        };
      };
    };

    base = {
      enable = true;
      fonts.enable = true;
      nix.enable = true;
      permittedPackages.enable = true;
      services.enable = true;
      packages = {
        archives = {
          enable = true;
          basicFormats = true;
          modernCompression = true;
          parallelTools = true;
          specializedFormats = true;
          integrationLibs = true;
        };
        core.enable = true;
        development = {
          enable = true;
          linters = true;
          versionControl = true;
          buildTools = true;
          runtimeLanguages = true;
          luaEcosystem = true;
          rustEcosystem = true;
          nixUtilities = true;
          systemCompilers = true;
          webDevelopment = true;
          databases = true;
          editors = true;
          treeSitterGrammars = true;
          languageServers = true;
        };
        gui = {
          enable = true;
          applicationLauncher = true;
          mediaTools = true;
          developmentTools = true;
          windowManagement = true;
          messaging = true;
          extraPackages = true;
          libs = {
            enable = true;
            coreGraphics = true;
            gobjectSupport = true;
            desktopIntegration = true;
            xfceSupport = true;
            audioTerminal = true;
            pythonBindings = true;
            fontSupport = true;
          };
        };
        python = {
          enable = true;
          development = true;
          webDevelopment = true;
          dataProcessing = true;
          systemIntegration = true;
          graphics = true;
        };
        system = {
          enable = true;
          filesystem = true;
          hardware = true;
          network = true;
          performance = true;
          desktop = true;
          multimedia = true;
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

    # Hardware
    hardware = {
      nvidia = {
        enable = true;
        cuda.enable = true;
        prime = {
          intelBusId = "PCI:00:02:0";
          nvidiaBusId = "PCI:01:00:0";
        };
      };
      intel.enable = true;
      bluetooth.enable = true;
      udev.enable = true;
      lenovo = {
        enable = true;
        keyboardBacklight = {
          colors = "255,255,255,255,255,255,255,255,255,255,255,255";
          brightness = "High";
          effect = "Static";
        };
        power = {
          enable = true;
          powerProfilesDaemon = false;
          conservationMode = true;
        };
      };
      devices = {
        logitech.enable = true;
        android.enable = true;
      };
      sound.enable = true;
      keyboard = {
        enable = true;
        copilotKeyAsRightCtrl = true;
      };
    };

    # Stylix
    stylix.enable = true;
  };

  # Host-specific display configuration
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    dpi = lib.mkForce 96;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    displayManager.defaultSession = "none+awesome";
  };

  system.stateVersion = "24.11";
}
