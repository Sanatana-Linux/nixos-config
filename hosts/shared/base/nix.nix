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
    "openssl-1.1.1v"
  ];

  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://nix-community.cachix.org?priority=5"
        "https://fortuneteller2k.cachix.org"
        "https://cache.ngi0.nixos.org/"
        "https://nrdxp.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
      ];
      # allow sudo users to mark the following values as trusted
      allowed-users = ["@wheel" "root" "tlh"];
      # only allow sudo users to manage the nix store
      trusted-users = [
        "root"
        "@wheel"
        "tlh"
      ];
      # Allow the store to optimize itself
      auto-optimise-store = true;

      # Useful Features to Have Enabled
      system-features = ["kvm" "recursive-nix" "big-parallel"];
      # Necessary Experimental Nix Features for Flakes and Friends
      experimental-features = ["recursive-nix" "nix-command" "flakes" "repl-flake"];
      flake-registry = "/etc/nix/registry.json";
      # show more log lines for failed builds
      log-lines = 20;
      # Use Binary Cache because we don't want to wait our lives away
      builders-use-substitutes = true;
      # continue building derivations if one fails
      keep-going = true;
      # Garbage Collection will handle this later, but for now keep it around for rebuilds
      keep-derivations = true;
      # Keep Flake Outputs (we will be needing them)
      keep-outputs = true;
      max-jobs = "auto";
      # Turn off that annoying warning from not committing
      warn-dirty = false;
    };

    package = pkgs.nixUnstable;

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };

    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
}
