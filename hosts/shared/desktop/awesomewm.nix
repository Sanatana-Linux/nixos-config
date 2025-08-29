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
    xserver = {
      windowManager.awesome = {
        enable = true;

        package = inputs.nixpkgs-f2k.packages.${pkgs.system}.awesome-luajit-git.overrideAttrs (prevAttrs: {
          GI_TYPELIB_PATH = let
            mkTypeLibPath = pkg: "${pkg}/lib/girepository-1.0";
            extraGITypeLibPaths =
              lib.forEach (
                with pkgs; [
                  networkmanager
                  upower
                  cairo
                  goocanvas
                  librsvg
                ]
              )
              mkTypeLibPath;
          in
            lib.concatStringsSep ":" (extraGITypeLibPaths ++ [(mkTypeLibPath pkgs.pango.out)]);
        });
        # List of Lua modules to be available for AwesomeWM.
        luaModules = with pkgs.luajitPackages; [
          luautf8 # text handling
          luaposix # POSIX bindings for Lua.
          cqueues # Networking, event loop, and coroutine library.
          cjson # Fast JSON parsing and encoding support.
          dkjson # Pure Lua JSON module.
          ldbus # D-Bus bindings for Lua.
          ldoc # Documentation generator for Lua code.
          lgi # GObject Introspection for Lua.
          lpeg # Parsing Expression Grammars for Lua.
          lpeg_patterns # Common patterns for LPeg.
          lpeglabel # LPeg extension for labeled failures.
          lua # The Lua language itself.
          lua-messagepack # MessagePack serialization for Lua.
          luarocks # Package manager for Lua modules.
          luasocket # Networking support for Lua.
          luasql-sqlite3 # SQLite3 bindings for LuaSQL.
          mpack # MessagePack implementation for Lua.
          std-_debug # Debugging utilities for Lua.
          std-normalize # Normalization utilities for Lua.
          stdlib # Standard library for Lua.
          vicious # Widgets for AwesomeWM.
          wrapLua # Utility for wrapping Lua scripts.
        ];
      };
    }; # ends xserver
  }; # ends services
  programs.dconf.enable = true;
  # ------------------------------------------------- #
  # System packages required for AwesomeWM and its ecosystem.
  environment.systemPackages = with pkgs; [
    i3lock-fancy-rapid # Lock screen utility.
    luabind_luajit # Lua bindings for C++ using LuaJIT.
    lua51Packages.lua # Lua 5.1 interpreter.
    lua51Packages.lgi # Lua 5.1 packages for luajit compatibility.
    gsettings-desktop-schemas # Schemas for GSettings.
    gobject-introspection-unwrapped # GObject introspection support.
    eggdbus # D-Bus utilities for GObject.
    scrot # Screenshot utility.
    maim # Screenshot utility.
    satty # Screenshot annotation tool.
    menu-cache # Caching mechanism for freedesktop.org menus.
    xfce.garcon # Freedesktop.org menu library.
    xfce.libxfce4ui # XFCE UI library.
    xfce.libxfce4util # XFCE utility library.
    xfce.tumbler # Thumbnail service for XFCE.
    gdk-pixbuf # Image loading library.
    gdk-pixbuf-xlib # Xlib integration for gdk-pixbuf.
    xdotool # Simulate keyboard/mouse input.
    inputs.lemonake.packages.${pkgs.system}.lua-pam-git # PAM bindings for Lua.
    xsel # Manipulate X selections.
    xsettingsd # XSETTINGS daemon.
    dconf-editor # Editor for dconf settings.
    xorg.xwininfo # Window information utility.
    xdg-launch # XDG launcher utility.
    xdg-utils # XDG utilities.
  ];

  security.pam.services.i3lock.enable = true;
  environment = {
    variables = {
      GDK_BACKEND = "x11";
    };

    sessionVariables = {
      LUA_PATH = "${pkgs.luajitPackages.luarocks}/share/lua/${pkgs.luajit.luaversion}/?.lua;${pkgs.luajitPackages.luarocks}/share/lua/${pkgs.luajit.luaversion}/?/init.lua";
      LUA_CPATH = "${pkgs.luajitPackages.luarocks}/lib/lua/${pkgs.luajit.luaversion}/?.so";
      PATH = ["${pkgs.luajitPackages.luarocks}/bin"];
    };
  };
}
