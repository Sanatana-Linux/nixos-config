{
  description = "The Sanatana Linux NixOS Configuration";

  inputs = {
    # SFMono w/ patches
    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-generators.url = "github:nix-community/nixos-generators";
    rust-overlay.url = "github:oxalica/rust-overlay";
    higgs-boson = {
      url = "github:ThomasHighbaugh/firefox";
      flake = false;
    };
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    nps.url = "github:OleMussmann/Nix-Package-Search";

    bhairava-grub-theme = {
      url = "github:Sanatana-Linux/Bhairava-Grub-Theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-master,
    home-manager,
    nixos-hardware,
    bhairava-grub-theme,
    nur,
    chaotic,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forEachSystem = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"];
    forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
  in {
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    overlays = import ./overlays {inherit inputs outputs;};
    packages = forEachPkgs (pkgs: import ./pkgs {inherit pkgs;});
    devShells = forEachPkgs (pkgs: import ./shell.nix {inherit pkgs;});

    nixosConfigurations = {
      # Laptop
      macbook-air = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs nixos-hardware bhairava-grub-theme home-manager;};
        modules = let
          nur-modules = import nur {
            nurpkgs = nixpkgs.legacyPackages.x86_64-linux;
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
          };
        in [
          nixos-hardware.nixosModules.apple-macbook-air-6
          ./hosts/macbook-air
          bhairava-grub-theme.nixosModule
          home-manager.nixosModules.home-manager
          chaotic.nixosModules.default # OUR DEFAULT MODUL
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "bak";
              users.tlh = {imports = [./home/tlh/macbook-air];};
            };
          }
        ];
      };
    };
    homeConfigurations = {
      "tlh@macbook-air" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/tlh/macbook-air];
      };
    };
  };
}
