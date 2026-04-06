pkgs: {
  material-symbols = pkgs.callPackage ./material-symbols {};
  skeuos-gtk = pkgs.callPackage ./skeuos-gtk.nix {};
  legion-rgb-control = pkgs.callPackage ./legion-rgb-control {};
  elegant-sddm = pkgs.callPackage ./elegant-sddm.nix {};
  lightdm-webkit-theme-litarvan = pkgs.callPackage ./lightdm-webkit-theme-litarvan.nix {};
  various-nature-images = pkgs.callPackage ./various-nature-images.nix {};
  sea-greeter = pkgs.callPackage ./sea-greeter.nix {};
  sea-greeter-litarvan = pkgs.callPackage ./sea-greeter-litarvan.nix {};
}
