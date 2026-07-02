{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.apps.desktop-utils;
in {
  options.modules.system.apps.desktop-utils = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Desktop utility applications (disk manager, partition editor, themes, audio control)";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # System Management
      gnome-disk-utility # Disk manager
      gparted # Partition editor
      bleachbit # System cleaner
      file-roller # Archive manager
      gnome-font-viewer
      # Desktop Integration
      libnotify # Desktop notifications
      xdg-desktop-portal # Desktop portal
      networkmanagerapplet # Network applet
      libappindicator-gtk3 # System tray support
      ncurses # Terminal library
      gtk3 # gtk-update-icon-path utility
      # Configuration & Appearance
      kdePackages.qt6ct # Qt6 configuration
      kdePackages.qtbase # Qt6 base
      kdePackages.breeze-icons # KDE Breeze icons
      gnome-themes-extra # GNOME themes
      themechanger # Theme switcher
      pastel # Color manipulation
      gcolor3 # Color picker
      # Utilities
      hunspell # Spell checker
      hunspellDicts.en-us # English dictionary
      mimetic # MIME library
      pavucontrol # Audio volume control
    ];
  };
}
