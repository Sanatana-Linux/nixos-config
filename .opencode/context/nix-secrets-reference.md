# Nix-Secrets Reference (EmergentMind)

> Source: https://github.com/EmergentMind/nix-secrets-reference | License: MIT

Stripped-down reference for structuring private Nix secrets using sops-nix. Two branches: `simple` and `complex`.

## Concepts

### Soft Secrets
Evaluation-time variables (work email, usernames) — NOT encrypted, just kept out of public config.

### Hard Secrets
Tokens, private SSH keys, passwords — MUST be encrypted with sops-nix.

## Simple Branch

Single-file approach:

| File | Purpose |
|------|---------|
| `secrets.yaml` | All hard secrets, sops-encrypted |
| `.sops.yaml` | Which age keys to encrypt with |
| `flake.nix` | Soft secrets stored here |

## Complex Branch

Multi-file categorization:

| Directory/File | Purpose |
|----------------|---------|
| `nix/development.nix` | Dev-related soft secrets |
| `nix/network.nix` | Network config soft secrets |
| `nix/personal.nix` | Personal info |
| `nix/services.nix` | Service config |
| `nix/software.nix` | Software config |
| `nix/work.nix` | Work-related |
| `sops/hostname1.yaml` | Per-host hard secrets |
| `sops/shared.yaml` | Shared hard secrets |
| `sops/work.yaml` | Work hard secrets |
| `sops/development.yaml` | Dev hard secrets |
| `.sops.yaml` | Age key config (more complex rules) |
| `flake.nix` | Auto-imports all `nix/` files, provides dev shell |

### Flake auto-import pattern (complex branch)

The flake.nix auto-imports all soft secret files from `nix/`:
```nix
# Each nix/*.nix exports an attrset of secrets
# flake.nix merges them via lib.recursiveUpdate or similar
```

## Requirements

```bash
nix-shell -p age git sops ssh-to-age  # tools needed on demand
```

## Integration with Nix-Config

The private nix-secrets repo is pulled into the public nix-config as a flake input:

```nix
{
  inputs.nix-secrets.url = "git+ssh://git@github.com/EmergentMind/nix-secrets";
  # Pass secrets to hosts via specialArgs or _module.args
}
```

## Key Files Reference

### .sops.yaml

```yaml
keys:
  - &host_key_1 age1...
  - &host_key_2 age1...
creation_rules:
  - path_regex: secrets.yaml$
    key_groups:
    - age: [*host_key_1, *host_key_2]
```

### justfile (task runner)

Provides convenient commands for managing secrets (encrypt, decrypt, edit, rekey).

## Resources

- Full article: https://unmovedcentre.com/posts/secrets-management/
- Uses: sops-nix, disko, nixos-anywhere
