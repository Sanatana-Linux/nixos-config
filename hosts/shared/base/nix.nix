{
  pkgs,
  inputs,
  outputs,
  lib,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alejandra
    any-nix-shell
    cached-nix-shell
    cachix
    deadnix
    manix
    nil
    nix-bash-completions
    nix-binary-cache
    nix-bundle
    nix-direnv-flakes
    nix-doc
    nix-health
    nix-index
    nix-janitor
    nix-zsh-completions
    nixd
    nixel
    nixos-generators
    nixpacks
    nixt
    node2nix
    nox
    nurl
    nvd
    statix
  ];

  # Disable all documentation to reduce closure size
  documentation = {
    # disable documentation generation
    enable = false;
    # disable man pages
    man.enable = false;
    # disable dev documentation
    dev.enable = false;
    # disable doc generation
    doc.enable = false;
  };

  # ----------------------------------------------------------------------------
  # Package Manager Settings
  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org?priority=10" # nixos cache
        "https://fortuneteller2k.cachix.org" # f2k's cache
        "https://nix-community.cachix.org" # community cache
        "https://nixpkgs-unfree.cachix.org" # nixpkgs-unfree
        "https://pre-commit-hooks.cachix.org" # pre commit hooks
        "https://cuda-maintainers.cachix.org" # cuda maintainers
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];

      # ----------------------------------------------------------------------
      # allow sudo users to mark the following values as trusted
      allowed-users = ["@wheel" "root"];
      # only allow sudo users to manage the nix store
      trusted-users = [
        "root"
        "@wheel"
      ];
      # Allow the store to optimize itself
      auto-optimise-store = true;
      # Free up to 10GiB whenever there is less than 5GB left.
      # this setting is in bytes, so we multiply with 1024 by 3
      min-free = "${toString (5 * 1024 * 1024 * 1024)}";
      max-free = "${toString (10 * 1024 * 1024 * 1024)}";
      # Useful/Necessary Features to Have Enabled
      system-features = lib.mkForce ["kvm" "recursive-nix" "big-parallel"];
      # Necessary Experimental Nix Features for Flakes and Friends
      experimental-features = lib.mkForce ["recursive-nix" "cgroups" "ca-derivations" "nix-command" "flakes"];
      flake-registry = "/etc/nix/registry.json";
      # Use C-Groups for builds(requires experimental setting above)
      use-cgroups = true;
      # show more log lines for failed builds
      log-lines = 20;
      # Use Binary Cache because we don't want to wait our lives away
      builders-use-substitutes = true;
      # No Seriously, Use the Binary Caches
      always-allow-substitutes = true;
      # continue building derivations if one fails
      keep-going = true;
      # Garbage Collection will handle this later, but for now keep it around for rebuilds
      keep-derivations = true;
      # Keep Flake Outputs (not Garbage Collected)
      keep-outputs = true;
      # Set the max number of jobs to run simultaneously (works fine once installed, but
      # limiting this is very helpful when nix-install is being buggy)
      max-jobs = "auto";
      # Turn off that annoying warning from not committing
      warn-dirty = false;
      use-xdg-base-directories = true;
      # Explicitly allow flake.nix, just in case
      accept-flake-config = true;
    };

    # nix package manager version
    package = pkgs.nixVersions.git;
    # Garbage Collection Settings
    gc = {
      # Less Aggressive since both laptops have more than 1 TB of storage
      # and macbook-air I can configure aggressively when I get to fixing that config
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    # Transform the `inputs` attribute set into a registry format
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # Convert the `registry` attribute set to a list of strings in the form "key=path"
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
  # switch nixos-rebuild to the next generation
  system.switch = {
    enable = false;
    enableNg = true;
  };
}
