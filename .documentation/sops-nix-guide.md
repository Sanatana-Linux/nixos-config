# Secrets Management with sops-nix

This guide explains how secrets management works in this NixOS configuration using sops-nix, a tool that encrypts secrets at rest and decrypts them during system activation.

## Overview

### What is sops-nix?

[sops-nix](https://github.com/Mic92/sops-nix) integrates Mozilla's SOPS (Secrets OPerationS) with NixOS, allowing you to:
- Store encrypted secrets in a separate private git repository
- Decrypt secrets automatically during `nixos-rebuild`
- Use multiple encryption keys (PGP for humans, age for hosts)
- Maintain an audit trail of who has access to which secrets

### Why Keep Secrets in a Separate Repository?

Security best practices dictate keeping secrets out of your public configuration repository, even when encrypted. This configuration maintains:
- **Public repo**: `nixos-config` (this repository) - Safe to share, contains no secrets
- **Private repo**: `nix-secrets` (your private repository) - Contains encrypted secrets, never public

## How It Works

### Key Types

sops-nix uses two types of encryption keys:

1. **PGP (GPG) Keys** - For humans
   - Used when manually editing secrets with `sops secrets.yaml`
   - Identified by GPG fingerprint (e.g., `6E2D4B7F33D88C1A7C722A6A169E5DE9DC02FFB5`)
   - Requires GPG key and passphrase

2. **age Keys** - For machines
   - Derived from SSH host keys (`/etc/ssh/ssh_host_ed25519_key`)
   - Used by NixOS during `nixos-rebuild` to auto-decrypt
   - No passphrase needed - tied to the host hardware

### The .sops.yaml File

This file defines who can decrypt which secrets:

```yaml
keys:
  # Human keys (for manual editing)
  - &tlh_gpg 6E2D4B7F33D88C1A7C722A6A169E5DE9DC02FFB5
  
  # Machine keys (for automatic decryption)
  - &bagalamukhi age1qqw8r7xa7x8g4gxh6h8jf5vzj7kpm3yqvzc9k5k0hk9c9r7xa7x8
  - &matangi age1xyz...
  
creation_rules:
  # System-wide secrets - all hosts can decrypt
  - path_regex: secrets\.yaml$
    key_groups:
      - pgp:
          - *tlh_gpg
        age:
          - *bagalamukhi
          - *matangi
  
  # Per-user secrets - only specific hosts can decrypt
  - path_regex: users/tlh/env\.yaml$
    key_groups:
      - pgp:
          - *tlh_gpg
        age:
          - *bagalamukhi  # Only bagalamukhi can decrypt tlh's secrets
```

### Secrets Repository Structure

Typical structure for a secrets repository:

```
nix-secrets/
├── .sops.yaml                    # Defines who can decrypt what
├── secrets.yaml                  # System-wide encrypted secrets
├── flake.nix                     # Exposes secrets path as flake output
└── users/
    ├── tlh/
    │   └── env.yaml             # User-specific encrypted environment variables
    └── smg/
        └── env.yaml             # Different user's secrets
```

### Integration with NixOS Configuration

In your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Add secrets repository as input
    nix-secrets = {
      url = "git+ssh://git@github.com/yourusername/nix-secrets.git";
      flake = true;
    };
  };

  outputs = { self, nixpkgs, nix-secrets, ... }: {
    nixosConfigurations.bagalamukhi = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };  # Pass inputs to modules
      modules = [
        ./hosts/bagalamukhi
        
        # Include sops-nix module
        inputs.sops-nix.nixosModules.sops
      ];
    };
  };
}
```

In a NixOS module (e.g., `modules/nixos/services/example.nix`):

```nix
{ config, lib, pkgs, inputs, ... }:
with lib; {
  options.modules.services.example = {
    enable = mkEnableOption "example service with secrets";
  };

  config = mkIf config.modules.services.example.enable {
    # Define a secret
    sops.secrets.example_api_key = {
      sopsFile = "${inputs.nix-secrets}/secrets.yaml";
      owner = "exampleuser";
      mode = "0400";
    };

    # Use the secret in a service
    systemd.services.example = {
      script = ''
        # Secret is available at /run/secrets/example_api_key
        export API_KEY=$(cat ${config.sops.secrets.example_api_key.path})
        ${pkgs.example}/bin/example-daemon
      '';
    };
  };
}
```

## Workflow

### Editing Secrets

To manually edit secrets (requires GPG key):

```bash
cd ~/nix-secrets
sops secrets.yaml
```

This opens your `$EDITOR` with decrypted content. When you save and exit, sops automatically re-encrypts.

### Adding a New Secret

```bash
cd ~/nix-secrets

# Edit secrets.yaml
sops secrets.yaml

# Add your secret in YAML format:
# new_secret: "my_secret_value"

# Save and exit - sops re-encrypts automatically

# Commit and push
git add secrets.yaml
git commit -m "Add new_secret"
git push
```

Then reference it in your NixOS configuration:

```nix
sops.secrets.new_secret = {
  sopsFile = "${inputs.nix-secrets}/secrets.yaml";
};
```

### Adding a New Host

When installing NixOS on a new machine that needs access to secrets:

1. Get the host's age key:
   ```bash
   sudo cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
   ```

2. Add to `.sops.yaml`:
   ```yaml
   keys:
     - &newhost age1xyz...  # Paste the age key here
   
   creation_rules:
     - path_regex: secrets\.yaml$
       key_groups:
         - age:
             - *newhost  # Add to the list
   ```

3. Re-encrypt all secrets:
   ```bash
   sops updatekeys secrets.yaml
   ```

4. Commit and push:
   ```bash
   git add .sops.yaml secrets.yaml
   git commit -m "Add newhost to secrets access"
   git push
   ```

5. Rebuild NixOS on the new host:
   ```bash
   sudo nixos-rebuild switch --flake .#newhost
   ```

## User-Specific Environment Variables

### Current Setup (GPG-encrypted .env)

If you currently use `~/.config/.env` with GPG encryption (`~/.config/.env.gpg`), you can integrate this into sops-nix:

**Current workflow:**
```bash
# Decrypt when needed
gpg --decrypt ~/.config/.env.gpg > ~/.config/.env

