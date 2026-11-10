{
  lib,
  pkgs,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "pypeek";
  version = "2.10.11";

  src = fetchFromGitHub {
    owner = "firatkiral";
    repo = "pypeek";
    rev = "v${version}";
    hash = "sha256-PBtwZhYx9opnyTnDtKzbbya+KoMjEXzayH54Sw0DOc4=";
  };

  pyproject = true;

  nativeBuildInputs = [python3Packages.hatchling];

  propagatedBuildInputs = [python3Packages.pyside6 python3Packages.requests];

  doCheck = false;

  meta = with lib; {
    description = "Cross platform screen recorder with annotation features";
    homepage = "https://github.com/firatkiral/pypeek";
    license = licenses.gpl3;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
