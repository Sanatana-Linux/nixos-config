{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1t"
  ];

  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://nix-community.cachix.org?priority=5"
        "https://fortuneteller2k.cachix.org"
        "https://nrdxp.cachix.org"
        "https://cache.ngi0.nixos.org/"
        "https://nixpkgs-wayland.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];

      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      flake-registry = "/etc/nix/registry.json";
      keep-derivations = true;
      keep-outputs = true;
      max-jobs = "auto";
      warn-dirty = false;
    };

    package = pkgs.nixUnstable;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
}
