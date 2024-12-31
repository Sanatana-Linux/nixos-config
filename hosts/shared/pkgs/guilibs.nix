{pkgs, ...}:
with pkgs; [
  cairo
  cairomm
  dbus-broker #gui tool
  dconf
  libcanberra-gtk3 #system tool
  libgee
  libglibutil
  gdk-pixbuf
  gdk-pixbuf-xlib
  libnotify
  menu-cache #gui tool
  pango
  pangomm
  polkit_gnome
  poppler_utils #system tool
  template-glib
  terminus_font #system tool
  xclip #gui tool
  xfce.exo
  xfce.garcon
  xfce.libxfce4ui
  xfce.libxfce4util
  xfce.xfconf
  python312Packages.cairosvg
  gobject-introspection
  rubyPackages.cairo-gobject
  rubyPackages.gdk_pixbuf2
  rubyPackages.gobject-introspection
  vte-gtk4
  xorg-rgb
  gnome.gvfs
  gnome2.gtkglext
  gobject-introspection-unwrapped
  gtk_engines

]
