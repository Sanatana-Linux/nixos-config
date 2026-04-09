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
    
    displayManager = mkOption {
      type = types.enum ["sddm" "ly" "lightdm"];
      default = "lightdm";
      description = "Display manager to use with AwesomeWM";
    };

    lySession = mkOption {
      type = types.bool;
      default = true;
      description = "Create xinitrc session support when using ly display manager";
    };
  };

  config = mkIf cfg.enable {
    # Enable appropriate display manager based on configuration
    modules.desktop.sddm.enable = mkIf (cfg.displayManager == "sddm") true;
    modules.desktop.ly.enable = mkIf (cfg.displayManager == "ly") true;
    modules.desktop.lightdm.enable = mkIf (cfg.displayManager == "lightdm") true;

    # Common AwesomeWM configuration
    services = {
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = false;
          disableWhileTyping = true;
        };
      };

      displayManager.defaultSession = if (cfg.displayManager == "ly") then "xinitrc" else "none+awesome";

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

    environment = {
      systemPackages = with pkgs; [
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
      ] ++ (lib.optionals (cfg.displayManager == "ly" && cfg.lySession) [
        # Additional packages for ly display manager
        pkgs.xauth
        pkgs.xset
      ]);

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

    # Create xinitrc for ly display manager support
    environment.etc."X11/xinit/xinitrc" = mkIf (cfg.displayManager == "ly" && cfg.lySession) {
      text = ''
        #!/bin/sh
        # Simple xinitrc that just starts AwesomeWM
        # X11 resources and authentication are handled by the display manager
        exec ${pkgs.awesome}/bin/awesome
      '';
      mode = "0755";
    };

    # Create desktop session files for LY in custom-sessions directory  
    environment.etc."ly/custom-sessions/awesome.desktop" = mkIf (cfg.displayManager == "ly") {
      text = ''
        [Desktop Entry]
        Version=1.0
        Type=XSession
        Name=AwesomeWM
        Comment=Highly configurable framework window manager
        Exec=${pkgs.awesome}/bin/awesome
        Icon=awesome
        DesktopNames=awesome
      '';
    };
  };
}
