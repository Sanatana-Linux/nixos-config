{
  lib,
  pkgs,
  ...
}: {
  hardware = {
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
  programs = {
    # bash.promptInit = ''eval "$(${lib.getExhosts/shared/programs/default.nixe pkgs.starship} init bash)"'';
    dconf.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        android-tools
        android-udev-rules
        binutils
        curl
        glib
        glibc
        icu
        libcanberra-gtk3
        libdbusmenu
        libdbusmenu-gtk3
        libfm
        libfm-extra
        libgee
        libglibutil
        libgudev
        libimobiledevice
        libinput
        libisoburn
        libnotify
        librewolf
        librsvg
        libsecret
        libsForQt5.qt5ct
        libsForQt5.qtstyleplugin-kvantum
        libtiff
        libtool
        libunwind
        libuuid
        libxdg_basedir
        lightlocker
        luajitPackages.cqueues
        luajitPackages.dkjson
        luajitPackages.ldbus
        luajitPackages.ldoc
        luajitPackages.lgi
        luajitPackages.libluv
        luajitPackages.lpeg
        luajitPackages.lpeg_patterns
        luajitPackages.lpeglabel
        luajitPackages.lua
        luajitPackages.lua-curl
        luajitPackages.lua-lsp
        luajitPackages.lua-messagepack
        luajitPackages.lua-protobuf
        luajitPackages.lua-subprocess
        luajitPackages.luacheck
        luajitPackages.luarocks
        luajitPackages.luarocks-nix
        luajitPackages.luasocket
        luajitPackages.luasql-sqlite3
        luajitPackages.mediator_lua
        luajitPackages.mpack
        luajitPackages.sqlite
        luajitPackages.std-_debug
        luajitPackages.std-normalize
        luajitPackages.stdlib
        luajitPackages.vicious
        luajitPackages.wrapLua
        lua51Packages.cqueues
        lua51Packages.dkjson
        lua51Packages.ldbus
        lua51Packages.ldoc
        lua51Packages.lgi
        lua51Packages.libluv
        lua51Packages.lpeg
        lua51Packages.lpeg_patterns
        lua51Packages.lpeglabel
        lua51Packages.lua
        lua51Packages.lua-curl
        lua51Packages.lua-lsp
        lua51Packages.lua-messagepack
        lua51Packages.lua-protobuf
        lua51Packages.lua-subprocess
        lua51Packages.luacheck
        lua51Packages.luarocks
        lua51Packages.luarocks-nix
        lua51Packages.luasocket
        lua51Packages.luasql-sqlite3
        lua51Packages.mediator_lua
        lua51Packages.mpack
        lua51Packages.sqlite
        lua51Packages.std-_debug
        lua51Packages.std-normalize
        lua51Packages.stdlib
        lua51Packages.vicious
        lua51Packages.wrapLua
        openssl
        sassc
        stdenv.cc.cc
        util-linux
        xsettingsd
        zlib
      ];
    };

    java = {
      enable = true;
      package = pkgs.jre;
    };
    # gnome's keyring manager
    seahorse.enable = true;

    # help manage android devices via command line
    adb.enable = true;

    # networkmanager tray uility
    nm-applet.enable = false;

    # allow users to mount fuse filesystems with allow_other
    fuse.userAllowOther = true;
    # ------------------------------------------------- #
  };
}
