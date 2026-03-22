{
  inputs,
  lib,
  outputs,
  ...
}: {
  imports = [
  # TODO refactor zfs.nix into an option nested within the boot module's options and enable it 
    ./hardware-configuration-zfs.nix
    ./zfs.nix
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
      encrypted-storage.enable = true;
    };

    # Desktop
    desktop = {
      xorg.enable = false;
      awesomewm.enable = false;
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

  # Enable PanchaKosha greetd/quickshell options for MangoWC
  services.greetd.mangowc = {
    enable = true;
    quickshellGreeter.enable = true;
  };

  programs.quickshell.mangowc.enable = true;

  # Host-specific display configuration
  # services.xserver = {
  #   enable = true;
  #   videoDrivers = ["nvidia"];
  #   dpi = lib.mkForce 96;
  # };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Disable Stylix GRUB theme - using bhairava-grub-theme instead
  boot.loader.grub.theme = lib.mkForce null;

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandlePowerKey = "ignore";
      HandlePowerKeyLongPress = "suspend";
    };
  };

# changed to functional zfs configuration that boot and bumped this up one year... oops.... 
  system.stateVersion = "25.11";
}
