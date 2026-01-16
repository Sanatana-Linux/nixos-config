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
        package = pkgs.awesome.overrideAttrs (old: rec {
          version = "git-2024-12-08";
          src = pkgs.fetchFromGitHub {
            owner = "awesomewm";
            repo = "awesome";
            rev = "41473c05ed9e85de66ffb805d872f2737c0458b6";
            hash = "sha256-dGceJ5cAxDSUPCqXYAZgzEeC9hd7GQMYPex7nCZ8SEg=";
          };
          patches = [];
          # Ensure GIO_EXTRA_MODULES is available for GioUnix
          buildInputs = old.buildInputs ++ [pkgs.glib-networking];
          # Combined fixes for CMake version and fontconfig sandbox issues
          postPatch = ''
            substituteInPlace {,tests/examples/}CMakeLists.txt \
              --replace-fail 'cmake_minimum_required(VERSION 3.5)' 'cmake_minimum_required(VERSION 3.10)' \
              --replace-warn 'cmake_policy(VERSION 2.6)' 'cmake_policy(VERSION 3.10)'
            # Create fontconfig cache directory and set proper environment
            mkdir -p /tmp/.cache/fontconfig
            chmod 700 /tmp/.cache/fontconfig
          '';
          # Set fontconfig environment variables for sandbox and fix Lua scripts
          preConfigure = ''
            export FONTCONFIG_PATH=/etc/fonts
            export XDG_CACHE_HOME=/tmp
            export HOME=/tmp
            # Fix the Lua postprocessing script shebang
            substituteInPlace tests/examples/_postprocess.lua \
              --replace '/usr/bin/env lua' '${pkgs.luajit}/bin/lua'
          '';
        });
        luaModules = with pkgs.luajitPackages;
          [
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
          ]
          ++ [pkgs.lua51Packages.lgi];
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
    garcon
    libxfce4ui
    libxfce4util
    tumbler
    gdk-pixbuf
    gdk-pixbuf-xlib
    xdotool
    inputs.lemonake.packages.${pkgs.stdenv.hostPlatform.system}.lua-pam-git
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
        "${pkgs.gtk3}/lib/girepository-1.0"
        "${pkgs.networkmanager}/lib/girepository-1.0"
        "${pkgs.upower}/lib/girepository-1.0"
        "${pkgs.cairo}/lib/girepository-1.0"
        "${pkgs.pango.out}/lib/girepository-1.0"
        "${pkgs.librsvg}/lib/girepository-1.0"
        "${pkgs.goocanvas}/lib/girepository-1.0"
        "${pkgs.at-spi2-core}/lib/girepository-1.0"
        "${pkgs.atk}/lib/girepository-1.0"
      ];
    };
  };
}
