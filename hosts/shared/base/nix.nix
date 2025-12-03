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
    nix-bash-completions
    nix-binary-cache
    nix-bundle
    nix-direnv
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
      log-lines = 50;
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
      max-jobs = "auto";
      # Turn off that annoying warning from not committing
      warn-dirty = false;
      use-xdg-base-directories = true;
      # Explicitly allow flake.nix, just in case
      accept-flake-config = true;
      # Binary cache substituters
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://fortuneteller2k.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
        "https://pre-commit-hooks.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://ai.cachix.org"
        "https://stable-diff.cachix.org"
        "https://sanatanalinux.cachix.org"
        "https://chaotic-nyx.cachix.org"
        "https://zen-browser.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      # Trusted public keys for binary caches
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
        "stable-diff.cachix.org-1:liYFm3f3q1dAoilj2Ag2IEKzW3Q9/HJcLlrAIytAcy0="
        "sanatanalinux.cachix.org-1:9WsJYECJ+Lt0HPTUI7+6f9uAaAUouaBUyTd9iAJbUEY="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "zen-browser.cachix.org-1:VkBZFD6ielaF2pp1M0KGDAXdYqB25lX5x0bJ8uMnbHs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
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

    # Convert the `registry` attribute set to a list of strings in the form "key=path
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    # smooth rebuilds
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedPriority = 4; # 7 max
  };
}
