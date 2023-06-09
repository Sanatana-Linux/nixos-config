{
  lib,
  pkgs,
  ...
}: {
  programs = {
    adb.enable = true;
    bash.promptInit = ''eval "$(${lib.getExe pkgs.starship} init bash)"'';
    dconf.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
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
        luajitPackages.luadbi-sqlite3
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

    # ------------------------------------------------- #
  };
}
