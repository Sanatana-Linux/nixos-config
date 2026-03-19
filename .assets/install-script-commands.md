# Installation Script Documentation

## Quick Start

From the NixOS Installation ISO, run:

```bash
nix-env -iA nixos.wget
wget https://raw.githubusercontent.com/Sanatana-Linux/nixos-config/main/.assets/install.sh -O install.sh
chmod +x install.sh
bash install.sh
```

For the complete installation guide with detailed steps, see the [Quickstart Guide](../.documentation/quickstart.md).

## Features

The installation script supports:

- **Automatic Partitioning**: GPT partition scheme with EFI and root partitions
- **LUKS Encryption**: Optional full-disk encryption with LUKS1
- **LVM Setup**: Logical volume management for flexible partitioning
- **Additional Disk Support**: Configure secondary disks with optional encryption
- **Hardware Configuration**: Automatic generation of hardware-configuration.nix
- **Flake-based Installation**: Seamless integration with this flake repository

## Additional Disk Configuration

During installation, you will be prompted to configure an additional disk. The installer supports:

- **Partitioning**: Automatically partitions the additional disk with GPT
- **Encryption**: Optional LUKS encryption using the same passphrase as your main disk
- **Mount Points**: Custom mount point selection (e.g., `/data`, `/home/storage`, `/mnt/backup`)
- **Automatic Configuration**: Generated `hardware-configuration.nix` includes the additional disk with proper UUID and mount options

### Encrypted Additional Disks

If you choose to encrypt the additional disk:
- Uses LUKS1 encryption (same as main disk)
- Same passphrase as the main installation disk
- Both disks will unlock during boot (may require manual keyfile configuration for fully automatic unlock)
- The installer adds configuration notes to your `hardware-configuration.nix` for manual LUKS setup if needed

### Unencrypted Additional Disks

If you choose not to encrypt:
- Formatted as ext4
- Mounted with `nofail` option (system boots even if disk is unavailable)
- Automatically added to `hardware-configuration.nix` filesystem entries

## Post-Installation

After installation completes:

1. **Change Default Password**: `passwd`
2. **Set Configuration Ownership**: `doas chown -R $USER:users /etc/nixos`
3. **Configure Git**: `git config --global --add safe.directory /etc/nixos`

For complete post-installation steps, see the [Quickstart Guide](../.documentation/quickstart.md#post-installation).
