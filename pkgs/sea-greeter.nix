{
  stdenv,
  pkgs,
}:
stdenv.mkDerivation {
  pname = "sea-greeter";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "JezerM";
    repo = "sea-greeter";
    rev = "ffd2f3c52601127a46d478cd2cd4a9e03719c73f";
    sha256 = "1q58nzksa1hbradb2z01kgljbb3fa1pv535b5xk4b84l1nw5qgp4";
  };

  nativeBuildInputs = [pkgs.meson pkgs.ninja pkgs.typescript pkgs.gcc pkgs.pkg-config];
  buildInputs = with pkgs; [
    gtk3
    webkitgtk
    libyaml
    glib
    lightdm
  ];
}
