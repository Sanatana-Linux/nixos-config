{
  description = "The Sanatana Linux is the ShizNix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
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
    stable-diffusion-webui-nix = {
      url = "github:Janrupf/stable-diffusion-webui-nix/main";
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
      extra-substituters = [
        "https://cache.nixos.org?priority=10" # nixos cache
        "https://fortuneteller2k.cachix.org" # f2k's cache
        "https://nix-community.cachix.org" # community cache
        "https://nixpkgs-unfree.cachix.org" # nixpkgs-unfree
        "https://pre-commit-hooks.cachix.org" # pre commit hooks
        "https://cuda-maintainers.cachix.org" # cuda maintainers
        "https://sanatanalinux.cachix.org" # my cache
      ];
      extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "sanatanalinux.cachix.org-1:9WsJYECJ+Lt0HPTUI7+6f9uAaAUouaBUyTd9iAJbUEY="
      ];
      # ┣━━━━━━━━━━━━━━━━━━━━━━━┫ Dinosaur Laptop ┣━━━━━━━━━━━━━━━━━━━━━━━┫

      macbook-air = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs self;};
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
          chaotic.nixosModules.default
          home-manager.nixosModules.home-manager
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
      matangi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          nur.modules.nixos.default
          nixos-hardware.nixosModules.lenovo-legion-16irx9h
          ./hosts/matangi
          bhairava-grub-theme.nixosModule
          chaotic.nixosModules.default
          home-manager.nixosModules.home-manager
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

    macbook-air = self.nixosConfigurations.macbook-air.config.system.build.toplevel;
    matangi = self.nixosConfigurations.remus.config.system.build.toplevel;
    bagalamukhi = self.nixosConfigurations.bagalamukhi.config.system.build.toplevel;
  };
}
