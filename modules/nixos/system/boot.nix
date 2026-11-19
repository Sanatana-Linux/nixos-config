{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  grubTheme = config.modules.system.boot.theme;

  # Resolution the theme assets and the GRUB framebuffer are generated for.
  # Naming them together keeps the gfxmode request and the artwork the same
  # size, so GRUB draws the menu at its native scale instead of rescaling it.
  themeResolutions = {
    "1080p" = "1920x1080";
    "2k" = "2560x1440";
    "4k" = "3840x2160";
  };

  # New Albion is a directory of assets plus generate.sh, which lays one theme
  # directory out from a (theme, style, side, color, screen) tuple. The flake
  # input's own NixOS module cannot be imported: it uses `lib` without taking
  # it as a module argument, so any evaluation of what it defines fails with
  # "undefined variable 'lib'". This derivation runs the same script against
  # the same source and produces the same layout.
  newAlbionTheme = pkgs.stdenv.mkDerivation {
    pname = "new-albion-grub-theme";
    version = "1.0.0";
    src = inputs.new-albion-grub;

    nativeBuildInputs = [pkgs.bash pkgs.coreutils];

    buildPhase = ''
      runHook preBuild
      bash ./generate.sh \
        --theme ${grubTheme.variant} \
        --type ${grubTheme.style} \
        --side ${grubTheme.side} \
        --color ${grubTheme.color} \
        --screen ${grubTheme.screen} \
        --dest .
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/grub/themes"
      mv "New-Albion-${grubTheme.variant}-${grubTheme.style}-${grubTheme.side}-${grubTheme.color}-${grubTheme.screen}" \
        "$out/share/grub/themes/new-albion"
      runHook postInstall
    '';
  };
in {
  options.modules.system.boot = {
    enable = mkEnableOption "System bootloader configuration";

    loader = mkOption {
      type = types.enum ["grub" "systemd-boot"];
      default = "grub";
      description = "Which bootloader to use";
    };

    efiMountPoint = mkOption {
      type = types.str;
      default = "/boot/efi";
      description = "Where the EFI system partition is mounted";
    };

    timeoutStyle = mkOption {
      type = types.enum ["hidden" "menu" "countdown"];
      default = "hidden";
      description = "How the GRUB menu timeout is handled";
    };

    configurationLimit = mkOption {
      type = types.int;
      default = 5;
      description = "Maximum number of generations in the boot menu";
    };

    useOSProber = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to use OS prober to discover other operating systems";
    };

    # New Albion GRUB theme. The upstream module generates one theme directory
    # from these values at build time, so the artwork, its placement, and the
    # asset resolution have to be declared per host rather than globally.
    theme = {
      enable = mkEnableOption "New Albion custom GRUB theme";

      variant = mkOption {
        type = types.enum ["yerba-buena" "fog" "580W" "golden-gate"];
        default = "yerba-buena";
        description = "Background artwork drawn behind the GRUB menu";
      };

      style = mkOption {
        type = types.enum ["window" "float" "sharp" "blur"];
        default = "window";
        description = "Frame style around the menu entries";
      };

      side = mkOption {
        type = types.enum ["left" "right"];
        default = "left";
        description = "Side of the screen the artwork occupies";
      };

      color = mkOption {
        type = types.enum ["dark"];
        default = "dark";
        description = "Colour scheme; the upstream theme set ships dark only";
      };

      screen = mkOption {
        type = types.enum ["1080p" "2k" "4k"];
        default = "1080p";
        description = ''
          Resolution preset the theme assets are generated for. Matches the
          gfxmode the module requests, so a mismatch means GRUB scales the
          menu rather than failing to draw it.
        '';
      };
    };

    advancedBios = {
      enable = mkEnableOption "UEFI firmware settings entry in the GRUB boot menu";
    };

    development = {
      enable = mkEnableOption "UEFI development packages for working with and modifying UEFI firmware";
    };
  };

  config = mkIf config.modules.system.boot.enable {
    boot = {
      tmp.cleanOnBoot = true;

      # Standard kernel from nixpkgs. Hydra builds substitutes, so updates are fast.
      kernelPackages = pkgs.linuxPackages_latest;

      blacklistedKernelModules = ["nouveau"];

      kernelModules = [
      ];

      extraModulePackages = [
      ];

      kernelParams =
        [
          "fbcon=nodefer"
          "rd.udev.log_priority=3"
          # reboot=acpi prevents hangs on reboot by using ACPI reset instead of
          # the default EFI/PCI reset mechanisms, which can hang on some hardware
          "reboot=acpi"
          # 0 DISABLES NVMe autonomous power-state transitions (APST) entirely:
          # the NVMe never sleeps, so an I/O never waits on a power-state
          # wakeup. This is the lowest-latency setting (a value like 5500
          # permits PS3-level sleep and adds microseconds-to-milliseconds of
          # wakeup latency on idle->busy transitions). Trade-off: the drive and
          # PCIe root port stay in L0, so idle power and heat rise — the reason
          # this was previously 5500.
          "nvme_core.default_ps_max_latency_us=0"
          # Hard-IRQ threading (CONFIG_IRQ_FORCED_THREADING=y) is deliberately
          # NOT enabled. It moves completion IRQs — including the xHCI one that
          # services the USB keyboard — onto schedulable threads. A keyboard's
          # HID interrupt endpoint reports current key STATE rather than events,
          # so a poll window missed across a keypress drops that keystroke
          # entirely and silently. preempt=full already supplies the low
          # scheduling latency this was meant to buy.
          # Batch RCU callbacks and flush after a delay instead of executing
          # immediately (kernel has CONFIG_RCU_LAZY=y, default off). Fewer
          # wakeups -> less idle jitter and lower power on a laptop.
          "rcutree.enable_rcu_lazy=1"
          # PCIe ASPM for the whole bus, including the PCH-attached CNVi WiFi.
          # policy=default caps links at L1.1; policy=powersave additionally
          # permits L1.2, which is a known cause of periodic CNVi disconnects —
          # the link drops on an idle timer and recovers on the next
          # association. Note pcie_aspm=force does NOT override the firmware
          # here; it defers to whatever the BIOS advertises.
          "pcie_aspm=on"
          "pcie_aspm.policy=default"
        ]
        # Intel-only: prefer the acpi-cpufreq governor over intel_pstate. On
        # Intel 14th-gen mobile (i9-14900HX) the passive governor sometimes
        # reaches better idle power states than intel_pstate active mode.
        # Gated on the Intel module so it is not emitted on AMD/other hosts,
        # where intel_pstate does not exist.
        ++ optionals config.modules.hardware.intel.enable [
          "intel_pstate=passive"
        ]
        # Silencing the console only makes sense when there is a splash drawn over
        # it. A host with plymouth off — dhumavati, a headless DNS appliance —
        # wants the boot log, which on a board with no display and only a UART is
        # the one place a failed mount or a wedged unit can be read.
        ++ optionals config.boot.plymouth.enable [
          "splash"
          "quiet"
        ];

      plymouth.enable = true;

      initrd = {
        compressor = "zstd";
        compressorArgs = ["-19"];
        kernelModules = [
        ];
      };
    };

    hardware = {
      enableAllHardware = true;
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };

    environment.systemPackages = with pkgs;
      [
        nvme-cli
        grub2
        mesa
        mesa-demos
        linuxHeaders
        luajitPackages.ldbus
        xssproxy
      ]
      # Only hosts that actually draw a splash need the theme engine or the KDE
      # control module for it; on a headless board they are dead weight in the
      # closure.
      ++ optionals config.boot.plymouth.enable [
        plymouth
        kdePackages.plymouth-kcm
      ]
      ++ optionals config.modules.system.boot.development.enable [
        efibootmgr
        efivar
        efitools
        uefi-run
        uefi-firmware-parser
        fiano
        efibooteditor
        edk2-uefi-shell
      ];

    boot.loader = {
      timeout = mkIf (config.modules.system.boot.timeoutStyle == "hidden") null;

      efi = {
        canTouchEfiVariables = true;

        # The ESP location is per-host: bagalamukhi mounts it at /boot/efi,
        # matangi mounts the ESP directly at /boot with no separate /boot
        # partition. Hardcoding /boot/efi here makes grub-install write its core
        # image to a directory on matangi's ESP instead of the ESP root, so the
        # firmware keeps booting a stale core against freshly regenerated
        # modules and fails with "symbol 'grub_memcpy' not found".
        efiSysMountPoint = config.modules.system.boot.efiMountPoint;
      };

      systemd-boot.enable = config.modules.system.boot.loader == "systemd-boot";

      grub = mkIf (config.modules.system.boot.loader == "grub") (mkMerge [
        {
          enable = true;
          device = "nodev";
          efiSupport = true;
          timeoutStyle = config.modules.system.boot.timeoutStyle;
          configurationLimit = config.modules.system.boot.configurationLimit;
          useOSProber = false;

          extraEntries = optionalString config.modules.system.boot.advancedBios.enable ''
            menuentry 'UEFI Firmware Settings' --class efi --class uefi  {
              fwsetup
            }
          '';
        }

        # Theme settings only exist when the theme is enabled, so the
        # derivation is not instantiated on hosts that never draw it —
        # dhumavati boots from extlinux on a Pi and must not pull theme
        # assets into its closure.
        (mkIf grubTheme.enable {
          theme = "${newAlbionTheme}/share/grub/themes/new-albion";
          gfxmodeEfi = themeResolutions.${grubTheme.screen};
          gfxmodeBios = themeResolutions.${grubTheme.screen};
          splashImage = "${newAlbionTheme}/share/grub/themes/new-albion/background.jpg";
        })
      ]);
    };
  };
}
