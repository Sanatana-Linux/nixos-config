{pkgs ? import <nixpkgs> {}}: {
  material-symbols = pkgs.callPackage ./material-symbols {};
}
