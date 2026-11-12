{
  sops.defaultSopsFile = /etc/nixos/external/secrets/secrets.yaml;
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  # Point the interactive `sops` CLI at the same key the system uses.
  environment.sessionVariables.SOPS_AGE_KEY_FILE = "/var/lib/sops/age-keys.txt";
}
