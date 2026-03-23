{pkgs ? import <nixpkgs> {overlays = [(import ./overlay.nix)];}}:
with pkgs;
  mkShell {
    buildInputs = [
      (perl.withPackages (ps:
        with ps; [
          Test2Suite
          #TestLib
          PLS # Language server
        ]))
    ];
  }
