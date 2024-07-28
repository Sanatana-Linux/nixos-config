{ lib
, pkgs
, inputs
, outputs
, ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./base
      ./environment
      ./networking
      ./pkgs
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

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
    backupFileExtension = "bak";
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.default
      inputs.nixpkgs-f2k.overlays.stdenvs
      inputs.nur.overlay
    ];

    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
      allowUnfreePredicate = _: true;
      allowBroken = true;
      permittedInsecurePackages = [
        "openssl-1.1.1u"
        "openssl-1.1.1w"
        "nix-2.16.2"
        "openssl-1.1.1v"
        "electron-24.8.6"
        "electron-25.9.0"
        "electron-27.3.11"
        "xpdf-4.03"

      ];
      # firefox = {
      #   enableLegacyUserProfileCustomizations = true;
      # };
    };
  };
}
