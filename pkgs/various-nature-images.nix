{ lib, stdenv, fetchzip, unzip }:

stdenv.mkDerivation rec {
  pname = "various-nature-images";
  version = "1.0";

  src = fetchzip {
    url = "https://archive.org/download/various-nature-images-zip/Various%20Nature%20Images%20%28zip%29.zip";
    hash = "sha256-301B51cxNX83FRahiqvd7AgOxGAbs8ST9CFju52Od4s=";
    stripRoot = false;
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    # Create the final output directory.
    mkdir -p $out

    find . -name "*.zip" -exec unzip -n {} -d $out \;

    rm -rf $out/__MACOSX

    runHook postInstall
  '';

  meta = with lib; {
    description = "A collection of nature images from archive.org, flattened into a single directory";
    homepage = "https://archive.org/details/various-nature-images-zip";
    license = licenses.publicDomain;
    platforms = platforms.linux;
  };
}