{
  pkgs,
  stdenv,
  lib,
  fetchFromGitHub,
}:
let
  giTypeLibPath = lib.concatStringsSep ":" [
    "${pkgs.glib.dev}/lib/girepository-1.0"
    "${pkgs.networkmanager}/lib/girepository-1.0"
    "${pkgs.upower}/lib/girepository-1.0"
    "${pkgs.cairo}/lib/girepository-1.0"
    "${pkgs.pango.out}/lib/girepository-1.0"
    "${pkgs.librsvg}/lib/girepository-1.0"
    "${pkgs.goocanvas}/lib/girepository-1.0"
    "${pkgs.gobject-introspection-unwrapped}/lib/girepository-1.0"
    "${pkgs.gobject-introspection}/lib/girepository-1.0"
  ];
in
stdenv.mkDerivation rec {
  pname = "awesome-luajit";
  version = "4.3-git";

  src = fetchFromGitHub {
    owner = "awesomeWM";
    repo = "awesome";
    rev = "master";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    makeWrapper
    asciidoc
    xmlto
    docbook_xsl
  ];

  buildInputs = with pkgs; [
    xorg.xcb-util
    xorg.xcb-util-cursor
    xorg.xcb-util-keysyms
    xorg.xcb-util-wm
    xorg.xcb-util-xrm
    xorg.libxkbcommon
    cairo
    gdk-pixbuf
    glib
    glib-networking
    gobject-introspection
    gobject-introspection-unwrapped
    imagemagick
    libxdg-basedir
    luajit
    pango
    startup-notification
    xcb-util-xrm
    xkeyboard_config
    libxcb
    rlwrap
    dbus
  ];

  GI_TYPELIB_PATH = giTypeLibPath;

  cmakeFlags = [
    "-DSYSCONFDIR=/etc"
    "-DLUA_EXECUTABLE=${pkgs.luajit}/bin/luajit"
  ];

  postInstall = ''
    wrapProgram "$out/bin/awesome" \
      --prefix GI_TYPELIB_PATH : "${giTypeLibPath}"
  '';

  meta = with lib; {
    description = "Highly configurable framework window manager with Lua and LuaJIT";
    homepage = "https://awesomewm.org";
  };
}
