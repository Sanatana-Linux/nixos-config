{
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./sops.nix
    ../../modules/nixos/system/users/tlh.nix
  ];

  # Overlays
  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.stable-packages
    inputs.nur.overlays.default
    # llm-agents packages under the llm-agents namespace, built against this
    # repo's pinned nixpkgs (binaries substitute from cache.numtide.com).
    inputs.llm-agents.overlays.shared-nixpkgs
  ];

  # om — NixOS Operations Manager (Zig), replaces the old bash wrapper
  programs.om.enable = true;

  modules = {
    # System
    system = {
      systemd.enable = true;
      # Cron GC disabled — nix garbage collection is CPU/disk intensive.
      # Run manually when needed.
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
        hostName = "kamala";
        # Wired desktop. The WiFi knobs below are inert without a radio but
        # are kept for parity with the rest of the fleet; NetworkManager
        # still owns the wired interface.
        wifi = {
          randomMac = true;
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
          # Go-native Greeter Ganapati (imported via greeter-ganapati flake input).
          greeter = "ganapati";
        };
      };
      performance = {
        default.enable = true;
        # undervolt is the Intel-only intel-undervolt/throttled stack; the
        # Ryzen 9 uses amd_pstate (guided mode) instead.
        undervolt.enable = false;
        cachy.enable = true;
        oomd.enable = true;
        zram.enable = true;
      };
      multimedia.enable = true;
      sleep = {
        enable = true;
        # Desktop: no lid, and the box must stay reachable over SSH, so no
        # idle suspend. Power button behaviour mirrors the laptops.
        lidCloseAction = "ignore";
        idleAction = null;
        powerKeyAction = "suspend";
        powerKeyLongPressAction = "poweroff";
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
          trustedInterfaces = ["lo" "localhost" "127.0.0.1"];
        };

        # SSH server — same port and policy as bagalamukhi so administration
        # from the laptop is uniform across the fleet.
        ssh = {
          enable = true;
          passwordAuthentication = true;
          permitRootLogin = "no";
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
          ignoreIPs = ["127.0.0.1/8" "::1" "192.168.1.0/24"];
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
      # AMD Ryzen 9 (Zen 2) + X570 platform — CPU/chipset kernel modules,
      # sensors (k10temp, nct6775, asus_ec_sensors) and AMD-V/IOMMU.
      amd.enable = true;
      # amd_pstate=guided, not active: Zen 2 has no reliable CPPC EPP support,
      # so active mode can pin the cores at the lowest non-linear frequency.
      amd.pstateMode = "guided";
      # Full kernel preemption for the lowest scheduling latency under load.
      amd.preemptFull = true;
      # Side-channel mitigations off — maximum throughput on a physically
      # trusted, single-tenant workstation behind the firewall.
      amd.mitigations = "off";
      # power-profiles-daemon is off: on Zen 2 its EPP hints are inert and it
      # pins the governor to powersave, which fights the responsiveness goal.
      # The static governor set at the bottom of this file drives frequency
      # scaling instead.
      amd.powerProfilesDaemon = false;
      # If amd_pstate fails to load ("_CPC object is not present in SBIOS"),
      # set BIOS APIC to XAPIC (not X2APIC/Auto) or update the BIOS, or set
      # amd.x2apicWorkaround = true to append nox2apic.

      nvidia = {
        enable = true;
        # ZOTAC GeForce GTX 1080 AMP — Pascal (GP104). The 590+ driver branches
        # dropped Maxwell/Pascal/Volta, so this card must stay on the 580 legacy
        # branch (legacy_580), which is the last to support it.
        driver = "legacy_580";
        # Pascal predates GSP firmware, runtime-D3 dynamic power management and
        # PCIe Resizable BAR — none of those parameters are emitted.
        turingOrNewer = false;
        cuda = {
          enable = true;
          # GTX 1080 is Pascal (compute capability 6.1). nixpkgs' default
          # capability list starts at 7.5, so without this every cudaSupport
          # package lacks sm_61 kernels and dies with "no kernel image available
          # for this device" at runtime.
          capabilities = ["6.1"];
          # Generates the CDI spec at boot so `docker run --gpus all` and
          # CDI-referencing pods get GPU access.
          containerRuntime = true;
        };
        lact.enable = true;
        # Single discrete GPU — the GTX 1080 (Pascal) drives every output
        # directly, so there is no Intel iGPU and PRIME must stay off.
        prime.enable = false;
        # Always-on CUDA workstation: keep the driver loaded between jobs so the
        # first kernel launch is not re-paid per process.
        nvidiaPersistenced = true;
      };
      # No Intel CPU/GPU on this machine (Ryzen 9 + NVIDIA only).
      # intel.enable is intentionally omitted.
      bluetooth.enable = true;
      udev.enable = true;
      devices = {
        android.enable = true;
      };
      sound.enable = true;
    };

    # Stylix
    stylix.enable = true;
  };

  # Static CPU governor. With power-profiles-daemon disabled the amd_pstate
  # driver is driven by this governor; `performance` pins the clock for maximum
  # desktop responsiveness on this always-on workstation.
  powerManagement.cpuFreqGovernor = "performance";

  # Host-specific display configuration — the NVIDIA GPU is the only adapter.
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    dpi = lib.mkForce 96;
  };

  # Suspend support: with powerManagement enabled, the nvidia-suspend/resume
  # services save and restore VRAM (NVreg_PreserveVideoMemoryAllocations), which
  # the power-key suspend this desktop uses needs. Runtime D3 (finegrained) stays
  # off — the GTX 1080 is the sole display adapter and must not drop to a low
  # power state.
  hardware.nvidia.powerManagement.enable = true;

  # /boot is a plaintext partition, so GRUB never cryptomounts (no prompt).
  # The root and data LUKS volumes are unlocked in the systemd initrd; TPM2
  # (AMD fTPM) auto-unlock is enrolled post-install, giving zero prompts.
  boot.initrd.systemd.tpm2.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    displayManager.defaultSession = "none+awesome";
    # mDNS so `ssh kamala.local` (and avahi-browse) works from bagalamukhi
    # and the rest of the LAN without a DNS entry or static /etc/hosts line.
    avahi = {
      enable = true;
      nssmdns4 = true;
      settings.publish = {
        "disable-publishing" = false;
        "publish-addresses" = true;
      };
    };
  };

  system.stateVersion = "24.11";
}
