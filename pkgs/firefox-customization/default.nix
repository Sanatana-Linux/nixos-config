{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "higgs-boson";
  version = "1.0.0.0";

  src = fetchFromGitHub {
    owner = "Thomashighbaugh";
    repo = "firefox";
    rev = "1a5115f4cc23ca9fde58b7224cf37482b1d0e940";
    sha256 = "sha256-O6C4t2ZaifGjHRmdZtnOAe5E/Q7Qpbkc7NelH/YMBAk=";
  };
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/share/higgs-boson
    cp -r $src/* $out/share/higgs-boson
    cp -r $src/patches/root/* ${pkgs.firefox}/share/firefox
  '';

  meta = with lib; {
    description = "A personalized Firefox modification featuring userchrome.js";
    homepage = "https://github.com/Thomashighbaugh/firefox";
    license = licenses.unlicense;
  };
}
