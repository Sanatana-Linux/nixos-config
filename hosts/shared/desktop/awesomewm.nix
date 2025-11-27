{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  xdg.portal.enable = true;
  xdg.portal.config.common.default = "*";

  services = {
    displayManager.defaultSession = "none+awesome";
    xserver = {
      windowManager.awesome = {
        enable = true;
        package = inputs.nixpkgs-f2k.packages.${pkgs.system}.awesome-luajit-git;
        luaModules = with pkgs.luajitPackages; [
          luautf8
          luaposix
          cqueues
          cjson
          dkjson
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
        ] ++ [pkgs.lua51Packages.lgi];
      };
    }; # ends xserver
  }; # ends services
  programs.dconf.enable = true;
  # ------------------------------------------------- #
  # System packages required for AwesomeWM and its ecosystem.
  environment.systemPackages = with pkgs; [
    glib
    i3lock-fancy-rapid
    luabind_luajit
    lua51Packages.lua
    lua51Packages.lgi
    gsettings-desktop-schemas
    gobject-introspection-unwrapped
    eggdbus
    scrot
    maim
    satty
    menu-cache
    xfce.garcon
    xfce.libxfce4ui
    xfce.libxfce4util
    xfce.tumbler
    gdk-pixbuf
    gdk-pixbuf-xlib
    xdotool
    inputs.lemonake.packages.${pkgs.system}.lua-pam-git
    xsel
    xsettingsd
    dconf-editor
    xorg.xwininfo
    xdg-launch
    xdg-utils
  ];

  security.pam.services.i3lock.enable = true;
  environment = {
    variables = {
      GDK_BACKEND = "x11";
    };

    sessionVariables = {
      LUA_PATH = "${pkgs.luajitPackages.luarocks}/share/lua/${pkgs.luajit.luaversion}/?.lua;${pkgs.luajitPackages.luarocks}/share/lua/${pkgs.luajit.luaversion}/?/init.lua;${pkgs.lua51Packages.lgi}/share/lua/5.1/?.lua;${pkgs.lua51Packages.lgi}/share/lua/5.1/?/init.lua";
      LUA_CPATH = "${pkgs.luajitPackages.luarocks}/lib/lua/${pkgs.luajit.luaversion}/?.so;${pkgs.lua51Packages.lgi}/lib/lua/5.1/?.so";
      PATH = ["${pkgs.luajitPackages.luarocks}/bin"];
      GI_TYPELIB_PATH = lib.concatStringsSep ":" [
        "${pkgs.glib.dev}/lib/girepository-1.0"
        "${pkgs.gobject-introspection-unwrapped}/lib/girepository-1.0"
        "${pkgs.gobject-introspection}/lib/girepository-1.0"
        "${pkgs.networkmanager}/lib/girepository-1.0"
        "${pkgs.upower}/lib/girepository-1.0"
        "${pkgs.cairo}/lib/girepository-1.0"
        "${pkgs.pango.out}/lib/girepository-1.0"
        "${pkgs.librsvg}/lib/girepository-1.0"
        "${pkgs.goocanvas}/lib/girepository-1.0"
      ];
    };
  };
}
