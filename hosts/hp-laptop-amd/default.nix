{ config, nur, nixpkgs, overlays, inputs, home-manager, nixos-hardware,bhairava-grub-theme,  system
, ... }:

with nixpkgs;

lib.nixosSystem rec {
  inherit system;

  modules = [
    bhairava-grub-theme.nixosModules
    
    nur.nixosModules.nur
    ./configuration.nix
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-laptop-ssd

    { nixpkgs = { inherit overlays config; }; }

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.tlh = { imports = [ ../../users/tlh/home.nix ]; };
    }
  ];
}
