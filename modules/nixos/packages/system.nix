{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.packages.system;
in {
  options.modules.packages.system = {
    enable = mkEnableOption "System utilities and tools";

    filesystem = {
      enable = mkEnableOption "Filesystem utilities (mounting, formatting, etc.)";
    };

    hardware = {
      enable = mkEnableOption "Hardware monitoring and configuration tools";
    };

    network = {
      enable = mkEnableOption "Network utilities and tools";
    };

    performance = {
      enable = mkEnableOption "Performance monitoring and profiling tools";
    };

    desktop = {
      enable = mkEnableOption "Desktop integration and X11 utilities";
    };

    multimedia = {
      enable = mkEnableOption "Audio/video processing and media tools";
    };

    minimal = mkEnableOption "Preset enabling common system utilities for live/ISO environments";
  };

  config = mkMerge [
    # Minimal preset: enable common subsystems, skip hardware-specific tools
    (mkIf cfg.minimal {
      modules.packages.system = {
        filesystem.enable = mkDefault true;
        network.enable = mkDefault true;
        performance.enable = mkDefault true;
        desktop.enable = mkDefault true;
        multimedia.enable = mkDefault true;
        hardware.enable = mkDefault false;
      };
    })

    {
      environment.systemPackages = with pkgs;
        (optionals cfg.enable [
          # Essential system utilities
          automake # GNU automatic makefile generator
          comma # Run programs without installing them
          fd # Simple, fast alternative to find
          gh # GitHub CLI
          jq # Command-line JSON processor
          moreutils # Additional Unix utilities
          neofetch # System information tool
          parallel # Execute jobs in parallel
          ripgrep-all # Search tool combining ripgrep with parsers
          util-linux # System utilities for Linux
          wget # Network downloader
        ])
        ++ (optionals cfg.filesystem.enable [
          # Filesystem utilities
          afuse # Automount filesystem using FUSE
          avfs # Virtual filesystem for archive access
          dosfstools # Utilities for FAT filesystems
          exfatprogs # exFAT filesystem utilities
          ntfs3g # NTFS filesystem driver
          ntfsprogs # NTFS filesystem utilities
          testdisk # Data recovery software
          xorriso # ISO 9660 filesystem manipulator
        ])
        ++ (optionals cfg.hardware.enable [
          # Hardware tools
          brightnessctl # Control device brightness
          ddcui # Graphical UI for ddcutil
          ddcutil # Query and change monitor settings
          efibootmgr # Modify UEFI boot entries
          intel-graphics-compiler # Intel graphics shader compiler
          lm_sensors # Hardware health monitoring
          lshw # Hardware lister
          microcode-intel # Intel CPU microcode updates
          smartmontools # Control SMART enabled hard drives
          sysfsutils # Utilities for querying sysfs
        ])
        ++ (optionals cfg.performance.enable [
          # Performance monitoring
          htop # Interactive process viewer
          nmon # Performance monitoring tool
          procps # Process monitoring utilities
          ps_mem # Memory usage per-program analyzer
          sysprof # System-wide profiler
          sysstat # System performance tools
          systeroid # Sysctl explorer
          sysz # Fuzzy systemctl wrapper
        ])
        ++ (optionals cfg.desktop.enable [
          # Desktop integration and X11
          dbus-broker # D-Bus message broker
          dconf # GNOME configuration system
          gnome-keyring # GNOME password manager
          polkit_gnome # GNOME authentication agent
          shared-mime-info # Shared MIME database
          tumbler # D-Bus thumbnail service
          xdg-desktop-portal-gtk # GTK backend for xdg-desktop-portal
          xdg-user-dirs # Tool to manage user directories
          xdg-utils # Desktop integration utilities
          # X11 utilities
          xbacklight # Adjust backlight brightness
          xev # X11 event tester
          xhost # Server access control
          xinit # X Window System initializer
          xkill # Kill X11 clients
          xprop # X11 property displayer
          xwininfo # X11 window information utility
          xsecurelock # X11 screen locker
          xss-lock # External locker as screen saver
          xsuspender # Suspend inactive X11 applications
        ])
        ++ (optionals cfg.multimedia.enable [
          # Audio/video and media processing
          cdrtools # CD/DVD/BluRay recording software
          curtail # Image compression application
          ghostscript # PostScript and PDF interpreter
          lame # MP3 encoder
          portaudio # Cross-platform audio I/O library
        ]);
    }
  ];
}
