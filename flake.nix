{
  description = "The Sanatana Linux is the ShizNix";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/master";
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
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Alejandra formatting
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    # The extra packages and replacements that make this configuration tick
    overlays = import ./overlays {inherit inputs;};
    #
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    devShells = forAllSystems (pkgs: import ./shell.nix {inherit pkgs;});

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

      # ┣━━━━━━━━━━━━━━━━━━━━━━┫ My Lenovo Legion Pro ┣━━━━━━━━━━━━━━━━━━━━━━┫

      bagalamukhi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          nur.modules.nixos.default
          nixos-hardware.nixosModules.lenovo-legion-16irx9h
          ./hosts/bagalamukhi
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
    bagalamukhi = self.nixosConfigurations.bagalamukhi.config.system.build.toplevel;
  };
}
