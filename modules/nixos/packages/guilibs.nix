{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.packages.guilibs = {
    enable = mkEnableOption "Essential GUI libraries for desktop applications";

    coreGraphics = mkEnableOption "Core graphics libraries (Cairo, Pango)" // {default = true;};
    gobjectSupport = mkEnableOption "GObject introspection and utilities" // {default = true;};
    desktopIntegration = mkEnableOption "Desktop integration libraries" // {default = true;};
    xfceSupport = mkEnableOption "Xfce desktop environment libraries" // {default = true;};
    audioTerminal = mkEnableOption "Audio and terminal widget libraries" // {default = true;};
    pythonBindings = mkEnableOption "Python GUI bindings" // {default = true;};
    rubyBindings = mkEnableOption "Ruby GUI bindings" // {default = false;};
    fontSupport = mkEnableOption "Font and display utilities" // {default = true;};
  };

  config = mkIf config.modules.packages.guilibs.enable {
    environment.systemPackages = with pkgs;
      []
      # Core graphics libraries
      ++ optionals config.modules.packages.guilibs.coreGraphics [
        cairo # 2D graphics library
        cairomm # C++ bindings for Cairo
        pango # Text layout and rendering
        pangomm # C++ bindings for Pango
        gdk-pixbuf # Image loading library
        gdk-pixbuf-xlib # Xlib integration for gdk-pixbuf
      ]
      # GObject and introspection
      ++ optionals config.modules.packages.guilibs.gobjectSupport [
        gobject-introspection # Language binding support
        gobject-introspection-unwrapped # Unwrapped version
        libgee # GObject collection library
        libpeas # Plugin engine based on GObject
        libpeas2 # Plugin engine v2
      ]
      # Desktop integration
      ++ optionals config.modules.packages.guilibs.desktopIntegration [
        dbus-broker # High-performance D-Bus message broker
        dconf # Configuration storage system
        gsettings-desktop-schemas # Desktop schemas for GSettings
        libnotify # Desktop notification library
        polkit_gnome # GNOME authentication agent for polkit
        menu-cache # Menu cache for desktop environments
        garcon # Menu implementation for Xfce
      ]
      # Xfce libraries
      ++ optionals config.modules.packages.guilibs.xfceSupport [
        libxfce4ui # Xfce UI widgets and utilities
        libxfce4util # Xfce utility library
        xfce4-exo # Xfce extension library
        xfconf # Xfce configuration storage system
      ]
      # Audio and terminal support
      ++ optionals config.modules.packages.guilibs.audioTerminal [
        libcanberra-gtk3 # Sound theme implementation
        portaudio # Cross-platform audio I/O library
        vte-gtk4 # Terminal emulator widget for GTK 4
      ]
      # Python bindings
      ++ optionals config.modules.packages.guilibs.pythonBindings (with python312Packages;
        [
          pycairo # Python bindings for Cairo
          pygobject3 # Python bindings for GObject
          # PyQt6 packages
          pyqt6 # Python bindings for Qt6
          pyqt6-sip # SIP bindings for PyQt6
          pyqt6-webengine # Web engine for PyQt6
        ]
        ++ (with python313Packages; [
          # Python 3.13 PyQt6 packages for compatibility
          pyqt6
          pyqt6-sip
        ]))
      # Ruby bindings
      ++ optionals config.modules.packages.guilibs.rubyBindings [
        rubyPackages.cairo # Ruby bindings for Cairo
        rubyPackages.gdk_pixbuf2 # Ruby bindings for GdkPixbuf
        rubyPackages.gobject # Ruby bindings for GObject
      ]
      # Font and display utilities
      ++ optionals config.modules.packages.guilibs.fontSupport [
        terminus_font # Terminus bitmap font
        xorg.rgb # X11 color name database
      ];
  };
}
