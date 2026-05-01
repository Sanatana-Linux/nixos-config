{
  sops.defaultSopsFile = ../../external/secrets/hosts/matangi/secrets.yaml;
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
}
