{pkgs, inputs}: {
  material-symbols = pkgs.callPackage ./material-symbols {};
  lightdm-webkit-theme-litarvan = pkgs.callPackage ./lightdm-webkit-theme-litarvan.nix {};
  lightdm-webkit-theme-litarvan-sanatana = pkgs.callPackage ./lightdm-webkit-theme-litarvan-sanatana.nix {};
  legion-rgb-control = pkgs.callPackage ./legion-rgb-control {};
  legion-kb-rgb = pkgs.callPackage ./legion-kb-rgb {};
  sea-greeter = pkgs.callPackage ./sea-greeter.nix {};
  sea-greeter-configurable = pkgs.callPackage ./sea-greeter-configurable.nix {};
  lightdm-webkit2-sanatana = pkgs.callPackage ./lightdm-webkit2-sanatana.nix {
    src = inputs.lightdm-webkit2-sanatana;
  };
}
