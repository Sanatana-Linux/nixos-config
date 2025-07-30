{
  config,
  lib,
  pkgs,
  stdenv,
  ...
}: let
  pname = "betterbird";
  version = "128.10.0esr-bb26";
in
  stdenv.mkDerivation {
    inherit pname version;
    src = pkgs.fetchurl {
      url = "https://www.betterbird.eu/downloads/LinuxArchive/betterbird-${version}.en-US.linux-x86_64.tar.bz2";
      hash = "sha256-ECkdqTz4SIEOaHeL7HB2VJRcfSa7xteuaozMMkeuNL8=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mkdir -p $out/opt
      mkdir -p $out/share/applications

      cp -r . $out/opt/${pname}
      # install -m644 eu.${pname}.Betterbird.desktop $out/share/applications/eu.${pname}.Betterbird.desktop
      ln -s $out/opt/${pname}/betterbird $out/bin/${pname}
      # TODO hunspell
      # Vendor Pref (vendor-prefs.js): pref("spellchecker.dictionary_path", "/usr/share/hunspell");

      for i in 16 22 24 32 48 64 128 256; do
          install -d $out/share/icons/hicolor/''${i}x''${i}/apps/
          ln -s $out/opt/${pname}/chrome/icons/default/default$i.png \
              $out/share/icons/hicolor/''${i}x''${i}/apps/${pname}.png
      done

      runHook postInstall
    '';

    nativeBuildInputs = [pkgs.autoPatchelfHook pkgs.wrapGAppsHook pkgs.pkg-config];

    buildInputs = with pkgs; [
      pkgs.hunspell

      pkgs.alsa-lib
      pkgs.atk
      pkgs.cairo
      pkgs.freetype
      # pot pyfa? (libdbus-1)
      # pot libfontconfig
      pkgs.gtk3
      pkgs.gdk-pixbuf
      pkgs.glib
      pkgs.pango

      pkgs.xorg.libX11
      pkgs.xorg.libxcb
      pkgs.xorg.libXcomposite
      pkgs.xorg.libXcursor
      pkgs.xorg.libXdamage
      pkgs.xorg.libXext
      pkgs.xorg.libXfixes
      pkgs.xorg.libXi
      pkgs.xorg.libXrandr
      pkgs.xorg.libXrender
    ];

    meta = {
      homepage = "https://www.betterbird.eu/";
      description = "Betterbird is a fine-tuned version of Mozilla Thunderbird, Thunderbird on steroids, if you will.";

      platforms = ["x86_64-linux"];
    };
  }
