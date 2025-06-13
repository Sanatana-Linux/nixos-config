{
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./base/default.nix
    ./environment/default.nix
    ./programs/default.nix
    ./hardware/networking.nix
    ./security/default.nix
    ./services/default.nix
  ];

  # Set up everything home-manager related for my user
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs;};
    backupFileExtension = "bak";
  };

  # Overlays and Nixpkgs Settings
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.f2k-packages
      outputs.overlays.chaotic-packages
      inputs.nixpkgs-f2k.overlays.default
      inputs.nur.overlays.default
      inputs.nixpkgs-f2k.overlays.stdenvs
      inputs.nixpkgs-f2k.overlays.compositors
      inputs.nur.overlays.default
      (final: prev: {
        awesome-git = (final.awesome.override {lua = final.luajit;}).overrideAttrs (old: rec
          {
            pname = "awesome-git";
            version = "4.3-master";
            src = final.fetchFromGitHub {
              owner = "awesomeWM";
              repo = "awesome";
              rev = "8b1f8958b46b3e75618bc822d512bb4d449a89aa";
              sha256 = "sha256-ZGZ53IWfQfNU8q/hKexFpb/2mJyqtK5M9t9HrXoEJCg=";
              fetchSubmodules = false;
            };
            patches = [];

            # this is the real magic. awesome won't build without this
            postPatch = ''
              patchShebangs tests/examples/_postprocess.lua
              patchShebangs tests/examples/_postprocess_cleanup.lua
            '';
          });
      })
    ];

    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
      allowUnfreePredicate = _: true;
      allowBroken = true;
      permittedInsecurePackages = [
        "dcraw-9.28.0"
        "electron-24.8.6"
        "electron-25.9.0"
        "electron-27.3.11"
        "freeimage-3.18.0-unstable-2024-04-18"
        "freeimage-unstable-2021-11-01"
        "imagemagick-6.9.13-10"
        "nix-2.16.2"
        "openssl-1.1.1v"
        "openssl-1.1.1w"
        "python3.12-youtube-dl-2021.12.17"
        "ventoy-1.1.05"
        "xpdf-4.05"
      ];
    };
  };
}
