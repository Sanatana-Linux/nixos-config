---
name: nix-secrets
description: Manage encrypted secrets with sops-nix and age encryption. Use when adding new secrets, rotating keys, editing encrypted values, or troubleshooting decryption failures. Covers sops-nix module integration, secrets.yaml structure, host key management, and decryption troubleshooting.
tags: [nix, secrets, sops, age, encryption, security]
---

# Nix Secrets Skill

Manage encrypted secrets in the ShizNix configuration using sops-nix with age encryption.

## When to Use

- Adding a new secret (API key, password, token, etc.)
- Editing an existing secret value
- Adding a new host to the secrets configuration
- Rotating or adding SSH host keys
- Troubleshooting "failed to decrypt" errors
- Setting up secrets for a new host

## Architecture

- **Tool**: sops-nix (flake input)
- **Encryption**: age (SSH host key-based)
- **Secrets file**: `external/secrets/secrets.yaml` (git submodule)
- **SSH key path**: `/etc/ssh/ssh_host_ed25519_key`
- **Hosts**: bagalamukhi, matangi, bhairavi, chhinamasta

## Adding a New Secret

### 1. Edit the secrets file

```bash
# Edit the encrypted secrets file
sops external/secrets/secrets.yaml
```

Add a new key:
```yaml
my_new_secret: |
  my-secret-value-here
```

### 2. Add the secret to the host config

In `hosts/<host>/sops.nix`:
```nix
{ config, lib, pkgs, ... }:

{
  sops.secrets.my_new_secret = {
    sopsFile = ../secrets.yaml;  # or path to shared secrets file
    owner = config.users.users.tlh.name;
  };
}
```

### 3. Use the secret in a module

```nix
config = lib.mkIf cfg.enable {
  # The decrypted secret is at config.sops.secrets.my_new_secret.path
  services.some-service.environmentFile = config.sops.secrets.my_new_secret.path;
};
```

## Adding a New Host Key

### 1. Generate a host key on the new machine

```bash
sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
```

### 2. Get the age public key

```bash
# Convert SSH key to age format
ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
```

### 3. Add to .sops.yaml

In `external/secrets/.sops.yaml`:
```yaml
keys:
  - &host_bagalamukhi age1...
  - &host_matangi age1...
  - &host_bhairavi age1...
  - &host_new age1...

creation_rules:
  - path_regex: secrets.yaml
    key_groups:
      - age:
        - *host_bagalamukhi
        - *host_matangi
        - *host_bhairavi
        - *host_new
```

### 4. Re-encrypt

```bash
sops updatekeys external/secrets/secrets.yaml
```

## Troubleshooting

### "failed to decrypt" / "no matching key"

1. Check that the host's SSH key exists: `ls -la /etc/ssh/ssh_host_ed25519_key`
2. Check that the host is listed in `.sops.yaml` creation_rules
3. Re-run `sops updatekeys` to re-encrypt for all hosts
4. Verify the age key matches: `ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub`

### "sops: command not found"

Install sops via nix:
```bash
nix shell nixpkgs#sops
```

### Secrets file not found

The secrets file is in a git submodule at `external/secrets/`. Ensure it's checked out:
```bash
git submodule update --init external/secrets
```

## Security Notes

- Never commit unencrypted secrets
- Never share SSH host private keys
- The `external/secrets/` submodule is a separate repo with its own access controls
- Host keys are stored in `/etc/ssh/` and managed by NixOS
- Use `sops` CLI for all secret edits — never edit the decrypted file directly
