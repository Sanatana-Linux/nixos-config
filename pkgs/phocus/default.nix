{ stdenvNoCC
, fetchFromGitHub
, nodePackages
,
}:
stdenvNoCC.mkDerivation rec {
  pname = "phocus";
  version = "0cf0eb35a927bffcb797db8a074ce240823d92de";

  src = fetchFromGitHub {
    owner = "phocus";
    repo = "gtk";
    rev = version;
    sha256 = "sha256-URuoDJVRQ05S+u7mkz1EN5HWquhTC4OqY8MqAbl0crk=";
  };

  patches = [
    ./patches/npm.diff
    ./patches/gradients.diff
    ./patches/substitute.diff
  ];

  postPatch = ''
    substituteInPlace scss/gtk-3.0/_colors.scss \
      --replace "@bg0@" "#181818" \
      --replace "@bg1@" "#222222" \
      --replace "@bg2@" "#2c2B2D"\
      --replace "@bg3@" "#313032" \
      --replace "@bg4@" "#444547" \
      --replace "@red@" "#fcb18d" \
      --replace "@lred@" "#d8557b" \
      --replace "@orange@" "#fd9353" \
      --replace "@lorange@" "#da804b" \
      --replace "@yellow@" "#fce566" \
      --replace "@lyellow@" "#d9c65b" \
      --replace "@green@" "#7bd88f" \
      --replace "@lgreen@" "#6fbe81" \
      --replace "@cyan@" "#5ad4e6" \
      --replace "@lcyan@" "#53bbcc" \
      --replace "@blue@" "#6ab0f3" \
      --replace "@lblue@" "#4a9cec" \
      --replace "@purple@" "#948ae3" \
      --replace "@lpurple@" "#8179c6" \
      --replace "@pink@" "#edaec0" \
      --replace "@lpink@" "#edaec0" \
      --replace "@primary@" "#fbf8ff" \
      --replace "@secondary@" "#dcd8e1"
  '';

  nativeBuildInputs = [ nodePackages.sass ];
  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];
}
