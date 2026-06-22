{
  inputs,
  lib,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../../modules/nixos/users/tlh.nix
  ];

  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.stable-packages
    inputs.nur.overlays.default
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  modules = {
    system = {
      systemd.enable = true;
      boot = {
        enable = true;
        theme.enable = true;
        advancedBios.enable = false;
        development.enable = true;
      };
      networking = {
        enable = true;
        hostName = "bhairavi";
        wifi.rtl88x2bu.enable = false;
        quad9.enable = true;
      };
      apps = {
        nix-ld.enable = true;
        appimage.enable = true;
        thunar.enable = true;
        ai = {
          ollama.enable = false;
          core.enable = true;
        };
      };
      desktop = {
        awesomewm.enable = true;
      };
      performance = {
        default.enable = true;
        undervolt.enable = false;
        cachy.enable = true;
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
          allowHTTP = true;
          allowDevelopment = true;
          customTcpPorts = [];
          logRefusedConnections = true;
          trustedInterfaces = ["lo"];
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

    base = {
      enable = true;
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

    users.tlh.enable = true;

    base.shell = {
      enable = true;
      zsh = true;
      variables.enable = true;
    };

    virtualization = {
      docker = {
        enable = true;
        rootless = true;
        nvidia = false;
      };
      virt-manager.enable = false;
      waydroid.enable = false;
      lxc.enable = false;
    };

    hardware = {
      nvidia.enable = false;
      intel.enable = false;
      bluetooth.enable = false;
      udev.enable = true;
      sound.enable = true;
    };

    stylix.enable = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = ["modesetting"];
    dpi = lib.mkForce 96;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandlePowerKey = "ignore";
      HandlePowerKeyLongPress = "ignore";
    };
    displayManager.defaultSession = "none+awesome";
    qemuGuest.enable = true;
  };

  virtualisation = {
    diskSize = lib.mkDefault (50 * 1024);
  };

  system.stateVersion = "24.11";
}
