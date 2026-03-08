# Secrets Bootstrap Design

## Current State Analysis

### What Works
- `setup_secrets.sh`: Creates a separate private secrets repo with sops-nix
- Requires GPG key and SSH host keys
- Separate from public config repo (good security practice)

### What's Missing
1. **Live-ISO bootstrap flow**: No way to authenticate to GitHub from fresh system
2. **New host provisioning**: Can't add new host to secrets repo from system that lacks secrets access
3. **GPG key import**: No mechanism to securely import signing key on fresh install
4. **~/.config/.env handling**: No automation for per-user encrypted environment variables

## Proposed Solution: Multi-Stage Bootstrap

### Stage 1: Fresh Live-ISO Boot (No Secrets)
**Goal**: Install NixOS with minimal config, no secrets yet

```bash
# On live-ISO (chhinamasta)
./install.sh --no-secrets --host <hostname>
```

**What happens**:
1. Prompts for root password (used for both login and encryption)
2. Clones public nixos-config repo
3. Generates hardware-configuration.nix
4. Runs nixos-install with host config
5. **NEW**: Generates SSH keypair for host: `/mnt/etc/ssh/ssh_host_ed25519_key.pub`
6. **NEW**: Derives age key: `ssh-to-age < ssh_host_ed25519_key.pub > host.age`
7. **NEW**: Displays both SSH pubkey and age pubkey for user to record
8. Reboots into new system (still no secrets)

### Stage 2: First Boot on New Host (Add Secrets Access)
**Goal**: Authenticate to GitHub, add new host to secrets repo

```bash
# On new system (first boot)
sudo ./bootstrap-secrets.sh --host <hostname>
```

**Interactive workflow**:
1. **GitHub Authentication**:
   ```bash
   # Option A: GitHub CLI with browser
   gh auth login --web
   
   # Option B: Personal Access Token (PAT)
   gh auth login --with-token < token.txt
   ```

2. **GPG Key Import** (for commit signing):
   ```bash
   # Option A: From existing system (via USB or network)
   gpg --export-secret-keys <key-id> > /tmp/secret.gpg
   gpg --import /tmp/secret.gpg
   shred -u /tmp/secret.gpg
   
   # Option B: Generate new GPG key for this user
   gpg --full-generate-key
   # Then add to GitHub: gh gpg-key add
   ```

3. **Clone or Create Secrets Repo**:
   ```bash
   # If secrets repo exists:
   gh repo clone <username>/nix-secrets ~/nix-secrets
   
   # If first time:
   gh repo create nix-secrets --private --clone
   cd ~/nix-secrets && ../setup_secrets.sh
   ```

4. **Add New Host to .sops.yaml**:
   ```bash
   # User provides age pubkey from Stage 1
   read -p "Enter age pubkey for this host: " AGE_KEY
   
   # Append to .sops.yaml
   cat >> .sops.yaml <<EOF
     - &${HOSTNAME} ${AGE_KEY}
   EOF
   
   # Add to creation_rules
   # Re-encrypt all secrets with new host key
   sops updatekeys secrets.yaml
   ```

5. **Commit and Push**:
   ```bash
   git add .sops.yaml
   git commit -S -m "Add ${HOSTNAME} to secrets access"
   git push
   ```

6. **Update Public Config** to reference secrets:
   ```nix
   # flake.nix
   inputs.nix-secrets = {
     url = "git+ssh://git@github.com/<username>/nix-secrets.git";
     flake = true;
   };
   ```

7. **Rebuild with secrets**:
   ```bash
   cd ~/nixos
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

### Stage 3: User-Specific Environment Variables
**Goal**: Encrypt ~/.config/.env per-user

#### Option A: Single User Secrets (Your Current Need)
For tlh on bagalamukhi only:

```bash
# In secrets repo structure:
nix-secrets/
├── .sops.yaml
├── secrets.yaml          # System-wide secrets
└── users/
    └── tlh/
        └── env.yaml      # User-specific encrypted env vars
```

**env.yaml structure**:
```yaml
# Encrypted with sops
OPENAI_API_KEY: ENC[...]
ANTHROPIC_API_KEY: ENC[...]
GITHUB_TOKEN: ENC[...]
# etc.
```

**NixOS integration**:
```nix
# modules/home-manager/programs/env-loader.nix
{ config, lib, pkgs, inputs, ... }:
with lib; {
  options.modules.programs.env-loader = {
    enable = mkEnableOption "encrypted environment variable loader";
  };

  config = mkIf config.modules.programs.env-loader.enable {
    # Decrypt env.yaml and export variables at login
    programs.zsh.initExtra = mkIf config.programs.zsh.enable ''
      # Load encrypted env vars if they exist
      if [ -f ${inputs.nix-secrets}/users/${config.home.username}/env.yaml ]; then
        eval "$(sops --decrypt --extract '["env"]' ${inputs.nix-secrets}/users/${config.home.username}/env.yaml | \
          jq -r 'to_entries | .[] | "export \(.key)=\(.value)"')"
      fi
    '';
    
    programs.bash.initExtra = mkIf config.programs.bash.enable ''
      # Same as above
    '';
  };
}
```

#### Option B: Multi-Host User Secrets (Future)
When you need tlh on both bagalamukhi AND matangi VM:

```yaml
# .sops.yaml
creation_rules:
  - path_regex: users/tlh/env\.yaml$
    key_groups:
      - pgp:
          - *tlh_gpg
        age:
          - *bagalamukhi
          - *matangi  # Add VM host key
