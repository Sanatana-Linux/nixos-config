{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.packages.gui;
in {
  options.modules.packages.gui = {
    enable = mkEnableOption "GUI application packages";

    applicationLauncher = mkOption {
      type = types.bool;
      default = true;
      description = "Enable application launchers (rofi, xdg utilities)";
    };

    mediaTools = mkOption {
      type = types.bool;
      default = true;
      description = "Enable media tools (gthumb, mupdf, transmission)";
    };

    developmentTools = mkOption {
      type = types.bool;
      default = false;
      description = "Enable development tools (VSCode, appimage-run)";
    };

    windowManagement = mkOption {
      type = types.bool;
      default = true;
      description = "Enable window management utilities (picom, wmctrl, maim)";
    };

    messaging = mkOption {
      type = types.bool;
      default = true;
      description = "Enable messaging applications (telegram, element, vesktop)";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional GUI packages to install";
    };

    minimal = mkEnableOption "Minimal GUI packages for live/ISO environments";
  };

  config = mkMerge [
    # Minimal preset: disable messaging apps for live/ISO
    (mkIf cfg.minimal {
      modules.packages.gui = {
        messaging = mkDefault false;
      };
    })

    (mkIf cfg.enable {
      environment.systemPackages = with pkgs;
        [
          # Core GUI applications
          bleachbit
          file-roller
          fontpreview
          gcolor3
          gnome-characters
          gnome-disk-utility
          gnome-font-viewer
          gnome-themes-extra
          gparted
          gthumb
          hunspell
          hunspellDicts.en_US-large
          kdePackages.breeze-icons
          kdePackages.qt6ct
          kdePackages.qtbase
          libappindicator-gtk3
          libnotify
          mimetic
          mupdf
          networkmanagerapplet
          pastel
          pavucontrol
          poppler-utils
          themechanger
          xarchiver
          xclip
          xdg-desktop-portal
          xdotool
          xfontsel
          xscreensaver
        ]
        ++ optionals cfg.applicationLauncher [
          rofi
          rofi-rbw
          xdg-launch
          xdgmenumaker
        ]
        ++ optionals cfg.mediaTools [
          gthumb
          transmission_4-gtk
          ocrmypdf
          pdftk
        ]
        ++ optionals cfg.developmentTools [
          appimage-run
          vscode-fhs
          ventoy-full
        ]
        ++ optionals cfg.windowManagement [
          maim # Screenshot utility
          picom # Compositor for X11
          wmctrl # Command-line window manager control
        ]
        ++ optionals cfg.messaging [
          telegram-desktop
          element-desktop
          vesktop
        ]
        ++ cfg.extraPackages;
    })
  ];
}
