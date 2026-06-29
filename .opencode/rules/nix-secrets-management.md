# Nix Secrets Management

> sops-nix conventions for the ShizNix project.

## How Secrets Work

- **Tool**: [sops-nix](https://github.com/Mic92/sops-nix) — NixOS module for encrypted secrets
- **Encryption**: age (SSH host key-based)
- **Secrets file**: `external/secrets/secrets.yaml` — single encrypted YAML file
- **Key config**: `external/secrets/.sops.yaml` — maps host keys to encryption rules
- **Host configs**: `hosts/<host>/sops.nix` — per-host secret declarations
- **SSH key**: `/etc/ssh/ssh_host_ed25519_key`
- **Hosts**: bagalamukhi, matangi, bhairavi, chhinamasta

## Secrets File Structure

The `external/secrets/` directory is a **git submodule** managed in its own repo (`git@github.com:Sanatana-Linux/nixos-secrets.git`). All secrets live in `external/secrets/secrets.yaml`.

### .sops.yaml (key configuration)

```yaml
keys:
  - &host_bagalamukhi age1...
  - &host_matangi age1...
  - &host_bhairavi age1...
  - &host_chhinamasta age1...

creation_rules:
  - path_regex: secrets.yaml
    key_groups:
      - age:
        - *host_bagalamukhi
        - *host_matangi
        - *host_bhairavi
        - *host_chhinamasta
```

### Per-Host sops.nix

```nix
# hosts/bagalamukhi/sops.nix
{
  sops.defaultSopsFile = /etc/nixos/external/secrets/secrets.yaml;
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
}
```

Add secret references in the host's `default.nix`:

```nix
sops.secrets.my_api_key = {
  owner = config.users.users.tlh.name;
};
```

## Workflow

### Adding a New Secret

1. **Edit the encrypted file**:
   ```bash
   sops external/secrets/secrets.yaml
   ```

2. **Add your key-value**:
   ```yaml
   my_api_key: sk-abc123...
   ```

3. **Declare in the host config** (in `hosts/<host>/sops.nix` or `default.nix`):
   ```nix
   sops.secrets.my_api_key = {
     owner = config.users.users.tlh.name;
   };
   ```

4. **Use in a module**:
   ```nix
   services.some-app.environmentFile = config.sops.secrets.my_api_key.path;
   ```

### Adding a New Host

1. **Generate SSH key** on the new machine:
   ```bash
   sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
   ```

2. **Get the age public key**:
   ```bash
   ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
   ```

3. **Add to `.sops.yaml`** and re-encrypt:
   ```bash
   sops updatekeys external/secrets/secrets.yaml
   ```

## Rules

### Good (correct patterns)
```nix
# Decrypted secret path used as environment file
services.my-service.environmentFile = config.sops.secrets.my_key.path;
```

```nix
# Secret declared in host config with owner
sops.secrets.wifi_password = {
  owner = config.users.users.tlh.name;
};
```

### Bad (dangerous patterns)
```nix
# HARDCODED SECRET — never do this
my_secret = "sk-abc123";
```

```bash
# Editing decrypted output — use `sops` CLI instead
vim secrets-decrypted.yaml
```

```nix
# Omitting owner — file may have wrong permissions
sops.secrets.my_key = {};
```

## Troubleshooting

| Error | Likely Cause | Fix |
|-------|-------------|-----|
| `failed to decrypt` / `no matching key` | Host key not in `.sops.yaml` | Add host key, run `sops updatekeys` |
| `sops: command not found` | sops not installed | `nix shell nixpkgs#sops` |
| secrets file not found | Submodule not checked out | `git submodule update --init external/secrets` |
| Wrong age key | SSH key changed or rotated | Update `.sops.yaml`, re-run `sops updatekeys` |

## Security Notes

- **Never commit unencrypted secrets** to version control
- **Never share SSH host private keys**
- The `external/secrets/` submodule has its own access controls — manage separately
- Host keys live in `/etc/ssh/` and are managed by NixOS
- Always use the `sops` CLI for edits — never decrypt and re-encrypt manually
