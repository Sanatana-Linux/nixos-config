{
  sops.defaultSopsFile = /etc/nixos/external/secrets/secrets.yaml;
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  # Point the interactive `sops` CLI at the same key the system uses, instead
  # of relying on the ~/.config/sops/age default path (which the secrets
  # repo's justfile overwrites with an unrelated key set).
  environment.sessionVariables.SOPS_AGE_KEY_FILE = "/var/lib/sops/age-keys.txt";
}
