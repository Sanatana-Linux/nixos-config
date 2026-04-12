{
  inputs,
  lib,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Overlays
  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.stable-packages
    inputs.nur.overlays.default
  ];

  modules = {
    # System
    system = {
      systemd.enable = true;
      boot = {
        enable = true;
        theme.enable = true;
        advancedBios.enable = true;
        development.enable = true;
      };
      plymouth.enable = true; # Enable Sanatana Plymouth theme
    };

    base = {
      enable = true;
      nix.enable = true;
      permittedPackages.enable = true;
      services.enable = true;
    };

    # User
    users.tlh.enable = true;
    shell = {
      enable = true;
      zsh = true;
    };

    # Programs
    programs = {
      nix-ld.enable = true;
      appimage.enable = true;
      thunar.enable = true;
    };

    # Environment
    environment.variables.enable = true;

    # Virtualization
    virtualization = {
      docker = {
        enable = true;
        rootless = true;
        nvidia = true;
      };
      virt-manager.enable = true;
      waydroid.enable = true;
      lxc.enable = true;
    };

    # Performance
    performance = {
      default.enable = true;
      undervolt.enable = true;
      cachy.enable = true;
      oomd.enable = true;
      zram.enable = true;
    };

    # Services
    # Power
    power.laptop = {
      enable = true;
      powerProfilesDaemon = true;
    };

    # Packages
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
      # customFonts.enable = true;
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
        wirelessTools = true;
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
      tpm.enable = true;
      udev.enable = true;
      logitech.enable = true;
      lenovo.enable = true;
      sound.enable = true;
      networking = {
        enable = true;
        hostName = "bagalamukhi";
        wifi.rtl88x2bu.enable = true;
        quad9.enable = true;
      };
      android.enable = true;
    };

    # Stylix
    stylix.enable = true;

    # Desktop
    desktop = {
      awesomewm = {
        enable = true;
        displayManager = "lightdm";
      };
    };

    # AI
    ai = {
      ollama.enable = true;
      core.enable = true;
    };

    # Security
    security = {
      doas = {
        enable = true;
        adminUser = "tlh";
      };
      sudo.enable = true;
    };
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
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandlePowerKey = "ignore";
      HandlePowerKeyLongPress = "suspend";
    };
    displayManager.defaultSession = "none+awesome";
  };

  system.stateVersion = "24.11";
}
