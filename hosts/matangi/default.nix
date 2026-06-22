{
  lib,
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../../modules/nixos/users/smg.nix
  ];

  # Overlays
  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.stable-packages
    inputs.nur.overlays.default
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  modules = {
    # System
    system = {
      systemd.enable = true;
      boot = {
        enable = true;
        theme.enable = true;
        advancedBios.enable = true;
        efiMountPoint = "/boot";
      };
      networking = {
        enable = true;
        hostName = "matangi";
        quad9.enable = true;
      };
      apps = {
        nix-ld.enable = true;
        appimage.enable = true;
        shotcut.enable = true;
        ai = {
          ollama.enable = true;
          core.enable = true;
        };
      };
      desktop = {
        xfce.enable = true;
      };
      performance = {
        default.enable = true;
        undervolt.enable = true;
        cachy.enable = true;
        oomd.enable = true;
        zram.enable = true;
      };
      security = {
        doas.enable = true;
        fail2ban.enable = true;
        ssh.enable = true;
        sudo.enable = true;
        pam.enable = true;
        tpm.enable = true;
      };
      multimedia.enable = true;
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
        gui = {
          enable = true;
          applicationLauncher = true;
          mediaTools = true;
          developmentTools = false;
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
          webDevelopment = false;
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
    users.smg.enable = true;
    base.shell = {
      enable = true;
      zsh = true;
      variables.enable = true;
    };

    base.packages.security.enable = true;

    # Hardware
    hardware = {
      nvidia = {
        enable = true;
        cuda.enable = true;
        prime = {
          intelBusId = "PCI:00:02:0";
          nvidiaBusId = "PCI:01:00:0";
        };
        gpuTempLimit = 80;
      };
      intel.enable = true;
      bluetooth.enable = true;
      udev.enable = true;
      lenovo = {
        enable = true;
        keyboardBacklight = {
          color = "FFFFFF";
          brightness = "High";
          effect = "static";
        };
        power = {
          enable = true;
          powerProfilesDaemon = true;
        };
      };
      devices = {
        logitech.enable = true;
        iphone.enable = true;
        printer.brother = {
          enable = true;
          user = "smg";
        };
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
