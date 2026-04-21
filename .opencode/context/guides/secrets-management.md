# NixOS Secrets Management (agenix & sops-nix)

Core concept: NixOS secrets must never be stored in the world-readable Nix store. Two declarative tools solve this: **agenix** (age-encrypted secrets via SSH keys) and **sops-nix** (sops-based encryption with GPG/age/KMS support). Both encrypt secrets into the Nix store and decrypt them at activation time to `/run/` paths, but differ in complexity and features.

## agenix — Simple, SSH-key-based

Key Points:
- Encrypts `.age` files using SSH public keys (host keys from `/etc/ssh/` or user keys from `~/.ssh/`)
- CLI: `agenix -e secret.age` (edits with `$EDITOR`, re-encrypts on save), `agenix --rekey` (re-encrypts all secrets after key changes)
- Decrypted to `/run/agenix/<name>` by default; referenced via `config.age.secrets.<name>.path`
- Home-manager module available: secrets decrypt to `$XDG_RUNTIME_DIR/agenix/`
- `secrets.nix` defines which public keys can decrypt which files — this file is NOT part of your NixOS config, it's only for the CLI
- **Anti-pattern**: Never `builtins.readFile` on a secret path — this puts cleartext into the Nix store
- Supports `symlink = false` for programs that don't follow symlinks (e.g., Java/Elasticsearch)
- Set `mode`, `owner`, `group` for service-specific permissions

Example:
```nix
# flake.nix
inputs.agenix.url = "github:ryantm/agenix";

# configuration.nix
age.secrets.my-secret.file = ./secrets/my-secret.age;
age.secrets.nginx-htpasswd = {
  file = ./secrets/nginx.htpasswd.age;
  mode = "770"; owner = "nginx"; group = "nginx";
};
# Reference in config:
users.users.user.hashedPasswordFile = config.age.secrets.my-secret.path;
```

## sops-nix — Full-featured, multi-key

Key Points:
- Based on Mozilla's `sops` tool; supports age, GPG, AWS KMS, GCP KMS, Azure Key Vault, Hashicorp Vault
- Secrets encrypted once with a master key, then distributed per-recipient (scales for teams)
- Supports YAML, JSON, INI, dotenv, and binary formats — one file can contain multiple secrets
- Mac (message authentication code) provides integrity verification (agenix lacks this)
- `.sops.yaml` in repo root defines creation rules per path regex, mapping to key groups
- `ssh-to-age` converts Ed25519 SSH keys to age format; `ssh-to-pgp` converts RSA SSH keys to GPG format
- Decrypts to `/run/secrets/<name>` (system) or `$XDG_RUNTIME_DIR/secrets.d/` (home-manager)
- Atomic upgrades: new secrets written to `/run/secrets.d/<N>/`, then symlinked
- **Templates**: `sops.templates."config.toml".content = ''password = "${config.sops.placeholder.secret}"'';`
- **`neededForUsers = true`**: decrypts before user creation (for `hashedPasswordFile`)
- `restartUnits` / `reloadUnits`: restart systemd services when secrets change
- **Limitation**: Cannot use secrets at Nix evaluation time; initrd secrets require `nixos-rebuild test` first

Example:
```nix
# flake.nix
inputs.sops-nix.url = "github:Mic92/sops-nix";

# configuration.nix
sops = {
  defaultSopsFile = ./secrets.yaml;
  age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  age.keyFile = "/var/lib/sops-nix/key.txt";
  age.generateKey = true;
  secrets.github-token = {};
  secrets."myservice/api-key" = {
    owner = "myservice";
    restartUnits = [ "myservice.service" ];
  };
};
```

## Comparison

| Feature | agenix | sops-nix |
|---------|--------|-----------|
| Encryption | age only | age, GPG, KMS, Vault |
| Key derivation | SSH keys directly | SSH → age/pgp conversion |
| Multi-secret files | No (1 file per secret) | Yes (YAML/JSON/INI) |
| Integrity (MAC) | No | Yes |
| Templates | No | Yes (`sops.templates`) |
| Diff-friendly | `.age` binary | Encrypted YAML/JSON (readable diffs) |
| Team scaling | Re-encrypt per-recipient per file | Master key + per-recipient sub-keys |
| Home-manager | Yes | Yes |
| Complexity | Minimal | Moderate |
| CLI | `agenix -e` / `--rekey` | `sops <file>` |

## Organizational Pattern (from nix-secrets-reference)

- **Soft secrets**: non-sensitive values you don't want public (emails, URLs) — stored in `flake.nix` or `nix/` modules, imported as flake outputs
- **Hard secrets**: tokens, passwords, keys — encrypted via sops-nix in `.yaml` files
- **Simple setup**: single `secrets.yaml` for all hard secrets, soft secrets inline in `flake.nix`
- **Complex setup**: per-host/per-category `.yaml` files, `.sops.yaml` creation_rules with path regex, `nix/` directory for categorised soft secrets
- Private secrets repo pulled as flake input: `inputs.nix-secrets.url = "git+ssh://git@github.com/user/nix-secrets.git";`

Reference: [github.com/ryantm/agenix](https://github.com/ryantm/agenix) | [github.com/Mic92/sops-nix](https://github.com/Mic92/sops-nix) | [github.com/EmergentMind/nix-secrets-reference](https://github.com/EmergentMind/nix-secrets-reference)