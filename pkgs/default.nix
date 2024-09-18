{pkgs ? import <nixpkgs> {}}: {
  firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme {};
  phocus = pkgs.callPackage ./phocus {};
  material-symbols = pkgs.callPackage ./material-symbols {};
  lutgen = pkgs.callPackage ./lutgen {};
  imagecolorizer = pkgs.callPackage ./imagecolorizer {};
}
