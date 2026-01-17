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
      inputs.antigravity-nix.overlays.default
    ];

    config = {
      allowUnfree = true;
      # allowUnsupportedSystem = true;
      allowUnfreePredicate = _: true;
      allowBroken = true;
      permittedInsecurePackages = [
        "dcraw-9.28.0"
        "electron-24.8.6"
        "electron-25.9.0"
        "electron-27.3.11"
        "freeimage-3.18.0-unstable-2024-04-18"
        "imagemagick-6.9.13-10"
        "openssl-1.1.1v"
        "openssl-1.1.1w"
        "python3.12-youtube-dl-2021.12.17"
        "qtwebengine-5.15.19"
        "qtwebkit-5.212.0-alpha4"
        "ventoy-1.1.07"
        "ventoy-1.1.10"
        "xpdf-4.05"
      ];
    };
  };
}
