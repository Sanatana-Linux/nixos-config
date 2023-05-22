{
  description = "The Sanatana Linux, the NixOS configuration of Thomas Leon Highbaugh";

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
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell.url = "github:numtide/devshell";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-generators.url = "github:nix-community/nixos-generators";

    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    nur.url = "github:nix-community/NUR";

    nil.url = "github:oxalica/nil";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nps = {
      url = "github:OleMussmann/Nix-Package-Search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    luaFormatter = {
      type = "git";
      url = "https://github.com/Koihik/LuaFormatter.git";
      submodules = true;
      flake = false;
    };
    # my configurations
    bhairava-grub-theme = {
      #type = "git";
      #url = "https://github.com/Sanatana-Linux/Bhairava-Grub-Theme";
      url = "github:Sanatana-Linux/Bhairava-Grub-Theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-forge = {
      type = "git";
      flake = false;
      url = "https://github.com/Thomashighbaugh/nvim-forge.git";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    nvim-forge,
    home-manager,
    nixpkgs-f2k,
    luaFormatter,
    nps,
    devshell,
    nixos-hardware,
    bhairava-grub-theme,
    treefmt,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    system = "x86_64-linux";

    # pkgs = nixpkgs.legacyPackages.${system};
    #pkgs = import nixpkgs { inherit system; };
    config = {
      system = system;
      allowUnfree = true;
      allowUnsupportedSystem = true;
      allowBroken = true;
    };

    lib = nixpkgs.lib;
    nur-modules = import nur {
      nurpkgs = nixpkgs.legacyPackages.x86_64-linux;
      pkgs = nixpkgs.legacyPackages.x86_64-linux {inherit system;};
    };

    overlays = with inputs; [
      nixpkgs-f2k.overlays.default
      (final: prev: let
        inherit (final) system;
      in {
        awesome = prev.awesome-git;

        picom = prev.picom-git;

        nps = inputs.nps.defaultPackage.${prev.system};
      })

      nur.overlay
    ];
  in {
    nixosConfigurations = {
      hp-laptop-amd = import ./hosts/hp-laptop-amd {
        inherit
          config
          nixpkgs
          overlays
          lib
          inputs
          system
          home-manager
          nur
          bhairava-grub-theme
          nvim-forge
          nixos-hardware
          treefmt
          ;
      };
      live-usb = import ./hosts/live-usb {
        inherit config nixpkgs overlays lib inputs system home-manager;
        format = "isoImage";
      };
    };
  };
}
