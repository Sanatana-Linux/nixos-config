{
  sops.defaultSopsFile = /etc/nixos/external/secrets/secrets.yaml;
  # secrets.yaml is encrypted with the repo key's recipient — use the
  # decrypted system key installed by the secrets repo's
  # ensure-system-key script (source: keys.txt.age in external/secrets)
  sops.age.keyFile = "/var/lib/sops/age-keys.txt";
  # The secrets submodule is not part of the flake tree, so the secrets file
  # cannot be hashed into the nix store at eval time. Disable eval-time
  # validation; integrity is enforced by the sops CLI during edits.
  sops.validateSopsFiles = false;
  # Point the interactive `sops` CLI at the same key the system uses, instead
  # of relying on the ~/.config/sops/age default path (which the secrets
  # repo's justfile overwrites with an unrelated key set).
  environment.sessionVariables.SOPS_AGE_KEY_FILE = "/var/lib/sops/age-keys.txt";
}
