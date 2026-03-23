# NixOS Installation Quickstart

> [!NOTE]
> This is a personal reference guide for installing NixOS using the automated installation script. This assumes you're booting from the chhinamasta live ISO or the official NixOS installer.

## Prerequisites

- Bootable NixOS installer USB (chhinamasta ISO or official NixOS ISO)
- Internet connection
- Target machine ready for installation (all data will be erased)

## Installation Steps

### 1. Boot into Live Environment

Boot from your USB installer. You should land in a live NixOS environment.

### 2. Setup Nix Environment

Load necessary packages into a temporary shell environment:

```bash
nix-shell -p git curl wget
```

### 3. Download and Run Installation Script

Pull the installation script directly from GitHub and execute it:

```bash
curl -L https://raw.githubusercontent.com/Sanatana-Linux/nixos-config/main/.assets/install.sh -o /tmp/install.sh
chmod +x /tmp/install.sh
sudo /tmp/install.sh
```

**What the script does:**

- Prompts for target disk selection
- Sets up partitioning (LVM + LUKS encryption)
- Formats and mounts filesystems
- Clones this repository to `/mnt/etc/nixos`
- Generates hardware configuration
- Prompts for host selection (bagalamukhi, matangi, chhinamasta)
- Runs `nixos-install`
- Prompts for root password

### 4. First Boot

After installation completes, reboot into your new system:

```bash
reboot
```

Remove the USB drive during reboot.

### 5. Login

You'll be prompted for the LUKS encryption password, then:

- Login as your user (tlh for bagalamukhi, smg for matangi)
- Default password is set in the configuration (change it immediately!)

## Post-Installation

After first boot, complete these setup steps:

### 1. Change Default Password

**IMPORTANT**: Change your user password immediately!

```bash
passwd
```

### 2. Set Configuration Ownership

The configuration is installed in `/etc/nixos` and owned by root. Change ownership to your user:

```bash
doas chown -R $USER:users /etc/nixos
```

### 3. Configure Git Safe Directory

Prevent git from complaining about directory ownership:

```bash
git config --global --add safe.directory /etc/nixos
```

### 4. Fork Repository (Optional)

If you want to maintain your own fork instead of tracking the upstream repository:

```bash
cd /etc/nixos

# Remove the upstream remote
git remote remove origin

# Add your own fork as origin
git remote add origin git@github.com:yourusername/nixos-config.git

# Make initial commit and push
git add .
git commit -m 'Initial commit from Sanatana-Linux base'
git push -u origin main
```

### 5. Apply Configuration Changes

After making any changes to the configuration:

```bash
cd /etc/nixos

# Stage your changes
git add .
git commit -m 'Description of changes'

# Rebuild the system
sudo nixos-rebuild switch --flake .#$(hostname)
```

**Note**: Use `sudo` instead of `doas` for `nixos-rebuild` as it requires root privileges.

## Secrets Management (Optional)

If you want to set up encrypted secrets management (API keys, private credentials, etc.), follow the appropriate workflow below depending on whether you're setting up secrets for the first time or adding a new host to an existing secrets repository.

For detailed information about how sops-nix works, see [Secrets Management with sops-nix](.documentation/sops-nix-guide.md).

### First Time Secrets Setup

If you don't have a secrets repository yet, follow these steps to create one:

#### 1. Get This Host's Age Key

The age key is derived from the SSH host key and is needed for sops to decrypt secrets on this machine.

```bash
sudo cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
```

**Copy this key** - you'll need to add it to `.sops.yaml` in the next steps.

#### 2. Authenticate to GitHub

```bash
gh auth login
```

This opens a browser for GitHub OAuth authentication and grants access to your private repositories.

#### 3. Create Private Secrets Repository

```bash
gh repo create nix-secrets --private --clone
cd ~/nix-secrets
```

#### 4. Run Setup Script

The setup script will guide you through creating `.sops.yaml` and initial secrets structure:

```bash
cd /etc/nixos
./.assets/setup_secrets.sh
```

Follow the prompts to:

- Provide your GPG key fingerprint (for manual editing)
- Add the age key from step 1 (for automatic decryption)
- Create initial `secrets.yaml` structure

#### 5. Update Your NixOS Configuration

Add the secrets repository as a flake input in `flake.nix`:

