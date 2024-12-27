{pkgs ? import <nixpkgs> {}}: {
  phocus = pkgs.callPackage ./phocus {};
  material-symbols = pkgs.callPackage ./material-symbols {};
  android-messages = pkgs.callPackage ./android-messages {};
  magnetic-gtk-theme = pkgs.callPackage ./magnetic-gtk-theme {};
}
