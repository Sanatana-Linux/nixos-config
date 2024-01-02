{
  lib,
  pkgs,
  config,
  nixpkgs,
  flake-self,
  nixpkgs-unstable,
  ...
}:
with lib; let
  cfg = config.tlh.nix-common;
in {
  options.tlh.nix-common = {
    enable = mkEnableOption "activate nix-common";
    disable-cache = mkEnableOption "not use binary-cache";
  };

  config = mkIf cfg.enable {
    nix = {
      package = pkgs.nixFlakes;

      # Set the $NIX_PATH entry for nixpkgs. This is necessary in
      # this setup with flakes, otherwise commands like `nix-shell
      # -p pkgs.htop` will keep using an old version of nixpkgs.
      # With this entry in $NIX_PATH it is possible (and
      # recommended) to remove the `nixos` channel for both users
      # and root e.g. `nix-channel --remove nixos`. `nix-channel
      # --list` should be empty for all users afterwards
      nixPath = ["nixpkgs=${nixpkgs}"];

      settings = {
        # use custom binary cache
        trusted-public-keys = mkIf (cfg.disable-cache != true) [
          "nix-cache:4FILs79Adxn/798F8qk2PC1U8HaTlaPqptwNJrXNA1g="
          "alexanderwallau.cachix.org-1:vi7QC6uUBbRi69tJmp/Ylta1f3BliiW2ABV89EFRiX0="
          "mayniklas.cachix.org-1:gti3flcBaUNMoDN2nWCOPzCi2P68B5JbA/4jhUqHAFU="
        ];
        substituters = mkIf (cfg.disable-cache != true) [
          "https://cache.nixos.org"
          "https://alexanderwallau.cachix.org?priority=75"
          "https://nix-community.cachix.org?priority=5"
          "https://nrdxp.cachix.org"
          "https://nixpkgs-unfree.cachix.org"
          "https://nixpkgs-wayland.cachix.org"
          "https://nix-node.cachix.org/"
          "https://fortuneteller2k.cachix.org"
          "https://cache.ngi0.nixos.org/"
          "https://mayniklas.cachix.org?priority=75"
          "https://cache.lounge.rocks/nix-cache?priority=100"
        ];
        trusted-substituters = mkIf (cfg.disable-cache != true) [
          "https://cache.nixos.org"
          "https://cache.lounge.rocks"
        ];
        # allow sudo users to mark the following values as trusted
        allowed-users = ["@wheel" "root" "tlh"];
        # only allow sudo users to manage the nix store
        trusted-users = [
          "root"
          "@wheel"
          "tlh"
        ];
        # Save space by hardlinking store files
        auto-optimise-store = true;
      };

      # Clean up old generations after 3 days
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 3d";
      };

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

    nixpkgs = {
      # Allow unfree licenced packages
      config.allowUnfree = true;
      overlays = [
        flake-self.overlays.default
        (final: prev: {
          unstable = import nixpkgs-unstable {
            system = "${pkgs.system}";
            config.allowUnfree = true;
          };
        })
      ];
    };

    programs = {
      nix-index = {
        enable = true;
        enableZshIntegration = true;
      };

      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
    # Let 'nixos-version --json' know the Git revision of this flake.
    system.configurationRevision = nixpkgs.lib.mkIf (flake-self ? rev) flake-self.rev;
    nix.registry.nixpkgs.flake = nixpkgs;

    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.05"; # Did you read the comment?
  };
}
