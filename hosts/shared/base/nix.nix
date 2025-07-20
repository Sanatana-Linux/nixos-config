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
      keep-going = false;
      # Garbage Collection will handle this later, but for now keep it around for rebuilds
      keep-derivations = true;
      # Keep Flake Outputs (not Garbage Collected)
      keep-outputs = true;
      # Set the max number of jobs to run simultaneously (works fine once installed, but
      # limiting this is very helpful when nix-install is being buggy)
      max-jobs = 2; #   "auto";
      # Turn off that annoying warning from not committing
      warn-dirty = false;
      use-xdg-base-directories = true;
      # Explicitly allow flake.nix, just in case
      accept-flake-config = true;
    };

    # nix package manager version
    package = pkgs.nixVersions.latest;
    # Garbage Collection Settings
    gc = {
      # Less Aggressive since both laptops have more than 1 TB of storage
      # and macbook-air I can configure aggressively when I get to fixing that config
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # Transform the `inputs` attribute set into a registry format
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # Convert the `registry` attribute set to a list of strings in the form "key=path"
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
  # switch nixos-rebuild to the next generation
}
