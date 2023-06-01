{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.xserver.windowManager.awesome;
  # -------------------------------------------------------------------------- #
  dbus_proxy = pkgs.callPackage ({
    luajit,
    luajitPackages,
    fetchFromGitHub,
  }:
    luajit.pkgs.buildLuaPackage rec {
      pname = "dbus_proxy";
      version = "0.10.3";
      name = "${pname}-${version}";

      src = fetchFromGitHub {
        owner = "stefano-m";
        repo = "lua-${pname}";
        rev = "v${version}";
        sha256 = "sha256-Yd8TN/vKiqX7NOZyy8OwOnreWS5gdyVMTAjFqoAuces=";
      };

      propagatedBuildInputs = [luajitPackages.lgi];
      buildPhase = ":";

      installPhase = ''
        mkdir -p "$out/share/lua/${luajit.luaversion}"
        cp -r src/${pname} "$out/share/lua/${luajit.luaversion}/"
      '';
    }) {};
  # ------------------------------------------------- #
  async-lua = pkgs.callPackage ({
    luajit,
    fetchFromGitHub,
  }:
    luajit.pkgs.buildLuarocksPackage rec {
      pname = "async.lua";
      version = "scm-1";

      src = fetchFromGitHub {
        owner = "sclu1034";
        repo = pname;
        rev = "f8d8f70a1ef1f7c4d5e3e65a36e0e23d65129e92";
        hash = "sha256-zWeIZkdO5uOHI2dkzseCEj8+BldH7X1ZtfIQhDFjaQY=";
      };

      preConfigure = ''
        ln -s rocks/${pname}-${version}.rockspec .
      '';

      propagatedBuildInputs = [luajit];
    }) {};
  # ------------------------------------------------- #
  lgi-async-extra = pkgs.callPackage ({
    luajit,
    luajitPackages,
    fetchFromGitHub,
  }:
    luajit.pkgs.buildLuarocksPackage rec {
      pname = "lgi-async-extra";
      version = "scm-1";

      src = fetchFromGitHub {
        owner = "sclu1034";
        repo = pname;
        rev = "45281ceaf42140f131861ca6d1717912f94f0bfd";
        hash = "sha256-4Lydw1l3ETLzmsdQu53116rn2oV+XKDDpgxpa3yFbYM=";
      };

      preConfigure = ''
        ln -s rocks/${pname}-${version}.rockspec .
      '';

      propagatedBuildInputs = [async-lua luajit luajitPackages.lgi];
    }) {};
  # ------------------------------------------------- #
  lua-libpulse = pkgs.callPackage ({
    stdenv,
    luajit,
    fetchFromGitHub,
    pkg-config,
    libpulseaudio,
    glib,
    gobject-introspection,
    sass,
  }:
    stdenv.mkDerivation {
      pname = "lua-libpulse-glib";
      version = "scm-1";
      src = fetchFromGitHub {
        owner = "sclu1034";
        repo = "lua-libpulse-glib";
        rev = "3838b9f52a031d921610d49138261d8269e546e8";
        hash = "sha256-jEzcWx8g7+wqoTj6UxJ0bPzVbSUQ6MCwCwKVshALA5M=";
      };
      LUA_VERSION = "jit";
      PKG_CONFIG_PATH = "${luajit}/lib/pkgconfig:${libpulseaudio.dev}/lib/pkgconfig";

      installPhase = ''
        mv out .out
        mkdir -p $out/lib/lua/5.1
        mv .out/*.so $out/lib/lua/5.1/
        mkdir -p $out/share
        mv .out/doc $out/share/
      '';

      buildInputs = [libpulseaudio.dev glib.dev];
      nativeBuildInputs = [pkg-config sass luajit gobject-introspection luajit.pkgs.ldoc];
    }) {};
  # ------------------------------------------------- #
  fzy = pkgs.callPackage ({
    luajit,
    fetchFromGitHub,
  }:
    luajit.pkgs.buildLuarocksPackage rec {
      pname = "fzy";
      version = "scm-1";
      src = fetchFromGitHub {
        owner = "swarn";
        repo = "fzy-lua";
        rev = "0afc7bfaef9c8e6c3882069c7bf3d6548efa788e";
        hash = "sha256-WfHPRN2fC3qYLuHpJHoOzh7DnY7xZdCp8bN6kEKc7W8=";
      };
      propagatedBuildInputs = [luajit];
    }) {};

  # reinventing the wheel of the default awesomewm module
  getLuaPath = lib: dir: "${lib}/${dir}/lua/${pkgs.luajit.luaversion}";
  makeSearchPath = lib.concatMapStrings (
    path:
      " --search "
      + (getLuaPath path "share")
      + " --search "
      + (getLuaPath path "lib")
  );
  luaModules = with pkgs.luajitPackages; [
    lgi
    luadbi-mysql
    luaposix
    ldbus
    rapidjson
    # packaged above
    fzy
    lua-libpulse
  ];
in {
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    displayManager.gtkgreet.entries = [
      {
        entryName = "awesome";
        isXWM = true;
        preCmd = "xrdb -load .Xresources";
        cmd = "${pkgs.awesome-git-luajit}/bin/awesome ${makeSearchPath luaModules}";
        postCmd = "dbus-launch --exit-with-x11 ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      }
    ];
  };
  environment.systemPackages = with pkgs; [
    awesome-git-luajit #for awesome-client
    xsel
    xclip
    maim
    xdotool
    xfce.xfce4-clipman-plugin
    xfce.thunar
    xorg.xwininfo
    networkmanagerapplet
    picom
    libnotify
    lxrandr
    redshift
    i3lock-color
    sox
    pamixer
    imagemagick
  ];
}