# Source in shell
source ~/.config/.env
```

### Migrating to sops-nix

**Benefits of migration:**
- Automatic decryption on login
- Same encryption keys as system secrets
- Git-backed with version history
- Per-host access control

**Migration steps:**

1. Create user secrets file:
   ```bash
   cd ~/nix-secrets
   mkdir -p users/tlh
   
   # Copy your existing env vars to plain YAML
   cat > users/tlh/env.yaml.plain <<EOF
   OPENAI_API_KEY: "sk-..."
   ANTHROPIC_API_KEY: "sk-ant-..."
   GITHUB_TOKEN: "ghp_..."
   EOF
   
   # Encrypt with sops
   sops --encrypt users/tlh/env.yaml.plain > users/tlh/env.yaml
   rm users/tlh/env.yaml.plain
   
   # Commit
   git add users/tlh/env.yaml
   git commit -m "Add environment variables for tlh"
   git push
   ```

2. Create a home-manager module to load them:
   ```nix
   # modules/home-manager/programs/env-loader.nix
   { config, lib, pkgs, inputs, ... }:
   with lib; {
     options.modules.programs.env-loader = {
       enable = mkEnableOption "encrypted environment variable loader";
     };

     config = mkIf config.modules.programs.env-loader.enable {
       # Decrypt user env file
       sops.secrets."${config.home.username}/env" = {
         sopsFile = "${inputs.nix-secrets}/users/${config.home.username}/env.yaml";
         owner = config.home.username;
       };

       # Load into shell
       programs.zsh.initExtra = mkIf config.programs.zsh.enable ''
         if [ -f ${config.sops.secrets."${config.home.username}/env".path} ]; then
           source ${config.sops.secrets."${config.home.username}/env".path}
         fi
       '';
     };
   }
   ```

3. Enable in your host configuration:
   ```nix
   modules.programs.env-loader.enable = true;
   ```

### Keeping Current Setup

If you prefer to keep using GPG-encrypted `.env` files separately from sops-nix:

**Advantages:**
- Simpler - no module needed
- Independent from system secrets
- Works across non-NixOS systems

**Recommendation:** Use sops-nix for system/service secrets, keep GPG-encrypted `.env` for user API keys. This separates concerns and keeps things flexible.

## Security Considerations

### Access Control

- **PGP keys**: Anyone with your GPG key can decrypt and edit secrets
- **age keys**: Only the specific host can decrypt (tied to SSH host key)
- **Multi-host secrets**: Add multiple age keys to allow multiple hosts to decrypt
- **Per-user secrets**: Use path_regex in `.sops.yaml` to restrict access

### Best Practices

1. **Separate repositories**: Never commit encrypted secrets to public repos
2. **Rotate keys**: Periodically regenerate age keys and re-encrypt secrets
3. **Audit access**: Review `.sops.yaml` regularly to see who has access
4. **Backup GPG keys**: Store GPG private key backup securely offline
5. **Use per-service secrets**: Don't share one secret across multiple services
6. **Minimal permissions**: Set appropriate `owner` and `mode` for secret files

### Common Pitfalls

1. **Forgetting to re-encrypt**: After adding a new host to `.sops.yaml`, always run `sops updatekeys`
2. **SSH key changes**: If you regenerate `/etc/ssh/ssh_host_ed25519_key`, the age key changes and secrets become inaccessible
3. **Git conflicts**: Multiple people editing secrets.yaml simultaneously causes merge conflicts (coordinate edits)
4. **Flake inputs**: sops-nix needs secrets available at eval time, so use `git+ssh://` URLs for private repos

## Troubleshooting

### "Failed to decrypt" error during rebuild

**Cause**: Host's age key not in `.sops.yaml`

**Solution**:
```bash
# Get current host age key
sudo cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age

# Add to .sops.yaml and re-encrypt
cd ~/nix-secrets
# Edit .sops.yaml
sops updatekeys secrets.yaml
git commit -am "Add current host age key"
git push

# Rebuild
sudo nixos-rebuild switch --flake .#$(hostname)
```

### "No GPG key found" when editing secrets

**Cause**: GPG key not imported or not matching fingerprint in `.sops.yaml`

**Solution**:
```bash
# List GPG keys
gpg --list-keys

# If missing, import key
gpg --import /path/to/private-key.asc

# Verify fingerprint matches .sops.yaml
```

### Secrets not available in /run/secrets/

**Cause**: Secret not defined in NixOS configuration

**Solution**:
```nix
# In your module
sops.secrets.my_secret = {
  sopsFile = "${inputs.nix-secrets}/secrets.yaml";
};
```

### "Error: ref 'refs/heads/main' is not signed"

**Cause**: Flake input requires signed commits but secrets repo isn't signed

**Solution**:
```bash
# Sign commits with GPG
git config commit.gpgSign true

# Or disable signature requirement (less secure)
# In flake.nix:
nix-secrets.url = "git+ssh://git@github.com/user/nix-secrets.git?ref=main&shallow=1";
```

## Further Reading

- [sops-nix GitHub](https://github.com/Mic92/sops-nix)
- [Mozilla SOPS](https://github.com/mozilla/sops)
- [age encryption](https://age-encryption.org/)
- [NixOS Wiki: Secrets Management](https://nixos.wiki/wiki/Sops-nix)
