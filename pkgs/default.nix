pkgs: {
  material-symbols = pkgs.callPackage ./material-symbols {};
  skeuos-gtk = pkgs.callPackage ./skeuos-gtk.nix {};
  legion-rgb-control = pkgs.callPackage ./legion-rgb-control {};
  lightdm-webkit-theme-litarvan-sanatana = pkgs.callPackage ./lightdm-webkit-theme-litarvan-sanatana.nix {};
  sea-greeter = pkgs.callPackage ./sea-greeter.nix {};
  sea-greeter-configurable = pkgs.callPackage ./sea-greeter-configurable.nix {};
  honor-icon-theme = pkgs.callPackage ./honor-icon-theme.nix {};
}
