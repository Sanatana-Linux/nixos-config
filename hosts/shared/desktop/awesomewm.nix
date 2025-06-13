{
  pkgs,
  config,
  inputs,
  ...
}: {
  services = {
    xserver = {
      windowManager.awesome = {
        enable = true;
        package = pkgs.awesome-git;
        luaModules = with pkgs.lua51Packages; [
          luaposix
          cqueues
          cjson
          ldbus
          ldoc
          lgi
          lpeg
          lpeg_patterns
          lpeglabel
          lua
          lua-messagepack
          luarocks
          luasocket
          luasql-sqlite3
          mpack
          std-_debug
          std-normalize
          stdlib
          vicious
          wrapLua
        ];
      };
    }; # ends xserver
  }; # ends services
  # ------------------------------------------------- #
  # TODO describe packages in comments
  environment.systemPackages = with pkgs; [
    dbus
    dbus-broker
    dbus-glib
    gobject-introspection-unwrapped
    scrot
    maim
    satty
    menu-cache
    pango
    pangomm
    polkit_gnome
    xfce.garcon
    xfce.libxfce4ui
    xfce.libxfce4util
    xfce.tumbler
    cairo
    cairomm
    gdk-pixbuf
    gdk-pixbuf-xlib
    pango
    pangomm
    xclip
    xdotool
    xsel
    xsettingsd
    dconf-editor
    xfce.libxfce4ui
    xfce.libxfce4util
    xorg.xwininfo
    xdg-launch
    xdg-utils
  ];
  xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];
}
