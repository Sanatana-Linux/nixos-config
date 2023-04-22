{ config, nixpkgs, overlays, inputs, home-manager, nixos-hardware, system, ... }:

with nixpkgs;

lib.nixosSystem rec {
  inherit system;
  
  modules = [
    ./configuration.nix
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-laptop-ssd
#    nixos-hardware.nixosModules.common-gpu-amd

    {
      nixpkgs = {
        inherit overlays config;
      };
    }

    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.tlh = {
        imports = [
          ../../users/tlh/home.nix
        ];
      };
    }
  ];
}
