{pkgs, ...}:
with pkgs; [
  cairo
  cairomm
  dbus-broker #gui tool
  dconf
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
  poppler_utils #system tool
  python312Packages.cairosvg
  python312Packages.pyqt6
  python312Packages.qtpy
  rubyPackages.cairo-gobject
  rubyPackages.gdk_pixbuf2
  rubyPackages.gobject-introspection
  template-glib
  terminus_font #system tool
  vte-gtk4
  xclip #gui tool
  xfce.exo
  xfce.garcon
  xfce.libxfce4ui
  xfce.libxfce4util
  xfce.xfconf
  xorg-rgb
]
