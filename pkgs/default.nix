pkgs: {
  material-symbols = pkgs.callPackage ./material-symbols {};
  lightdm-webkit-theme-litarvan = pkgs.callPackage ./lightdm-webkit-theme-litarvan.nix {};
  lightdm-webkit-theme-litarvan-sanatana = pkgs.callPackage ./lightdm-webkit-theme-litarvan-sanatana.nix {};
  legion-rgb-control = pkgs.callPackage ./legion-rgb-control {};
  sea-greeter = pkgs.callPackage ./sea-greeter.nix {};
  sea-greeter-configurable = pkgs.callPackage ./sea-greeter-configurable.nix {};
}