```nix
inputs.nix-secrets = {
  url = "git+ssh://git@github.com/yourusername/nix-secrets.git";
  flake = true;
};
```

Then reference secrets in your modules:

```nix
sops.secrets.example = {
  sopsFile = inputs.nix-secrets.sopsFile;
};
```

#### 6. Rebuild with Secrets

```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake .#$(hostname)
```

### Adding New Host to Existing Secrets Repository

If you already have a secrets repository and want to add this new host:

#### 1. Get This Host's Age Key

The age key is derived from the SSH host key and is needed for sops to decrypt secrets on this machine.

```bash
sudo cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
```

**Copy this key** - you'll need to add it to `.sops.yaml` in the next steps.

#### 2. Authenticate to GitHub

```bash
gh auth login
```

This opens a browser for GitHub OAuth authentication and grants access to your private repositories.

#### 3. Clone Your Private Secrets Repository

```bash
gh repo clone yourusername/nix-secrets ~/nix-secrets
cd ~/nix-secrets
```

Replace `yourusername/nix-secrets` with your actual private secrets repository.

#### 4. Add This Host to .sops.yaml

Edit `.sops.yaml` and add the age key from step 1:

```bash
$EDITOR .sops.yaml
```

Add your host's age key to the configuration:

```yaml
creation_rules:
  - path_regex: .*.yaml
    pgp:
      - &your_gpg_key XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    age:
      - &bagalamukhi XXXXXXXXX... # Paste the age key from step 1
```

#### 5. Re-encrypt Secrets with New Host Key

```bash
sops updatekeys secrets.yaml
```

This re-encrypts all secrets so this host can decrypt them.

#### 6. Commit and Push Changes

```bash
git add .sops.yaml secrets.yaml
git commit -S -m "Add $(hostname) to secrets access"
git push
```

#### 8. Rebuild NixOS with Secrets

```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake .#$(hostname)
```

#### 9. Verify Secrets Access

After rebuild, secrets should be available in `/run/secrets/`:

```bash
ls -la /run/secrets/
```

## Troubleshooting

### Script fails during partition setup

- Check disk device name: `lsblk`
- Ensure disk is not mounted: `umount -R /mnt`
- Verify disk is correct target (all data will be erased!)

### Can't authenticate to GitHub

- Ensure internet connection: `ping github.com`
- Install GitHub CLI: `nix-shell -p gh`
- Try PAT authentication: `gh auth login --with-token < token.txt`

### Secrets won't decrypt after rebuild

- Verify host age key was added to `.sops.yaml`
- Check sops configuration: `cat ~/nix-secrets/.sops.yaml`
- Re-run: `sops updatekeys secrets.yaml`
- Ensure flake.nix includes nix-secrets input

### GPG key not found for commit signing

- Import existing key: `gpg --import < your-key.asc`
- Or generate new: `gpg --full-generate-key`
- Add to GitHub: `gh gpg-key add`

## Quick Reference Commands

```bash
# Check system status
om rebuild $(hostname)

# Update flake inputs (after first install)
om update

# Test config without switching
sudo nixos-rebuild test --flake .#$(hostname)

# Build specific host
sudo nixos-rebuild switch --flake .#bagalamukhi

# Edit secrets (from secrets repo)
cd ~/nix-secrets
sops secrets.yaml

# Check secrets in running system
ls -la /run/secrets/

# View hardware config
cat /etc/nixos/hosts/$(hostname)/hardware-configuration.nix
```

## Summary Workflow

```bash
# On live ISO
nix-shell -p git curl wget
curl -L https://raw.githubusercontent.com/Sanatana-Linux/nixos-config/main/.assets/install.sh -o /tmp/install.sh
sudo /tmp/install.sh
# Follow prompts, reboot

# On first boot (optional secrets setup)
cd ~/nixos
./.assets/bootstrap-host-secrets.sh
# Follow interactive guide

# Done!
```

## See Also

- [Installation with Encryption](./installation-with-encryption.md) - Manual installation steps (reference)
- [Secrets Management](./secrets.md) - Detailed secrets strategy
- [SOPS Documentation](./sops.md) - sops-nix integration details
- [AGENTS.md](../AGENTS.md) - Developer workflow and module guidelines
