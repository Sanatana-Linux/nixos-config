{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "Python";

  buildInputs = [
    # add version number probably
    (pkgs.python3.withPackages (ps: [
   #   ps.numpy
    ]))
  ];
}