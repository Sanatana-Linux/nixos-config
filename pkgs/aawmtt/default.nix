{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "aawmtt";
  version = "2.4";

  src = fetchFromGitHub {
    repo = pname;
    owner = "Curve";
    rev = "v${version}";
    sha256 = "sha256-72434f06d5f3c3883e9150a92296dcc43d360d81e5765d1e9735bcd9d3550787 ";
  };

  dontConfigure = true;
  dontBuild = false;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/share/aawmtt

    mkdir $src/build && cd $src/build
    cmake .. && cmake --build . --config Release
  '';

  meta = with lib; {
    description = "AwesomeWM Configuration and Testing Tool Written in C++20";
    homepage = "https://github.com/Curve/aawmtt";
    license = licenses.unlicense;
  };
}
