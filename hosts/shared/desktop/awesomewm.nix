{
  pkgs,
  config,
  inputs,
  ...
}: {
  # Enable and configure the X server with AwesomeWM as the window manager.
  services = {
    xserver = {
      windowManager.awesome = {
        enable = true;
        package = pkgs.awesome-git; # Use the latest git version of AwesomeWM.
        # List of Lua modules to be available for AwesomeWM.
        luaModules = with pkgs.luajitPackages; [
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

  # ------------------------------------------------- #
  # System packages required for AwesomeWM and its ecosystem.
  # TODO: Describe each package in detail.
  environment.systemPackages = with pkgs; [
    dbus # Message bus system.
    dbus-broker # Modern D-Bus message broker.
    dbus-glib # GLib bindings for D-Bus.
    gobject-introspection-unwrapped # GObject introspection support.
    eggdbus # D-Bus utilities for GObject.
    scrot # Screenshot utility.
    maim # Screenshot utility.
    satty # Screenshot annotation tool.
    menu-cache # Caching mechanism for freedesktop.org menus.
    pango # Text layout and rendering.
    pangomm # C++ bindings for Pango.
    polkit_gnome # Authentication agent for PolicyKit.
    xfce.garcon # Freedesktop.org menu library.
    xfce.libxfce4ui # XFCE UI library.
    xfce.libxfce4util # XFCE utility library.
    xfce.tumbler # Thumbnail service for XFCE.
    cairo # 2D graphics library.
    cairomm # C++ bindings for Cairo.
    gdk-pixbuf # Image loading library.
    gdk-pixbuf-xlib # Xlib integration for gdk-pixbuf.
    xclip # Command line interface to X selections.
    xdotool # Simulate keyboard/mouse input.
    xsel # Manipulate X selections.
    xsettingsd # XSETTINGS daemon.
    dconf-editor # Editor for dconf settings.
    xorg.xwininfo # Window information utility.
    xdg-launch # XDG launcher utility.
    xdg-utils # XDG utilities.
  ];

  # Add extra XDG portal for GTK support.
  xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];
}
