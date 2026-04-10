{
  description = "The ShizNix Upon Which I Constantly Nit Pick";

  inputs = {
    stable.url = "github:nixos/nixpkgs/nixos-25.05?shallow=1";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-generators.url = "github:nix-community/nixos-generators";
    rust-overlay.url = "github:oxalica/rust-overlay";
    higgs-boson = {
      url = "github:ThomasHighbaugh/firefox";
      flake = false;
    };
    fx-autoconfig = {
      url = "github:MrOtherGuy/fx-autoconfig";
      flake = false;
    };
    lemonake.url = "github:passivelemon/lemonake";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nps.url = "github:OleMussmann/Nix-Package-Search";
    bhairava-grub-theme = {
      url = "github:Sanatana-Linux/Bhairava-Grub-Theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    panchakosha = {
      url = "github:Sanatana-Linux/PanchaKosha";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    cachy-tweaks = {
      url = "github:AniviaFlome/cachy-tweaks-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    stable,
    home-manager,
    stylix,
    higgs-boson,
    fx-autoconfig,
    bhairava-grub-theme,
    panchakosha,
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
    # Flake Templates Easing the  Development Process and Taking Advantage of Nix in It
    templates = import ./templates;
    # Packages themselves
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Development Environment for This Project, Most Useful During Fresh Installs
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    nixosConfigurations = {

      # ┣━━━━━━━━━━━━━━━━━━━━━━┫ My Lenovo Legion 5 Pro ┣━━━━━━━━━━━━━━━━━━━━━━┫

      bagalamukhi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          inputs.stylix.nixosModules.stylix
          inputs.nur.modules.nixos.default
          inputs.nixos-hardware.nixosModules.lenovo-legion-16irx9h
          inputs.bhairava-grub-theme.nixosModule
          inputs.chaotic.nixosModules.default
          inputs.nix-index-database.nixosModules.nix-index
          inputs.home-manager.nixosModules.home-manager
          inputs.panchakosha.nixosModules.default
          ./modules/nixos
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "bak";
              extraSpecialArgs = {inherit inputs outputs;};
              sharedModules = [
                ./modules/home-manager
                inputs.panchakosha.homeManagerModules.default
              ];
              users = {
                tlh = {imports = [./home/tlh/default.nix];};
              };
            };
          }
          ./hosts/bagalamukhi
        ];
      };
      # ┣━━━━━━━━━━━━━━━━━━┫ Sara's Lenovo Legion Pro ┣━━━━━━━━━━━━━━━━┫
      matangi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          inputs.stylix.nixosModules.stylix
          inputs.nur.modules.nixos.default
          inputs.nixos-hardware.nixosModules.lenovo-legion-16irx9h
          inputs.bhairava-grub-theme.nixosModule
          inputs.chaotic.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          ./modules/nixos
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "bak";
              extraSpecialArgs = {inherit inputs outputs;};
              sharedModules = [./modules/home-manager];
              users = {
                smg = {imports = [./home/smg/default.nix];};
              };
            };
          }
          ./hosts/matangi
        ];
      };

      # ┣━━━━━━━━━━━━━━━━━━━━━┫ NixOS Live USB ┣━━━━━━━━━━━━━━━━━━━━━┫
      chhinamasta = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs self;
          format = "isoImage";
        };
        modules = [
          inputs.stylix.nixosModules.stylix
          inputs.nur.modules.nixos.default
          inputs.bhairava-grub-theme.nixosModule
          inputs.home-manager.nixosModules.home-manager
          inputs.panchakosha.nixosModules.default
          ./modules/nixos
          {
            home-manager = {
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs outputs;};
              sharedModules = [
                ./modules/home-manager
                inputs.panchakosha.homeManagerModules.default
              ];
              users.user = {imports = [./home/user/default.nix];};
            };
          }
          ./hosts/chhinamasta
        ];
      };
    };
    # ┣━━━━━━━━━━━━━━━━━━━━━┫ Home Configurations ┣━━━━━━━━━━━━━━━━━━━━━┫
    homeConfigurations = {
      tlh = inputs.home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs self;};
        modules = [
          ./home/tlh/default.nix
        ];
      };
      smg = inputs.home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs self;};
        modules = [
          ./home/smg/default.nix
        ];
      };
    };
    # ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
  };
}
