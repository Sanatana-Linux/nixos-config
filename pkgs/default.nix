{pkgs ? import <nixpkgs> {}}: {
  firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme {};
  #floorp = pkgs.callPackage ./floorp {};
  macos-cursors = pkgs.callPackage ./macos-cursors {};
  material-symbols = pkgs.callPackage ./material-symbols {};
  lightdm-webkit2-greeter = pkgs.callPackage ./lightdm-webkit2-greeter {};
}
