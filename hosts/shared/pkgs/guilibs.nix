{pkgs, ...}:
with pkgs; [
  cairo # 2D graphics library
  cairomm # C++ bindings for Cairo
  dbus-broker # D-Bus message broker implementation
  dconf # GNOME configuration database system
  garcon # Xfce menu library
  gdk-pixbuf # Library for image loading and pixel buffer manipulation
  gdk-pixbuf-xlib # X11 integration for gdk-pixbuf
  gnome.gvfs # Virtual filesystem implementation for GNOME
  gnome2.gtkglext # OpenGL extension for GTK+ 2
  gobject-introspection # Middleware for C library bindings
  gobject-introspection-unwrapped # GObject introspection tools (unwrapped)
  gsettings-desktop-schemas # Collection of GSettings schemas
  gtk_engines # Theme engines for GTK+
  htmldoc # HTML conversion and documentation tool
  libcanberra-gtk3 # Event sound library for GTK3
  libgee # Collection library for Vala/GObject
  libgudev # GObject bindings for libudev
  libnotify # Desktop notification library
  libpeas # GObject plugin system
  libpeas2 # GObject plugin system (version 2)
  menu-cache # Library for menu specification caching
  pango # Text layout and rendering library
  pangomm # C++ bindings for Pango
  polkit_gnome # GNOME authentication agent for PolicyKit
  poppler-utils # PDF rendering library utilities
  portaudio # Cross-platform audio I/O library
  python312Packages.cairosvg # SVG to PNG/PDF/PS converter using Cairo
  python312Packages.pyqt6 # Python bindings for Qt6
  python312Packages.qtpy # Abstraction layer for PyQt5/PyQt6/PySide2/PySide6
  python313Packages.pyqt6 # Python 3.13 bindings for Qt6
  rubyPackages.cairo-gobject # Ruby bindings for Cairo with GObject support
  rubyPackages.gdk_pixbuf2 # Ruby bindings for gdk-pixbuf
  rubyPackages.gobject-introspection # Ruby bindings for GObject Introspection
  template-glib # Library for template expansion with GLib
  terminus_font # Clean fixed-width bitmap font
  vte-gtk4 # Terminal emulator widget for GTK4
  xfce4-exo # Xfce extension library
  xfconf # Xfce configuration storage system
  xorg-rgb # X11 RGB color database
  libxfce4ui # Xfce UI library
  libxfce4util # Xfce utility library
]
