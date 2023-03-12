{
  description = "A glowing, radioactive nixos config.";

  nixConfig.extra-substituters = [
    "https://nix-community.cachix.org"
    "https://emacs.cachix.org"
    "https://nrdxp.cachix.org"
  ];

  nixConfig.extra-trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "emacs.cachix.org-1:b1SMJNLY/mZF6GxQE+eDBeps7WnkT0Po55TAyzwOxTY="
    "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
  ];
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-generators.url = "github:nix-community/nixos-generators";

    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    nur.url = "github:nix-community/NUR";

    nil.url = "github:oxalica/nil";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    luaFormatter = {
      type = "git";
      url = "https://github.com/Koihik/LuaFormatter.git";
      submodules = true;
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-f2k, luaFormatter
    , nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

      config = {
        system = system;
        allowUnfree = true;
        allowUnsupportedSystem = true;
        allowBroken = true;
      };

      lib = nixpkgs.lib;

      overlays = with inputs; [
        (final: _:
          let inherit (final) system;
          in { } // (with nixpkgs-f2k.packages.${system}; {
            awesome = awesome-git;
            picom = picom-git;
          }) // {
            luaFormatter-src = luaFormatter;
          })
        (final: prev: {
          luaFormatter = prev.callPackage ./pkgs/luaFormatter.nix {
            src = prev.luaFormatter-src;
            version = "999-master";
          };
        })
        nixpkgs-f2k.overlays.default
        nur.overlay
      ];
    in {
      nixosConfigurations = {
        hp-laptop-amd = import ./hosts/hp-laptop-amd {
          inherit config nixpkgs overlays lib inputs system home-manager;
        };
        live-usb = import ./hosts/live-usb {
          inherit config nixpkgs overlays lib inputs system home-manager;
          format = "isoImage";
        };
      };
    };
}
