{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.packages.system;
in {
  options.modules.base.packages.system = {
    enable = mkEnableOption "System utilities";
    minimal = mkEnableOption "Minimal system utilities for live/ISO";
    filesystem = mkEnableOption "Filesystem utilities";
    hardware = mkEnableOption "Hardware monitoring tools";
    network = mkEnableOption "Network system utilities";
    performance = mkEnableOption "Performance monitoring tools";
    desktop = mkEnableOption "Desktop integration utilities";
    multimedia = mkEnableOption "System multimedia tools";
    document = mkOption {
      type = types.bool;
      default = true;
      description = "Document and PDF generation tools";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # Minimal preset
    (mkIf cfg.minimal {
      modules.base.packages.system = {
        hardware = mkDefault false;
      };
    })

    {
      environment.systemPackages = with pkgs;
      # Essential system utilities (always included)
        [
          # Linux Standard utils
          util-linux # Linux utilities
          coreutils-full # Core utilities
          file # File type identification
          wget # Web downloader
          jq # JSON processor
          yq-go # YAML processor (used by secrets management)
          moreutils # More Unix utilities
          parallel # Run jobs in parallel

          # Help & Metadata
          comma # Run commands from nixpkgs
          gh # GitHub CLI
          fastfetch # System info

          # Misc
          acpi # Battery information
          automake # GNU automake
          binutils # Binary utilities
          fd # Modern find
          ripgrep-all # ripgrep with everything
          yad # Dialogs
          brotli # Compression algorithm
          zip # PKZIP archive
        ]
        # Filesystem utilities
        ++ optionals cfg.filesystem [
          # Base FUSE drivers
          fuse # FUSE filesystem
          fuse3 # FUSE v3
          avfs # Virtual filesystem
          xorriso # ISO/optical disk tool

          # Archive / Storage mounting
          fuse-archive # Archive mounting
          exfatprogs # exFAT utilities
          ntfs3g # NTFS driver
          ntfsprogs # NTFS utilities
          dosfstools # FAT filesystem

          # Linux/Mac specific
          apfs-fuse # APFS filesystem
          ext4fuse # ext4 FUSE
          fuse-ext2 # ext2/3/4 FUSE

          # Integration
          libcloudproviders # Cloud integration
          xorriso # ISO creation
        ]
        # Hardware monitoring
        ++ optionals cfg.hardware [
          # Listing & Recovery
          lshw # Hardware lister
          pciutils # PCI utilities
          usbutils # USB utilities
          usbmuxd # USB multiplexer
          testdisk # Data recovery

          # Display & Brightness
          brightnessctl # Backlight control
          ddcutil # Display control CLI
          ddcui # Display control GUI

          # Monitoring
          lm_sensors # Hardware sensors
          smartmontools # Disk health
          efibootmgr # EFI boot manager
          sysfsutils # sysfs utilities

          # GPU / Media
          intel-graphics-compiler # Intel GPU compiler
          intel-media-driver # Intel media driver

          # Network
          iw # Wireless configuration
          wirelesstools # Wireless tools
        ]
        # Performance monitoring
        ++ optionals cfg.performance [
          htop # Process monitor
          nmon # System monitor
          procps # Process utilities
          ps_mem # Memory usage
          sysprof # System profiler
          sysstat # System statistics
          sysz # systemctl fzf
        ]
        # Desktop utilities
        ++ optionals cfg.desktop [
          dbus-broker # D-Bus broker
          dconf # GNOME config
          xdg-utils # XDG utilities
          xdg-user-dirs # User directories
          xdg-desktop-portal-gtk # GTK portal
          gnome-keyring # Keyring daemon
          polkit_gnome # Polkit agent
          shared-mime-info # MIME database
          tumbler # Thumbnailer
        ]
        # Multimedia system tools
        ++ optionals cfg.multimedia [
          cdrtools # CD recording
          ghostscript # PostScript interpreter
          lame # MP3 encoder
          portaudio # Audio I/O
          curtail # Image compressor
        ]
        # Document and PDF generation
        ++ optionals cfg.document [
          wkhtmltopdf # HTML to PDF converter
          python313Packages.weasyprint # Python HTML/CSS to PDF
        ];
    }
  ]);
}
