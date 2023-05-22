{ config, nur, nixpkgs, overlays, inputs, home-manager, nixos-hardware,bhairava-grub-theme, nvim-forge, treefmt,  system
, ... }:

with nixpkgs;

lib.nixosSystem rec {
  inherit system;

  modules = [
    bhairava-grub-theme.nixosModule
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-laptop-ssd
    nur.nixosModules.nur
    ./configuration.nix


    { nixpkgs = { inherit overlays config; }; }

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.users.tlh = { imports = [ ../../users/tlh/home.nix ]; };
    }
  ];
}
