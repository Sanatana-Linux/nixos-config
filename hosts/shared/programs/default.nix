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
  # Things, mostly libraries, that need to be available for other packages on the system 
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        android-tools
        android-udev-rules
        bash
        binutils
        curl
        glib
        glibc
        gmime3
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
        libsForQt5.qt5ct
        libsForQt5.qtstyleplugin-kvantum
        libsecret
        libtiff
        libtool
        libunwind
        libuuid
        libxdg_basedir
        lightlocker
        luajitPackages.cqueues
        luajitPackages.cjson
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
        openssl
        sassc
        stdenv.cc.cc
        util-linux
        xsettingsd
        zlib
        zsh
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
