{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  appimage-run # Run AppImage files on NixOS
  appstream-glib # Library for reading and writing AppStream metadata
  bleachbit # System cleaner and privacy tool
  ebook_tools # Tools for ebook file manipulation
  element-desktop # Matrix protocol client
  emocli # Emoji picker for the command line
  epiphany # GNOME web browser
  file-roller # Archive manager for GNOME
  fontpreview # Font preview tool
  fuseiso # Mount ISO filesystem images using FUSE
  gcolor3 # Simple color chooser GTK3 application
  geocode-glib_2 # Geocoding library for GLib
  gmime3 # MIME parsing library
  gnome-characters # Character map application for GNOME
  gnome-disk-utility # Disk management utility for GNOME
  gnome-font-viewer # Font viewer for GNOME
  gnome-icon-theme # Default icon theme for GNOME
  gnome-themes-extra # Extra themes for GNOME
  gob2 # GObject Builder preprocessor
  goocanvas_1 # Canvas widget for GTK+
  gparted # Partition editor for GNOME
  graphite2 # Font rendering engine
  gthumb # Image viewer and organizer for GNOME
  gtk2-x11 # GTK+ 2 graphical toolkit for X11
  gtk3 # GTK+ 3 graphical toolkit
  gtk3-x11 # GTK+ 3 for X11
  gtk4 # GTK+ 4 graphical toolkit
  gtkspell3 # Spell checking for GTK+ 3
  gtkspellmm # C++ bindings for GtkSpell
  gusb # GObject wrapper for libusb1
  hunspell # Spell checker and morphological analyzer
  hunspellDicts.de_DE # German dictionary for hunspell
  hunspellDicts.en_US-large # US English dictionary for hunspell (large)
  hunspellDicts.es_MX # Mexican Spanish dictionary for hunspell
  kdePackages.breeze-icons # Breeze icon theme from KDE
  kdePackages.qt6ct # Qt6 configuration tool
  kdePackages.qtbase # Qt6 base libraries
  kdePackages.qtwayland # Qt6 Wayland support
  lcdf-typetools # Tools for manipulating Type 1, Type 42, and OpenType fonts
  leela # Puzzle game based on Lemmings
  libappindicator-gtk3 # Application indicator library for GTK3
  libnotify # Desktop notification library
  libsForQt5.qt5ct # Qt5 configuration tool
  libsForQt5.qtcurve # Unified widget style for Qt and GTK
  libsForQt5.qtstyleplugins # Additional style plugins for Qt5
  libusb1 # Library for USB device access
  libxdg_basedir # Implementation of XDG Base Directory specification
  mailcap # MIME type associations for email clients
  mimetic # MIME message library
  mupdf # Lightweight PDF and XPS viewer
  nerd-font-patcher # Patch fonts with extra glyphs from Nerd Fonts
  networkmanagerapplet # NetworkManager applet for system tray
  ocrmypdf # Add OCR text layer to PDFs
  pastel # Command-line tool to generate and analyze colors
  pavucontrol # PulseAudio volume control
  pdf-parser # Parse and analyze PDF file structure
  pdftag # Add tags to PDF files
  pdftk # PDF manipulation toolkit
  perlPackages.Cairo # Perl bindings for Cairo
  perlPackages.CairoGObject # Perl bindings for Cairo with GObject support
  perlPackages.GooCanvas2CairoTypes # Perl bindings for GooCanvas2 Cairo types
  poppler-utils # PDF rendering library utilities
  psftools # Tools for console fonts
  rofi # Application launcher and window switcher
  rofi-rbw # Rofi frontend for Bitwarden
  t1utils # Type 1 font utilities
  telegram-desktop # Telegram messaging client
  template-glib # Library for template expansion with GLib
  themechanger # Theme switching utility
  transmission_4-gtk # BitTorrent client with GTK4 interface
  ttfautohint # Automatic hinting for TrueType fonts
  unstable.calibre # E-book library management application
  updfparser # PDF parser library
  ventoy-full # Bootable USB solution (full version)
  vesktop # discord client
  vscode-fhs # Visual Studio Code with FHS filesystem
  wirelesstools # Wireless network tools
  wmctrl # Command-line tool to interact with window managers
  woff2 # Web Open Font Format 2 utilities
  xarchiver # Archive manager for GTK
  xclip # Command-line interface to X selections
  xdg-desktop-portal # Desktop integration portal
  xdg-launch # Launch applications using XDG specifications
  xdgmenumaker # Automatic menu generator for window managers
  xdotool # Command-line X11 automation tool
  xorg.xfontsel # X11 font selector
  xscreensaver # Screen saver and locker for X11
]
