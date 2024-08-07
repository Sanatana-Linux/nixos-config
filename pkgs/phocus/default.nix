{
  stdenvNoCC,
  fetchFromGitHub,
  nodePackages,
}:
stdenvNoCC.mkDerivation rec {
  pname = "phocus";
  version = "";

  src = fetchFromGitHub {
    owner = "phocus";
    repo = "gtk";
    rev = version;
    sha256 = "";
  };

  patches = [
    ./patches/npm.diff
    ./patches/gradients.diff
    ./patches/substitute.diff
  ];

  postPatch = ''
    substituteInPlace scss/gtk-3.0/_colors.scss \
      --replace "@bg0@" "#15141a" \
      --replace "@bg1@" "#222222" \
      --replace "@bg2@" "#2c2B2D"\
      --replace "@bg3@" "#313032" \
      --replace "@bg4@" "#525053" \
      --replace "@red@" "#fc618d" \
      --replace "@lred@" "#f92672" \
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

  nativeBuildInputs = [nodePackages.sass];
  installFlags = ["DESTDIR=$(out)" "PREFIX="];
}
