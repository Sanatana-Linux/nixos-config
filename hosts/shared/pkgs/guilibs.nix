{pkgs, ...}:
with pkgs; [
  cairo
  cairomm
  dbus-broker #gui tool
  dconf
  libcanberra-gtk3 #system tool
  libgee
  libglibutil
  libnotify
  menu-cache #gui tool
  pango
  pangomm
  polkit_gnome
  poppler_utils #system tool
  shutter
  template-glib
  terminus_font #system tool
  xclip #gui tool
  xfce.exo
  xfce.garcon
  xfce.libxfce4ui
  xfce.libxfce4util
  xfce.xfconf
]
