{ pkgs
, inputs
, lib
, config
, ...
}: {
  imports = [ ../../../cachix.nix ];
  documentation = {
    enable = false;
    doc.enable = false;
    man.enable = false;
    dev.enable = false;
  };

  boot.tmp.cleanOnBoot = true;
  # Package Manager Settings
  nix = {
    settings = {
      substituters = [
        "https://cache.ngi0.nixos.org/"
        "https://cache.nixos.org?priority=10"
        "https://emacs.cachix.org"
        "https://fortuneteller2k.cachix.org"
        "https://nix-community.cachix.org"
        "https://nix-node.cachix.org/"
        "https://nixpkgs-unfree.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://nrdxp.cachix.org"
        "https://pre-commit-hooks.cachix.org" # pre commit hooks
      ];

      trusted-public-keys = [
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "emacs.cachix.org-1:b1SMJNLY/mZF6GxQE+eDBeps7WnkT0Po55TAyzwOxTY="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
        "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      ];
      # allow sudo users to mark the following values as trusted
      allowed-users = [ "@wheel" "root" "tlh" ];
      # only allow sudo users to manage the nix store
      trusted-users = [
        "root"
        "@wheel"
        "tlh"
        "smg"
      ];
      # Allow the store to optimize itself
      auto-optimise-store = true;
      # allow broken packages
      allowBroken = true;
      # Free up to 10GiB whenever there is less than 5GB left.
      # this setting is in bytes, so we multiply with 1024 by 3
      # min-free = "${toString (5 * 1024 * 1024 * 1024)}";
      # max-free = "${toString (10 * 1024 * 1024 * 1024)}";

      # Useful/Necessary Features to Have Enabled
      system-features = [ "kvm" "recursive-nix" "big-parallel" "benchmark" "cuda" ];
      # Necessary Experimental Nix Features for Flakes and Friends
      experimental-features = [ "recursive-nix" "auto-allocate-uids" "ca-derivations" "nix-command" "flakes" ];
      flake-registry = "/etc/nix/registry.json";
      # show more log lines for failed builds
      log-lines = 20;
      # Use Binary Cache because we don't want to wait our lives away
      builders-use-substitutes = true;
      # Just use the caches for God's sake
      always-allow-substitutes = true;

      # Relax sandboxing to enable builds outside of chroot
      sandbox = "relaxed";
      # continue building derivations if one fails
      keep-going = true;
      # Garbage Collection will handle this later, but for now keep it around for rebuilds
      keep-derivations = true;
      # Keep Flake Outputs (we will be needing them)
      keep-outputs = true;
      max-jobs = "auto";
      # Turn off that annoying warning from not committing
      warn-dirty = false;
      use-xdg-base-directories = true;
    };


    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };

    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
}
