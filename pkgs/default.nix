{pkgs ? import <nixpkgs> {}}: {
  firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme {};
  firefox-alpha-theme = pkgs.callPackage ./firefox-alpha-theme {};
  macos-cursors = pkgs.callPackage ./macos-cursors {};
  material-symbols = pkgs.callPackage ./material-symbols {};
  lightdm-webkit2-greeter = pkgs.callPackage ./lightdm-webkit2-greeter {};
}
