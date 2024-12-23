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
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
    firefox-nightly.url = "github:nix-community/flake-firefox-nightly";
    nps.url = "github:OleMussmann/Nix-Package-Search";
    bhairava-grub-theme = {
      url = "github:Sanatana-Linux/Bhairava-Grub-Theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nsearch = {
  url = "github:niksingh710/nsearch";
  inputs.nixpkgs.follows = "nixpkgs";
};
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    nixos-generators,
    neovim-nightly-overlay,
    bhairava-grub-theme,
    nur,
    chaotic,
    nsearch,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forEachSystem = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"]; # when needed add "aarch64-linux"
    forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
  in {
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    overlays = import ./overlays {inherit inputs outputs;};
    packages = forEachPkgs (pkgs: import ./pkgs {inherit pkgs;});
    devShells = forEachPkgs (pkgs: import ./shell.nix {inherit pkgs;});

    nixosConfigurations = {
      # ┣━━━━━━━━━━━━━━━━━━━━━━━┫ Dinosaur Laptop ┣━━━━━━━━━━━━━━━━━━━━━━━┫

      macbook-air = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          nur.modules.nixos.default

          nixos-hardware.nixosModules.apple-macbook-air-6
          ./hosts/macbook-air
          bhairava-grub-theme.nixosModule
          home-manager.nixosModules.home-manager
          chaotic.nixosModules.default
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "bak";
              users.tlh = {imports = [./home/tlh/default.nix];};
            };
          }
        ];
      };

      # ┣━━━━━━━━━━━━━━━━━━━━━━┫ Lenovo Legion Pro ┣━━━━━━━━━━━━━━━━━━━━━━┫

      romulus = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          nur.modules.nixos.default
          nixos-hardware.nixosModules.lenovo-legion-16irx9h
          ./hosts/romulus
          bhairava-grub-theme.nixosModule
          home-manager.nixosModules.home-manager
          chaotic.nixosModules.default
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "bak";
              users = {
                  tlh = {imports = [./home/tlh/default.nix];};
                };
            };
          }
        ];
      };
    
    




    homeConfigurations = {
      tlh = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs self;};
        modules = [
          ./home/tlh/default.nix
        ];
      };
      smg = inputs.home-manager.lib.homeManagerConfiguration {
       pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
       extraSpecialArgs = {inherit inputs outputs self ;};
       modules = [
         ./home/smg/default.nix
	 ];
	     };
	};



# ┣━━━━━━━━━━━━━━━━━━┫ Sara's Lenovo Legion Pro ┣━━━━━━━━━━━━━━━━┫
 remus = nixpkgs.lib.nixosSystem {
       specialArgs = {inherit inputs outputs self;};
       modules = [
         nur.modules.nixos.default
         nixos-hardware.nixosModules.lenovo-legion-16irx9h
         ./hosts/remus
         bhairava-grub-theme.nixosModule
         home-manager.nixosModules.home-manager
         chaotic.nixosModules.default
         {
           home-manager = {
             useUserPackages = true;
             backupFileExtension = "bak";
             users = {
                 smg = {imports = [./home/smg/default.nix];};
               };
           };
         }
       ];
     };
   };



    
    # ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫

    macbook-air = self.nixosConfigurations.macbook-air.config.system.build.toplevel;
    remus = self.nixosConfigurations.remus.config.system.build.toplevel;
    romulus = self.nixosConfigurations.romulus.config.system.build.toplevel;
  };
}
