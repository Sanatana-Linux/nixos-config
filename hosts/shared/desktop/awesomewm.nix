{
  pkgs,
  config,
  ...
}: {
  services = {
    xserver = {
      windowManager.awesome = {
        enable = true;
        package = pkgs.awesome-git-luajit;
        luaModules = with pkgs.luajitPackages; [
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
  # TODO describe ppackages in comments
  environment.systemPackages = with pkgs; [
    dbus
    dbus-broker
    dbus-glib
    gobject-introspection-unwrapped
    scrot
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
    awesome-git-luajit
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
  ];
  xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];
}
