{ lib, fetchFromGitHub, buildNpmPackage }:

buildNpmPackage rec {
  pname = "lightdm-webkit-theme-litarvan";
  version = "unstable-2023-03-10";

  src = fetchFromGitHub {
    owner = "dragonfly1033";
    repo = "lightdm-webkit-theme-litarvan";
    rev = "e4e977239156f415a8e1c511317bcf73cfb4015f";
    hash = "sha256-03ttvg+w2Ikh/FfX0fgeL/KTy+C2DRaBXMwfMB+cppw=";
  };

  npmDepsHash = "sha256-+gaS/8Dr35lMKqfH9NKlCgJTpaqA0AlWS3Cx5TNrWyk=";

  installPhase = ''
    runHook preInstall
    install -d $out
    cp -r dist/* $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Litarvan's LightDM HTML Theme";
    homepage = "https://github.com/dragonfly1033/lightdm-webkit-theme-litarvan";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}