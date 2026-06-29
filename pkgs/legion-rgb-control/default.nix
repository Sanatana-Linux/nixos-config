{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchzip,
  zip,
  unzip,
  glib,
  dbus,
  libusb1,
  gtk3,
  xorg,
  gst_all_1,
}:
stdenv.mkDerivation rec {
  pname = "legion-rgb-control";
  version = "0.20.8";

  src = fetchzip {
    url = "https://github.com/4JX/L5P-Keyboard-RGB/releases/download/v${version}/legion-kb-rgb-linux.zip";
    hash = "sha256-4MqK4I2RJv2Kj8brg4trRt+3Q9pbgYhPqM5ya/dFrJM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  buildInputs = [
    glib
    dbus
    libusb1
    gtk3
    xorg.libxcb
    xorg.libX11
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 legion-kb-rgb $out/bin/legion-rgb-control
    runHook postInstall
  '';

  meta = {
    description = "Control the RGB lighting of Lenovo Legion laptop keyboards";
    homepage = "https://github.com/4JX/L5P-Keyboard-RGB";
    license = [lib.licenses.gpl3];
    mainProgram = "legion-rgb-control";
    platforms = lib.platforms.linux;
  };
}
