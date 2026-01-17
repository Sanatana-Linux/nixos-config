{pkgs, ...}:
with pkgs; [
  cairo
  cairomm
  dbus-broker #gui tool
  dconf
  portaudio
  gdk-pixbuf
  gdk-pixbuf-xlib
  gnome.gvfs
  gnome2.gtkglext
  gobject-introspection
  gobject-introspection-unwrapped
  gsettings-desktop-schemas
  gtk_engines
  htmldoc
  libcanberra-gtk3 #system tool
  libpeas2
  libpeas
  libgudev
  libgee
  libgee
  libglibutil
  libnotify
  menu-cache #gui tool
  pango
  pangomm
  polkit_gnome
  poppler-utils #system tool
  python312Packages.cairosvg
  python312Packages.pyqt6
  python313Packages.pyqt6
  python312Packages.qtpy
  rubyPackages.cairo-gobject
  rubyPackages.gdk_pixbuf2
  rubyPackages.gobject-introspection
  template-glib
  terminus_font #system tool
  vte-gtk4
  xclip #gui tool
  xfce4-exo
  garcon
  libxfce4ui
  libxfce4util
  xfconf
  xorg-rgb
]
