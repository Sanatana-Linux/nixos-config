{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}:
with lib; let
  cfg = config.modules.base.nix;
in {
  options.modules.base.nix = {
    enable = mkEnableOption "Enhanced Nix configuration with optimizations and binary caches";

    maxJobs = mkOption {
      type = types.int;
      default = 1;
      description = "Maximum number of build jobs to run simultaneously";
    };

    garbageCollection = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable automatic garbage collection";
      };

      frequency = mkOption {
        type = types.str;
        default = "weekly";
        description = "Frequency of garbage collection";
      };

      deleteOlderThan = mkOption {
        type = types.str;
        default = "7d";
        description = "Delete generations older than this period";
      };
    };

    documentation = mkOption {
      type = types.bool;
      default = false;
      description = "Enable system documentation generation";
    };

    extraCaches = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional binary cache substituters";
    };

    extraTrustedKeys = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional trusted public keys for binary caches";
    };
  };

  config = mkIf cfg.enable {
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

    # Documentation settings
    documentation = mkIf (!cfg.documentation) {
      enable = false;
      man.enable = false;
      dev.enable = false;
      doc.enable = false;
    };

    # Nix configuration
    nix = {
      settings = {
        # User permissions
        allowed-users = ["@wheel" "root"];
        trusted-users = ["root" "@wheel"];

        # Store optimization
        auto-optimise-store = true;
        min-free = "${toString (5 * 1024 * 1024 * 1024)}"; # 5GB
        max-free = "${toString (10 * 1024 * 1024 * 1024)}"; # 10GB

        # System features and experimental features
        system-features = mkForce ["kvm" "recursive-nix" "big-parallel"];
        experimental-features = mkForce ["recursive-nix" "cgroups" "nix-command" "flakes"];
        flake-registry = "/etc/nix/registry.json";
        use-cgroups = true;

        # Build settings
        log-lines = 50;
        builders-use-substitutes = true;
        always-allow-substitutes = true;
        keep-going = false;
        keep-derivations = true;
        keep-outputs = true;
        max-jobs = cfg.maxJobs;
        warn-dirty = false;
        use-xdg-base-directories = true;
        accept-flake-config = true;

        # Binary caches
        substituters =
          [
            "https://cache.garnix.io"
            "https://cache.nixos.org?priority=10"
            "https://nix-community.cachix.org"
            "https://nixpkgs-unfree.cachix.org"
            "https://pre-commit-hooks.cachix.org"
            "https://cuda-maintainers.cachix.org"
            "https://ai.cachix.org"
            "https://nix-gaming.cachix.org"
          ]
          ++ cfg.extraCaches;

        # Trusted public keys
        trusted-public-keys =
          [
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
            "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
            "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
            "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
            "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          ]
          ++ cfg.extraTrustedKeys;
      };

      # Package version
      package = pkgs.nixVersions.latest;

      # Garbage collection
      gc = mkIf cfg.garbageCollection.enable {
        automatic = true;
        dates = cfg.garbageCollection.frequency;
        options = "--delete-older-than ${cfg.garbageCollection.deleteOlderThan}";
      };

      # Registry and nixPath
      registry = mapAttrs (_: value: {flake = value;}) inputs;
      nixPath = mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

      # Performance tuning
   #   daemonCPUSchedPolicy = "idle";
      daemonIOSchedPriority = 4;
    };
  };
}
