{pkgs ? import <nixpkgs> {}}: {
  phocus = pkgs.callPackage ./phocus {};
  material-symbols = pkgs.callPackage ./material-symbols {};
  lutgen = pkgs.callPackage ./lutgen {};
  android-messages = pkgs.callPackage ./android-messages {};
}
