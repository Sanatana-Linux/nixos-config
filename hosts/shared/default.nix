{
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./base
      ./environment
      ./networking
      ./programs
      ./security
      ./services
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  # Systemd OOMd
  # Fedora enables these options by default. See the 10-oomd-* files here:
  # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
  systemd.oomd = {
    enableRootSlice = true;
    enableUserSlices = true;
  };
  # Keeping these below their buddy in systemd
  services.irqbalance.enable = true;
  services.earlyoom.enable = true;
  # Set up everything home-manager related for my user
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs;};
    backupFileExtension = "bak";
  };

  # Overlays and Nixpkgs Settings
  nixpkgs = {
    overlays = [
      outputs.overlays.default
      inputs.nixpkgs-f2k.overlays.default
      inputs.nur.overlays.default
    ];

    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
      allowUnfreePredicate = _: true;
      allowBroken = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
        "dcraw-9.28.0"
        "imagemagick-6.9.13-10"
        "nix-2.16.2"
        "openssl-1.1.1v"
        "python3.12-youtube-dl-2021.12.17"
        "electron-24.8.6"
        "electron-25.9.0"
        "electron-27.3.11"
        "xpdf-4.05"
      ];
    };
  };
}
