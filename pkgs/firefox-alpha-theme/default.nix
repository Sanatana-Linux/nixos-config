{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "firefox-alpha-theme";
  version = "1.1.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "Tagggar";
    rev = "v${version}";
    sha256 = "sha256-rya++c5XcejAbXJLLd5WM0vnv8Kq8zuhCXPK/+/QxcA=";
  };

  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/share/firefox-alpha-theme
    cp -r $src/* $out/share/firefox-alpha-theme
  '';

  meta = with lib; {
    description = "A GNOME theme for Firefox";
    homepage = "https://github.com/Tagggar/Firefox-Alpha";
    license = licenses.unlicense;
  };
}
