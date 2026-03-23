#https://codeberg.org/xlambein/nixos/src/branch/main/pkgs/youtube2webpage.nix#
{
  fetchFromGitHub,
  ffmpeg,
  lib,
  perl,
  stdenv,
  yt-dlp,
}:
stdenv.mkDerivation {
  pname = "Youtube2Webpage";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "obra";
    repo = "Youtube2Webpage";
    rev = "f80aa839119861d67ab276e6f5b473b3ae2963e3";
    sha256 = "sha256-tvS96O/hNe4ZpiilW4UJStFLsVrCIrRo92ZKVIbe63c=";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/{bin,opt}
    cp styles.css $out/opt
    cp yt-to-webpage.pl $out/bin/youtube2webpage

    substituteInPlace $out/bin/youtube2webpage \
      --replace "/usr/bin/perl" "${perl}/bin/perl" \
      --replace "ffmpeg" "${ffmpeg}/bin/ffmpeg" \
      --replace "yt-dlp" "${yt-dlp}/bin/yt-dlp" \
      --replace "../styles.css" "$out/opt/styles.css"
  '';

  meta = with lib; {
    homepage = "https://github.com/obra/Youtube2Webpage";
    description = "I learn much better from text than from videos";
    maintainers = with maintainers; [xlambein];
  };
}
