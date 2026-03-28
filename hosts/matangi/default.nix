{
  lib,
  inputs,
  outputs,
  pkgs,
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
      };
    };

    base = {
      enable = true;
      nix.enable = true;
      permittedPackages.enable = true;
      services.enable = true;
    };

    # User
    users.smg.enable = true;
    shell = {
      enable = true;
      zsh = true;
    };

    # Programs
    programs = {
      nix-ld.enable = true;
      appimage.enable = true;
      shotcut.enable = true;
    };

    # Environment
    environment.variables.enable = true;

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
    power.laptop.enable = true;

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
      fonts = {
        enable = true;
        nerdFonts = true;
        iconFonts = true;
        systemFonts = true;
      };
      development = {
        enable = false;
        linters = false;
        versionControl = false;
        buildTools = false;
        runtimeLanguages = false;
        luaEcosystem = false;
        rustEcosystem = false;
        nixUtilities = true;
        systemCompilers = true;
        webDevelopment = false;
        databases = false;
        editors = false;
        treeSitterGrammars = false;
      };
      # customFonts.enable = true;
      gui = {
        enable = true;
        applicationLauncher = true;
        mediaTools = true;
        developmentTools = false;
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
        stableVideoEditors = true;
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
        webDevelopment = false;
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
      openrgb = {
        enable = true;
        motherboard = "intel";
      };
      lenovo.enable = true;
      sound.enable = true;
      networking = {
        enable = true;
        hostName = "matangi";
        quad9.enable = true;
      };
      iphone.enable = true;
    };

    # Desktop
    desktop = {
      xfce.enable = true;
    };

    # Printer
    printer.brother = {
      enable = true;
      user = "smg";
    };

    # AI
    ai = {
      ollama.enable = true;
      core.enable = true;
    };

    # Security
    security = {
      doas.enable = true;
      fail2ban.enable = true;
      ssh.enable = true;
      sudo.enable = true;
      pam.enable = true;
      packages.enable = true;
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

  hardware.nvidia.forceFullCompositionPipeline = lib.mkForce false;

  environment.systemPackages = [pkgs.easyeffects];

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandlePowerKey = "ignore";
      HandlePowerKeyLongPress = "suspend";
    };
    displayManager.defaultSession = "xfce";
  };

  system.stateVersion = "24.11";
}
