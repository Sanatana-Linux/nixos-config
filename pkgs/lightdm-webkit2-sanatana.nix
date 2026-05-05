{
  lib,
  stdenv,
  src,
}:
stdenv.mkDerivation rec {
  pname = "lightdm-webkit2-sanatana";
  version = "unstable-2026-05-05";

  inherit src;

  installPhase = ''
    runHook preInstall

    install -d $out
    cp -r ./* $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sanatana glassmorphism LightDM web greeter theme for sea-greeter";
    homepage = "https://github.com/Sanatana-Linux/lightdm-webkit2-sanatana";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [];
  };
}
