{
  inputs,
  lib,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.stable-packages
    inputs.nur.overlays.default
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
      plymouth.enable = true;
    };

    base = {
      enable = true;
      nix.enable = true;
      permittedPackages.enable = true;
      services.enable = true;
    };

    users.tlh.enable = true;

    shell = {
      enable = true;
      zsh = true;
      variables.enable = true;
    };

    programs = {
      nix-ld.enable = true;
      appimage.enable = true;
      thunar.enable = true;
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

    performance = {
      default.enable = true;
      undervolt.enable = false;
      cachy.enable = true;
      oomd.enable = true;
      zram.enable = true;
    };

    power.laptop = {
      enable = false;
      powerProfilesDaemon = false;
    };

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
        browsers = true;
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
      multimedia = {
        enable = true;
        videoTools = true;
        imageTools = true;
        streamingTools = true;
        gstreamerPlugins = true;
        creators = true;
      };
      network = {
        enable = true;
        gitTools = true;
        wirelessTools = false;
        downloadTools = true;
        compressionLibs = true;
      };
      python = {
        enable = true;
        development = true;
        webDevelopment = true;
        dataProcessing = true;
        systemIntegration = true;
        graphics = true;
      };
      shell = {
        enable = true;
        modernTools = true;
        systemUtils = true;
        fileManagement = true;
        downloadTools = true;
        zshPlugins = true;
        inputSupport = true;
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
      x11.enable = true;
    };

    hardware = {
      nvidia.enable = false;
      intel.enable = false;
      bluetooth.enable = false;
      tpm.enable = false;
      udev.enable = true;
      logitech.enable = false;
      lenovo.enable = false;
      sound.enable = true;
      networking = {
        enable = true;
        hostName = "bhairavi";
        wifi.rtl88x2bu.enable = false;
        quad9.enable = true;
      };
      android.enable = false;
    };

    stylix.enable = true;

    desktop = {
      awesomewm = {
        enable = true;
      };
    };

    ai = {
      ollama.enable = false;
      core.enable = true;
    };

    security = {
      doas = {
        enable = true;
        adminUser = "tlh";
      };
      sudo.enable = true;

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
        port = 22;
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