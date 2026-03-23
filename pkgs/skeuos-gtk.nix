{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk-engine-murrine,
  sassc,
  glib,
  inkscape,
  optipng,
}:
stdenv.mkDerivation rec {
  pname = "skeuos-gtk";
  version = "2022-09-29";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = "skeuos-gtk";
    rev = "095e06aa44c637af675850e421057c6f09b9f8d0";
    sha256 = "0rwhbv4n1lfzz5cwq2qw73vqzzv61l1zz7cbb45jjvgrsi3ynxfl";
  };

  nativeBuildInputs = [
    sassc
    glib
    inkscape
    optipng
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  patches = [
    ./skeuos-theme-colors.patch
  ];

  enableParallelBuilding = true;

  buildPhase = ''
    make build
  '';

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a themes/* $out/share/themes
  '';

  meta = with lib; {
    description = "Skeuos GTK Theme";
    homepage = "https://github.com/daniruiz/skeuos-gtk";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
