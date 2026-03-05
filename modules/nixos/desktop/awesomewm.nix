{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.awesomewm;
in {
  options.modules.desktop.awesomewm = {
    enable = mkEnableOption "AwesomeWM window manager";

    useGitVersion = mkOption {
      type = types.bool;
      default = true;
      description = "Use git version of AwesomeWM instead of stable";
    };

    extraLuaModules = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional Lua modules to include";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional packages for AwesomeWM ecosystem";
    };

    lockCommand = mkOption {
      type = types.str;
      default = "i3lock-fancy-rapid";
      description = "Screen lock command to use";
    };
  };

  config = mkIf cfg.enable {
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdg.portal.config.common.default = "*";

    services = {
      displayManager.defaultSession = "none+awesome";
      xserver = {
        windowManager.awesome = {
          enable = true;
          package =
            if cfg.useGitVersion
            then
              pkgs.awesome.overrideAttrs (old: rec {
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
              })
            else pkgs.awesome;

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
            ++ [pkgs.lua51Packages.lgi] ++ cfg.extraLuaModules;
        };
      };
    };

    programs.dconf.enable = true;

    environment = {
      systemPackages = with pkgs;
        [
          # Core AwesomeWM runtime dependencies
          glib
          i3lock-fancy-rapid
          luabind_luajit
          lua51Packages.lua
          lua51Packages.lgi
          gsettings-desktop-schemas
          gobject-introspection-unwrapped

          # Display and screenshot tools
          eggdbus
          scrot
          maim
          satty
          xdotool
          xsel
          xsettingsd
          dconf-editor
          xwininfo
          xdg-launch
          xdg-utils

          # XFCE components for file management integration
          menu-cache
          garcon
          libxfce4ui
          libxfce4util
          tumbler
          gdk-pixbuf
          gdk-pixbuf-xlib

          # External inputs
          inputs.lemonake.packages.${pkgs.stdenv.hostPlatform.system}.lua-pam-git
        ]
        ++ cfg.extraPackages;

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
          "${pkgs.goocanvas_1}/lib/girepository-1.0"
          "${pkgs.at-spi2-core}/lib/girepository-1.0"
          "${pkgs.atk}/lib/girepository-1.0"
        ];
      };
    };

    security.pam.services.i3lock.enable = true;
  };
}
