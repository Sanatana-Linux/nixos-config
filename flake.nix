{
  description = "The ShizNix Upon Which I Constantly Nit Pick";

  inputs = {
    stable.url = "github:nixos/nixpkgs/nixos-25.05?shallow=1";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fx-autoconfig = {
      url = "github:MrOtherGuy/fx-autoconfig";
      flake = false;
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nps = {
      url = "github:OleMussmann/Nix-Package-Search";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bhairava-grub-theme = {
      url = "github:Sanatana-Linux/Bhairava-Grub-Theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };
  };

  outputs = {
    self,
    nixpkgs,
    stable,
    home-manager,
    stylix,
    fx-autoconfig,
    bhairava-grub-theme,
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
    packages = forAllSystems (system: import ./pkgs {pkgs = nixpkgs.legacyPackages.${system};});

    # Development Environment for This Project, Most Useful During Fresh Installs
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    checks = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      alejandra =
        pkgs.runCommand "check-formatting" {
          buildInputs = [pkgs.alejandra];
        } ''
          cd ${self}
          alejandra --check . >&2 || (echo "Formatting check failed. Run: alejandra ." >&2; exit 1)
          touch $out
        '';
      eval-all-hosts =
        pkgs.runCommand "eval-all-hosts" {
          buildInputs = [pkgs.nixos-rebuild];
        } ''
          for host in bagalamukhi matangi bhairavi chhinamasta; do
            echo "Evaluating $host..." >&2
            nix-instantiate --eval --strict -E '(import ${self}).nixosConfigurations.''${host}.config.system.build.toplevel' > /dev/null 2>&1 || (
              echo "Evaluation failed for $host" >&2
              exit 1
            )
          done
          touch $out
        '';
    });

    nixosConfigurations = {
      # ┣━━━━━━━━━━━━━━━━━━━━━━┫ My Lenovo Legion 5 Pro ┣━━━━━━━━━━━━━━━━━━━━━━┫

      bagalamukhi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          inputs.sops-nix.nixosModules.sops
          inputs.stylix.nixosModules.stylix
          inputs.nur.modules.nixos.default
          inputs.nixos-hardware.nixosModules.lenovo-legion-16irx9h
          inputs.bhairava-grub-theme.nixosModule
          inputs.nix-index-database.nixosModules.nix-index
          inputs.home-manager.nixosModules.home-manager
          ./modules/nixos
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "bak";
              overwriteBackup = true;
              extraSpecialArgs = {inherit inputs outputs;};
              sharedModules = [
                ./modules/home-manager
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
          inputs.sops-nix.nixosModules.sops
          inputs.stylix.nixosModules.stylix
          inputs.nur.modules.nixos.default
          inputs.nixos-hardware.nixosModules.lenovo-legion-16irx9h
          inputs.bhairava-grub-theme.nixosModule
          inputs.home-manager.nixosModules.home-manager
          ./modules/nixos
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "bak";
              overwriteBackup = true;
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

      bhairavi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          inputs.sops-nix.nixosModules.sops
          inputs.stylix.nixosModules.stylix
          inputs.nur.modules.nixos.default
          inputs.bhairava-grub-theme.nixosModule
          inputs.home-manager.nixosModules.home-manager
          inputs.nixos-generators.nixosModules.all-formats
          ./modules/nixos
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "bak";
              overwriteBackup = true;
              extraSpecialArgs = {inherit inputs outputs;};
              sharedModules = [./modules/home-manager];
              users = {
                tlh = {imports = [./home/tlh/default.nix];};
              };
            };
          }
          ./hosts/bhairavi
        ];
      };

      # ┣━━━━━━━━━━━━━━━━━━━━━┫ NixOS Live USB ┣━━━━━━━━━━━━━━━━━━━━━┫
      chhinamasta = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs self;
          format = "isoImage";
        };
        modules = [
          inputs.sops-nix.nixosModules.sops
          inputs.stylix.nixosModules.stylix
          inputs.nur.modules.nixos.default
          inputs.bhairava-grub-theme.nixosModule
          inputs.home-manager.nixosModules.home-manager
          ./modules/nixos
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "bak";
              overwriteBackup = true;
              extraSpecialArgs = {inherit inputs outputs;};
              sharedModules = [
                ./modules/home-manager
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
