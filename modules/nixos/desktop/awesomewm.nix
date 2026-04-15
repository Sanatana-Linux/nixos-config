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
  };

  config = mkIf cfg.enable {
    # Enable LightDM display manager
    modules.desktop.lightdm.enable = true;

    # Common AwesomeWM configuration
    services = {
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = false;
          disableWhileTyping = true;
        };
      };

      displayManager.defaultSession = "none+awesome";

      xserver = {
        enable = true;
        autorun = true;
        exportConfiguration = true;
        updateDbusEnvironment = true;
        desktopManager.runXdgAutostartIfNone = true;

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
            buildInputs = old.buildInputs ++ [pkgs.glib-networking];
            postPatch = ''
              substituteInPlace {,tests/examples/}CMakeLists.txt \
                --replace-fail 'cmake_minimum_required(VERSION 3.5)' 'cmake_minimum_required(VERSION 3.10)' \
                --replace-warn 'cmake_policy(VERSION 2.6)' 'cmake_policy(VERSION 3.10)'
              mkdir -p /tmp/.cache/fontconfig
              chmod 700 /tmp/.cache/fontconfig
            '';
            preConfigure = ''
              export FONTCONFIG_PATH=/etc/fonts
              export XDG_CACHE_HOME=/tmp
              export HOME=/tmp
              substituteInPlace tests/examples/_postprocess.lua \
                --replace '/usr/bin/env lua' '${pkgs.luajit}/bin/luajit'
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
            ++ [pkgs.lua52Packages.lgi];
        };
      };
    };

    programs.dconf.enable = true;
    gtk.iconCache.enable = true;
    xdg.icons.enable = true;

    environment = {
      systemPackages = with pkgs;
        [
          glib
          luabind_luajit
          lua52Packages.lua
          lua52Packages.lgi
          lua52Packages.lua-pam
          gsettings-desktop-schemas
          gobject-introspection-unwrapped
          eggdbus
          gdk-pixbuf-xlib
          gdk-pixbuf
          luajitPackages.luarocks
          clipse
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
          xcb-proto
          xcb-util-cursor
          xcbutilerrors
          xcbutilimage

          xcbutilxrm
          xcbutilwm
          xcbutilimage
          libxcb-cursor
          libxcb
          libxcb-wm
          libxcb-util
          libxcb-render-util
          libxcb-errors
          xdotool
          xsel
          xsettingsd
          dconf-editor
          xwininfo
          xdg-launch
          xdg-utils
        ]
        ++ [
          # Additional packages for cursor theme initialization
          pkgs.xrdb
          pkgs.xsetroot
        ];

      sessionVariables = {
        LUA_PATH = "${pkgs.luajitPackages.luarocks}/share/lua/${pkgs.luajit.luaversion}/?.lua;${pkgs.luajitPackages.luarocks}/share/lua/${pkgs.luajit.luaversion}/?/init.lua;${pkgs.lua52Packages.lgi}/share/lua/5.2/?.lua;${pkgs.lua52Packages.lgi}/share/lua/5.2/?/init.lua";
        LUA_CPATH = "${pkgs.luajitPackages.luarocks}/lib/lua/${pkgs.luajit.luaversion}/?.so;${pkgs.lua52Packages.lgi}/lib/lua/5.2/?.so";
        PATH = ["${pkgs.luajitPackages.luarocks}/bin"];
        QT_QPA_PLATFORM = mkForce "xcb";
        GDK_BACKEND = "x11";
        SDL_VIDEODRIVER = "x11";
        _JAVA_AWT_WM_NONREPARENTING = "1";
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

    # Create cursor theme initialization script for all sessions
    environment.etc."X11/Xsession.d/90-cursor-theme" = {
      text = ''
                # Initialize cursor theme for AwesomeWM sessions
                # This ensures cursor theme is properly set regardless of display manager
                if [ -n "$XCURSOR_THEME" ] && [ -n "$XCURSOR_SIZE" ]; then
                  # Set X11 cursor resources
                  if command -v xrdb >/dev/null 2>&1; then
                    xrdb -merge <<EOF
        Xcursor.theme: $XCURSOR_THEME
        Xcursor.size: $XCURSOR_SIZE
        EOF
                  fi

                  # Set default X11 cursor
                  if command -v xsetroot >/dev/null 2>&1; then
                    xsetroot -cursor_name left_ptr
                  fi
                fi
      '';
      mode = "0755";
    };
  };
}
