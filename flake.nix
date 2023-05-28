{
  description = "Rxyhn's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nur.url = "github:nix-community/NUR";
    helix.url = "github:SoraTenshi/helix/experimental-22.12";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    nps = {
      url = "github:OleMussmann/Nix-Package-Search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-forge = {
      type = "git";
      flake = false;
      url = "https://github.com/Thomashighbaugh/nvim-forge.git";
    };
 
 bhairava-grub-theme = {
      #type = "git";
      #url = "https://github.com/Sanatana-Linux/Bhairava-Grub-Theme";
      url = "github:Sanatana-Linux/Bhairava-Grub-Theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    bhairava-grub-theme,
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
      hp-laptop-amd = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs bhairava-grub-theme;};
        modules = [./hosts/hp-laptop-amd];
      };
    };

    homeConfigurations = {
      # Laptop
      "tlh@hp-laptop-amd" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/tlh/hp-laptop-amd];
      };
    };
  };
}
