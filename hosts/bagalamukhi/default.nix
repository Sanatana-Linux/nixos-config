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
  mangowc.enable = true;
    # System
    system = {
      systemd.enable = true;
      boot = {
        enable = true;
        theme.enable = true;
        advancedBios.enable = true;
        development.enable = true;
      };
    };

    base = {
      enable = true;
      nix.enable = true;
      permittedPackages.enable = true;
      services.enable = true;
    };

    stylix.enable = true;

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
      wayland.enable = true;
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
        hostName = "bagalamukhi";
        wifi.rtl88x2bu.enable = true;
        quad9.enable = true;
      };
      android.enable = true;
    };

    # Desktop
    desktop = {
      xorg.enable = false;
      awesomewm.enable = false;
      wayland.enable = true;
    };

    # AI
    ai = {
      ollama.enable = false;
      core.enable = false;
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

  # ENABLE CORE OPTIONS
  panchakosha.mangowc.enable = true;
  # panchakosha.quickshell.enable = true;
  # panchakosha.greetd.enable = true;
  #
  # # AUTO-DETECTS NVIDIA, but can be forced
  # panchakosha.nvidiaFixes = true;
  #
  # # CONFIGURE MONITORS
  # panchakosha.mangowc.monitors = [
  #   {
  #     name = "eDP-1";
  #     width = 2560;
  #     height = 1440;
  #     refreshRate = 60;
  #     position = {
  #       x = 0;
  #       y = 0;
  #     };
  #   }
  # ];
  programs.mangowc.enable = true;
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
  };

  # changed to functional zfs configuration that and bumped this up one year... oops....
  system.stateVersion = "25.11";
}