```

### Stage 4: Automation - Enhanced install.sh

**New flags**:
- `--no-secrets`: Skip secrets setup (current behavior)
- `--bootstrap-secrets`: Run Stage 2 interactively after install
- `--secrets-repo <url>`: Use existing secrets repo

**Enhanced workflow**:
```bash
# Fresh install with secrets bootstrap
./install.sh --host matangi --bootstrap-secrets

# This will:
# 1. Do Stage 1 (install without secrets)
# 2. Reboot
# 3. On first login, prompt to run Stage 2
# 4. Guide user through gh auth, secrets repo setup
```

## Security Considerations

### ✅ Maintains Your Requirements
1. **Secrets repo stays private**: Not in public nixos-config
2. **SSH key password separate from user password**: Host keys vs. user GPG keys
3. **GPG commit signing independent**: Can use different key or generate new
4. **No trust in public encryption**: Secrets only in private repo with sops-nix

### 🔐 Additional Security
1. **Age keys derived from SSH host keys**: Tied to hardware
2. **Per-user encrypted env vars**: ~/.config/.env equivalent via sops
3. **Multiple key types**: Both PGP (for human) and age (for hosts)
4. **Audit trail**: Git history of who/when secrets access granted

## Implementation Priority

### Phase 1 (Immediate - Manual Workflow)
1. **Document bootstrap process** in `.assets/BOOTSTRAP_SECRETS.md`
2. **Create `bootstrap-secrets.sh`**: Interactive Stage 2 script
3. **Create user env module**: `modules/home-manager/programs/env-loader.nix`
4. **Test**: Bootstrap secrets for tlh@bagalamukhi only

### Phase 2 (Future - Automation)
1. **Enhance `install.sh`**: Add `--bootstrap-secrets` flag
2. **Auto-detect**: Check if secrets repo exists, offer to add new host
3. **VM support**: Handle tlh on matangi VM with shared secrets

### Phase 3 (Polish)
1. **Error recovery**: Handle failed auth, missing keys gracefully
2. **Multi-user**: Support smg@matangi with separate secrets
3. **Backup**: Document GPG key backup/recovery process

## Example: Complete Flow for New Host

```bash
### STAGE 1: Live-ISO Install ###
# Boot chhinamasta ISO
./install.sh --no-secrets --host matangi

# Script outputs:
# "SSH host pubkey: ssh-ed25519 AAAAC3... root@matangi"
# "Age pubkey: age1qqw8..."
# [User writes these down or takes photo]

# System reboots

### STAGE 2: First Boot ###
# Login as user
su - smg  # or tlh
cd /etc/nixos

# Authenticate to GitHub
gh auth login --web
# [Opens browser, user authenticates]

# Run bootstrap
sudo ./bootstrap-secrets.sh --host matangi

# Script prompts:
# "Enter age pubkey for matangi: " [paste from Stage 1]
# "Import existing GPG key? (y/n): " n
# "Generate new GPG key? (y/n): " y
# [Interactive gpg --full-generate-key]
# "Create new secrets repo? (y/n): " n
# "Enter secrets repo URL: " git@github.com:user/nix-secrets.git

# Script:
# - Clones secrets repo
# - Adds matangi to .sops.yaml
# - Re-encrypts secrets with new key
# - Commits and pushes
# - Updates flake.nix input
# - Runs nixos-rebuild

### STAGE 3: Setup User Env Vars ###
cd ~/nix-secrets
mkdir -p users/smg

# Create env.yaml
cat > users/smg/env.yaml.plain <<EOF
OPENAI_API_KEY: sk-...
ANTHROPIC_API_KEY: sk-ant-...
EOF

# Encrypt with sops
sops --encrypt users/smg/env.yaml.plain > users/smg/env.yaml
rm users/smg/env.yaml.plain

# Commit
git add users/smg/env.yaml
git commit -S -m "Add environment variables for smg@matangi"
git push

# Enable in home-manager
# In hosts/matangi/default.nix:
# modules.programs.env-loader.enable = true;

sudo nixos-rebuild switch --flake .#matangi

# Verify
echo $OPENAI_API_KEY  # Should print decrypted value
```

## Questions for User

Before implementing, please confirm:

1. **GitHub auth method**: Prefer `gh auth login --web` or PAT token file?
2. **GPG key strategy**: 
   - Reuse same GPG key across hosts? (import from USB)
   - Generate per-host GPG keys? (easier but more keys to manage)
   - Skip GPG on some hosts? (use SSH signing instead)
3. **Secrets repo location**: 
   - Same for all users? (e.g., tlh and smg share nix-secrets repo)
   - Per-user repos? (tlh-secrets, smg-secrets)
4. **User env vars scope**:
   - Only tlh@bagalamukhi for now?
   - Plan to share tlh secrets across bagalamukhi and matangi?
5. **VM considerations**: 
   - Will matangi VM need access to tlh's secrets?
   - Or only tlh@bagalamukhi and smg@matangi (separate)?

## Next Steps

1. Review this design
2. Answer questions above
3. I'll implement Phase 1 (manual workflow):
   - `bootstrap-secrets.sh`
   - `env-loader.nix` module
   - `BOOTSTRAP_SECRETS.md` documentation
4. Test on bagalamukhi first
5. Iterate based on feedback
