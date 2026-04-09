{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "elegant-sddm";
  version = "unstable-2024-02-08";

  src = fetchFromGitHub {
    owner = "surajmandalcell";
    repo = "elegant-sddm";
    rev = "master";
    sha256 = "sha256-yn0fTYsdZZSOcaYlPCn8BUIWeFIKcTI1oioTWqjYunQ=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/elegant-sddm
    cp -r Elegant/* $out/share/sddm/themes/elegant-sddm/
    
    # Create a proper theme.conf file
    cat > $out/share/sddm/themes/elegant-sddm/theme.conf << EOF
[General]
background=background.jpg
type=image
EOF
  '';

  meta = with lib; {
    description = "Elegant SDDM theme with a clean, modern design";
    homepage = "https://github.com/surajmandalcell/Elegant-sddm";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [];
  };
}