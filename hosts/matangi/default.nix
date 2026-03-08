{
  lib,
  inputs,
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
    outputs.overlays.master-packages
    outputs.overlays.f2k-packages
    outputs.overlays.chaotic-packages
    inputs.antigravity-nix.overlays.default
  ];

  modules = {
    # System
    system = {
      boot = {
        enable = true;
        theme.enable = true;
        advancedBios.enable = true;
      };
      kernel = {
        enable = true;
        lenovo-legion.enable = true; # Shared Lenovo Legion hardware profile
        plymouth.enable = true;
      };
    };

    base = {
      enable = true;
      nix.enable = true;
      permittedPackages.enable = true;
    };

    # User
    users.smg.enable = true;
    shell = {
      enable = true;
      zsh = true;
    };

    # Programs
    programs.nix-ld.enable = true;

    # Performance
    performance = {
      default.enable = true;
      undervolt.enable = true;
    };

    # Services
    services = {
      core.enable = true;
      ssh.enable = true;
      udev.enable = true;
    };

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
      fonts = {
        enable = true;
        nerdFonts = true;
        iconFonts = true;
        systemFonts = true;
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
    };

    # Hardware
    hardware = {
      nvidia = {
        enable = true;
        cuda.enable = true;
      };
      intel.enable = true;
      bluetooth.enable = true;
      tpm.enable = true;
      openrgb = {
        enable = true;
        motherboard = "intel";
      };
      sound = {
        enable = true;
        pipewire = true;
      };
      networking = {
        enable = true;
        hostName = "matangi";
        firewall.enable = true;
      };
      iphone.enable = true;
    };

    # Desktop
    desktop = {
      xorg.enable = true;
      xfce.enable = true;
    };

    # Printer
    printer.brother = {
      enable = true;
      user = "smg";
    };

    # Security
    security = {
      doas.enable = true;
      fail2ban.enable = true;
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
    displayManager.defaultSession = "xfce";
  };

  system.stateVersion = "24.11";
}
