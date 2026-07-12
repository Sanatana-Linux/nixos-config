{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.packages.gui;
in {
  options.modules.base.packages.gui = {
    enable = mkEnableOption "GUI applications and utilities";
    minimal = mkEnableOption "Minimal GUI for live/ISO environments";
    applicationLauncher = mkEnableOption "Application launcher tools";
    mediaTools = mkEnableOption "Media management tools";
    developmentTools = mkEnableOption "GUI development tools";
    windowManagement = mkEnableOption "Window management utilities";
    messaging = mkEnableOption "Messaging applications";
    extraPackages = mkEnableOption "Extra GUI packages";

    libs = {
      enable = mkEnableOption "GUI libraries";
      coreGraphics = mkEnableOption "Core graphics libraries (cairo, pango)";
      gobjectSupport = mkEnableOption "GObject introspection support";
      desktopIntegration = mkEnableOption "Desktop integration libraries";
      xfceSupport = mkEnableOption "XFCE library support";
      audioTerminal = mkEnableOption "Audio and terminal libraries";
      pythonBindings = mkEnableOption "Python GUI bindings";
      rubyBindings = mkEnableOption "Ruby GUI bindings";
      fontSupport = mkEnableOption "Font support libraries";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # Minimal preset
    (mkIf cfg.minimal {
      modules.base.packages.gui = {
        messaging = mkDefault false;
        developmentTools = mkDefault false;
        extraPackages = mkDefault false;
      };
    })

    {
      environment.systemPackages = with pkgs;
        []
        # Application launcher
        ++ optionals cfg.applicationLauncher [
          xdg-launch # XDG application launcher
          xdgmenumaker # Generate XDG menus
        ]
        # Media tools
        ++ optionals cfg.mediaTools [
          # Document tools
          sioyek # PDF viewer with Vim keys
          mupdf # PDF viewer
          poppler-utils # PDF utilities
          pdftk # PDF toolkit
          calibre # Comprehensive e-book software with ebook-convert

          # Other
          transmission_4-gtk # BitTorrent client
        ]
        # Development tools
        ++ optionals cfg.developmentTools [
          appimage-run # Run AppImages
          ventoy-full # Bootable USB creator
        ]
        # Window management
        ++ optionals cfg.windowManagement [
          picom # Compositor
          maim # Screenshot utility
          wmctrl # Window manager control
        ]
        # Messaging
        ++ optionals cfg.messaging [
          telegram-desktop # Telegram client
          signal-desktop # Signal messenger
          signal-cli # Signal CLI interface
          signal-export # Export Signal chats to markdown
          signalbackup-tools # Signal backup file tools
          signal-backup-deduplicator # Signal backup deduplication
          element-desktop # Matrix client
        ];
    }

    # GUI Libraries
    (
      mkIf cfg.libs.enable {
        environment.systemPackages = with pkgs;
        # Core graphics
          optionals cfg.libs.coreGraphics [
            cairo # 2D graphics library
            cairomm # Cairo C++ bindings
            pango # Text rendering
            pangomm # Pango C++ bindings
            gdk-pixbuf # Image loading
            gdk-pixbuf-xlib # Xlib support
          ]
          # GObject support
          ++ optionals cfg.libs.gobjectSupport [
            gobject-introspection # GObject introspection
            gobject-introspection-unwrapped # Unwrapped version
            libgee # GObject collection library
            libpeas # GObject plugin library
            libpeas2 # libpeas v2
          ]
          # Desktop integration
          ++ optionals cfg.libs.desktopIntegration [
            dbus-broker # D-Bus message broker
            dconf # GNOME configuration
            gsettings-desktop-schemas # GNOME schemas
            libnotify # Notifications library
            polkit_gnome # Polkit agent
            menu-cache # Menu caching

            libadwaita # Modern GNOME applications library
            adwaita-icon-theme # Essential icons for libadwaita
            hicolor-icon-theme # Icon theme fallback system
          ]
          # XFCE support
          ++ optionals cfg.libs.xfceSupport [
            libxfce4ui # XFCE UI library
            libxfce4util # XFCE utilities
            xfce4-exo # XFCE extensions
            xfconf # XFCE configuration
          ]
          # Audio and terminal
          ++ optionals cfg.libs.audioTerminal [
            libcanberra-gtk3 # Sound theme library
            portaudio # Audio I/O
            vte-gtk4 # Terminal emulator library
          ]
          # Python bindings
          ++ optionals cfg.libs.pythonBindings [
            python313Packages.pycairo # Cairo Python bindings
            python313Packages.pygobject3 # GObject Python bindings
            python313Packages.pyqt6 # Qt6 Python bindings
            python313Packages.pyqt6-charts # Qt Charts
            python313Packages.pyqt6-webengine # Qt WebEngine
            python313Packages.pyqt5 # Qt5 Python bindings
            python313Packages.qt-material # Qt Material Design
            python313Packages.qstylizer # Qt CSS-like styling
            python313Packages.anyqt # Qt compatibility layer
            python313Packages.pyqtdarktheme # Dark theme for Qt apps
            python313Packages.qtpy # Qt abstraction layer
          ]
          # Ruby bindings
          ++ optionals cfg.libs.rubyBindings [
            rubyPackages.cairo # Cairo Ruby bindings
            rubyPackages.gdk_pixbuf2 # GdkPixbuf Ruby
            rubyPackages.gobject-introspection # GObject Ruby
          ]
          # Font support
          ++ optionals cfg.libs.fontSupport [
            terminus_font # Terminus font
          ];
      }
    )
  ]);
}
