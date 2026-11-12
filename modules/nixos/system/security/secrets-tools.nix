{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.security.secretsTools;

  # The secrets tooling lives in the external/secrets submodule. The submodule
  # is not part of the flake tree -- a git flake's store copy leaves gitlink
  # directories empty -- so it is referenced by absolute path, the same way
  # sops.defaultSopsFile is in hosts/<host>/sops.nix. That requires --impure,
  # which every build in this repo already passes.
  #
  # Importing the submodule's scripts.nix directly (rather than adding the
  # private repo as a flake input) keeps evaluation working without needing
  # credentials for a private input, and ties the installed copies to the
  # checked-out submodule.
  secretsScripts = import (cfg.secretsDir + "/nix/scripts.nix") {
    inherit pkgs;
    lib = pkgs.lib;
    systemKeyFile = cfg.sopsKeyFile;
  };

  scriptNames = [
    "create-system-key"
    "decrypt-file"
    "deploy-pub-key"
    "encrypt-file"
    "ensure-system-key-exists"
    "extract-pub-key"
    "generate-ssh-key"
    "gpg-manage"
    "init-secrets"
    "list-secrets"
    "print-secret"
    "remove-secret"
    "rotate-repo-key"
    "secrets-menu"
    "set-hashed-password"
    "set-secret"
  ];
in {
  options.modules.system.security.secretsTools = {
    enable = mkEnableOption "secrets CLI tooling installed from the external/secrets submodule";

    secretsDir = mkOption {
      type = types.str;
      default = "/etc/nixos/external/secrets";
      description = "Path to the secrets repo checkout holding the scripts.";
    };

    sopsKeyFile = mkOption {
      type = types.str;
      default = "/var/lib/sops/age-keys.txt";
      description = "Path to the installed age identity the scripts use to decrypt secrets.";
    };
  };

  config = mkIf cfg.enable {
    # Installed into the system profile so the scripts are always the current
    # build after a rebuild, and are reachable from any directory rather than
    # only from inside the secrets repo. Previously they were reachable only
    # through the repo's devshell, where a stale build could shadow the fixed
    # one and keep asking for the repo key passphrase.
    environment.systemPackages = map (name: secretsScripts.${name}) scriptNames;
  };
}
