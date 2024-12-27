{pkgs ? import <nixpkgs> {}}: {
  material-symbols = pkgs.callPackage ./material-symbols {};
  magnetic-gtk-theme = pkgs.callPackage ./magnetic-gtk-theme {};
}
