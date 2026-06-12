---
name: nix-secrets
description: Manage secrets via sops-nix — encrypted secrets in the repo, decrypted at build time
level: 2
---

# Nix Secrets — ShizNix

Manage encrypted secrets via `sops-nix` for this NixOS configuration.

## Architecture

- **Tool**: `sops-nix` (nixos module) + `sops` (encryption CLI)
- **Encryption**: age keys (not GPG) — `age` format
- **Location**: `external/secrets/` (git submodule)
- **Key**: Host-specific age keys stored in `/etc/ssh/ssh_host_ed25519_key` (converted to age)

## Commands

```bash
# Edit a secret file
sops external/secrets/<name>.yaml

# Encrypt a new file for a specific host
sops --encrypt \
  --age $(cat /etc/ssh/ssh_host_ed25519_key.pub | age-keygen -y 2>/dev/null || cat /etc/age/key.txt) \
  --in-place external/secrets/<name>.yaml

# Decrypt to view (already done by `sops <file>`)
sops -d external/secrets/<name>.yaml
```

## Integration in NixOS

```nix
{ config, pkgs, lib, inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./secrets.yaml;  # or absolute path
    age = {
      keyFile = "/etc/ssh/ssh_host_ed25519_key";
      generateKey = false;
    };
    secrets = {
      "some_secret" = {
        path = "/run/secrets/some_secret";
        owner = "username";
      };
    };
  };
}
```

## Adding a New Secret

1. Create/encrypt: `sops external/secrets/<new-secret>.yaml`
2. Define age recipients (host public keys)
3. Reference in module: `config.sops.secrets.<name>`
4. Read at runtime: `$(cat /run/secrets/<name>)` or service env var

## Best Practices

- Never commit unencrypted secrets
- Use host-specific age keys (SSH host key conversion)
- Store secrets outside the main flake (git submodule prevents accidental pushes)
- Use `sops.secrets.<name>.owner` to restrict access
- Use `sops.secrets.<name>.restartUnits` to restart services on secret rotation