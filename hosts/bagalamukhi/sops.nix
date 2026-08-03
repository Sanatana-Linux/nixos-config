{
  sops.defaultSopsFile = /etc/nixos/external/secrets/secrets.yaml;
  # secrets.yaml is encrypted with the repo key's recipient — use the
  # decrypted system key installed by the secrets repo's
  # ensure-system-key script (source: keys.txt.age in external/secrets)
  sops.age.keyFile = "/var/lib/sops/age-keys.txt";
}
