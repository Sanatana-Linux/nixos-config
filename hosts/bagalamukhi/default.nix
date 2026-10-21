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
    # llm-agents packages under the llm-agents namespace, built against this
    # repo's pinned nixpkgs (binaries substitute from cache.numtide.com).
    inputs.llm-agents.overlays.shared-nixpkgs
  ];

  # om — NixOS Operations Manager (Zig), replaces the old bash wrapper
  programs.om.enable = true;

  # USB-SATA bridges with a broken UAS implementation drop off the bus in a
  # reset loop (link resets, DID_ERROR, then the device disappears and never
  # shows in lsblk). The 'u' quirk flag makes the kernel skip UAS for this
  # bridge and fall back to the bulk-only usb-storage driver, which is stable.
  # VID:PID here = the ULT-Best enclosure currently in use.
  boot.extraModprobeConfig = "options usb-storage quirks=7825:a2a4:u";

  # The internal ITE Device(8295) controller (048d:c995) is the keyboard RGB
  # controller. legion-rgb-control needs its HID interfaces to set the
  # backlight, so the device must stay authorized: with `authorized=0` the
  # kernel detaches every interface and the backlight can never be set.
  # modules.hardware.lenovo.keyboardBacklight drives it at boot.

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
        wifi = {
          # Randomized station MAC, stable per network so the mesh keeps its
          # roaming state. Module default is off.
          randomMac = true;
          # Spelled out next to the MAC choice; module default is off.
          powersave = false;
        };
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
        lightdm = {
          enable = true;
          greeter = "ganapati";
        };
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
          trustedInterfaces = ["lo" "localhost" "127.0.0.1"]; # localhost (127.0.0.1)
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
      timezone = "America/Los_Angeles";
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
          fileTransfer = true;
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
        cuda = {
          enable = true;
          # Generates the CDI spec at boot (hardware.nvidia-container-toolkit) so
          # `docker run --gpus all` and CDI-referencing pods get GPU access
          containerRuntime = true;
        };
        lact.enable = true;
        # Firmware mux is flipped to dGPU-only (igpumode=0, hybrid off) so
        # PRIME sync must not engage — it would bind the Intel modesetting
        # driver to a framebuffer the mux has already taken away.
        prime.enable = false;
      };
      # Firmware mux is dGPU-only (igpumode=0): keep the CPU-side tuning,
      # drop the i915/X/VA-API plumbing that assumes the iGPU has a display.
      intel = {
        enable = true;
        gpu.enable = false;
      };
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

  # The firmware mux is dGPU-only: nixos-hardware's Legion module imports
  # common/gpu/nvidia/prime.nix, which force-enables PRIME offload — that is
  # what put a modesetting Intel screen into xorg.conf and left X with no
  # screens once the mux took the iGPU away. Kill it.
  hardware.nvidia.prime.offload.enable = lib.mkForce false;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    displayManager.defaultSession = "none+awesome";
    # mDNS so `ssh kamala.local` (and avahi-browse) resolves the AMD
    # desktop from this machine without a DNS or /etc/hosts entry.
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };
  };

  system.stateVersion = "24.11";
}
