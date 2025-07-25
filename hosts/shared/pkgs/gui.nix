{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  appimage-run
  appstream-glib
  inputs.zen-browser.packages."${system}".default
  bleachbit
  unstable.calibre
  discord
  epiphany
  kdePackages.breeze-icons
  gnome-icon-theme
  ebook_tools
  rofi-rbw
  rofimoji
  fbida
  gnome-characters
  file-roller
  fontpreview
  fuseiso
  gcolor3
  geocode-glib_2
  kotatogram-desktop
  gmime3
  gnome-disk-utility
  gnome-font-viewer
  gnome-themes-extra
  gob2
  gparted
  graphite2
  gthumb
  gtk2-x11
  gtk3
  gtk3-x11
  gtk4
  gtkspell3
  gtkspellmm
  gusb
  hunspell
  hunspellDicts.de_DE
  hunspellDicts.en_US-large
  hunspellDicts.es_MX
  lcdf-typetools
  leela
  libappindicator-gtk3
  libglibutil
  libnotify
  libsForQt5.qt5ct
  kdePackages.qt6ct
  qt6.full
  libsForQt5.qtcurve
  libsForQt5.qtstyleplugins
  libusb1
  libxdg_basedir
  mime-types
  mimetic
  mupdf
  nerd-font-patcher
  networkmanagerapplet
  ocrmypdf
  pastel
  pavucontrol
  pdf-parser
  pdftag
  pdftk
  perl538Packages.CairoGObject
  poppler_utils
  psftools
  rofi
  t1utils
  tdesktop
  template-glib
  transmission_4-gtk
  ttfautohint
  updfparser
  ventoy-full
  vscode-fhs
  wirelesstools
  wmctrl
  woff2
  xarchiver
  xclip
  xdg-desktop-portal
  xdg-launch
  xdgmenumaker
  xdotool
  xorg.xfontsel
  xscreensaver
]
