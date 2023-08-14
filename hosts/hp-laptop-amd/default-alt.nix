{
  config,
  nur,
  nixpkgs,
  overlays,
  inputs,
  home-manager,
  nixos-hardware,
  bhairava-grub-theme,
  system,
  ...
}:
with nixpkgs;
  lib.nixosSystem rec {
    inherit system;

    specialArgs = {inherit inputs outputs bhairava-grub-theme home-manager;};
    modules = let
      nur-modules = import nur {
        nurpkgs = nixpkgs.legacyPackages.x86_64-linux;
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
    in [
      {imports = [nur-modules.repos.kira-bruneau.modules.lightdm-webkit2-greeter];}
      bhairava-grub-theme.nixosModule
      nixos-hardware.nixosModules.common-cpu-amd
      nixos-hardware.nixosModules.common-pc-laptop-ssd
      nur.nixosModules.nur
      ./configuration.nix

      {nixpkgs = {inherit overlays config;};}

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "bak";
        home-manager.users.tlh = {imports = [./home/tlh/hp-laptop-amd];};
      }
    ];
  }
