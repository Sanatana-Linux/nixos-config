{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cargo-make,
  pkg-config,
  glib,
  vcpkg,
  libclang,
  xorg,
  libusb1,
  nasm,
  dbus,
  udev,
  gst_all_1,
  libvpx,
  libyuv,
  zstd,
}:
rustPlatform.buildRustPackage rec {
  pname = "legion-rgb-control";
  version = "0.19.6";

  src = fetchFromGitHub {
    owner = "4JX";
    repo = "L5P-Keyboard-RGB";
    rev = "v${version}";
    hash = "sha256-2swfHuiEKS0J+R170iVxZFjoyFDIQFVfQHywYDzIOP8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "confy-0.4.0-2" = "sha256-vHdXdJlAK7l+Gsp7W2/OpJz9KKD9PYx6AGONDuqtsZw=";
      "hbb_common-0.1.0" = "sha256-XdQjolgAIQI7EtDAMDSolDnCpNmFimLNZpsORmn82yc=";
      "photon-rs-0.3.2" = "sha256-u+1NR52BgSSFd/rxDGxHvcF5NVVcvA1XGpOqKuV23OI=";
      "tokio-socks-0.5.1-2" = "sha256-x3aFJKo0XLaCGkZLtG9GYA+A/cGGedVZ8gOztWiYVUY=";
    };
  };

  nativeBuildInputs = [
    cargo-make
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  env = {
    VCPKG_ROOT = "/homeless-shelter";
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  buildInputs = [
    xorg.libxshmfence
    xorg.xcbutil
    xorg.libX11
    xorg.libXrandr
    xorg.libXi
    xorg.libXtst
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    nasm
    libusb1
    dbus
    udev
    libclang
    glib
    vcpkg
    libvpx
    libyuv
    zstd
  ];

  buildPhase = ''
    runHook preBuild
    cargo make build-release
    runHook postBuild
  '';

  meta = with lib; {
    description = "Cross platform software to control the RGB/lighting of the 4 zone keyboard included in the 2020, 2021, 2022 and 2023 lineup of the Lenovo Legion laptops";
    homepage = "https://github.com/4JX/L5P-Keyboard-RGB";
    license = licenses.gpl3;
    mainProgram = "legion-rgb-control";
  };
}
