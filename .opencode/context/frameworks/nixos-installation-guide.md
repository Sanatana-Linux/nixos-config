---
title: "NixOS Installation Guide"
type: concept
tags: [installation, live-iso, lvm, luks, chhinamasta]
created: 2026-07-15
updated: 2026-07-15
sources: [.documentation/quickstart.md, .documentation/iso.md, .documentation/live-usb.md]
status: active
---

# NixOS Installation Guide

## Overview

Installation workflow for deploying this configuration from the chhinamasta live ISO or the official NixOS installer. The automated script handles partitioning (LVM + LUKS), cloning, and `nixos-install`.

## Building the Live ISO

```bash
# Build the chhinamasta ISO
nix build /etc/nixos#nixosConfigurations.chhinamasta.config.system.build.isoImage

# Or using nixos-generate
doas nixos-generate --flake '/etc/nixos/#live-usb' --format iso -o sanatana_linux
```

## Writing to USB

```bash
lsblk -f
sudo dd bs=4M if=result/iso/nixos.iso of=/dev/sdX status=progress oflag=sync
```

## Installation Steps

### 1. Boot into Live Environment
Boot from the USB installer into the live NixOS environment.

### 2. Setup Nix Environment
```bash
nix-shell -p git curl wget
```

### 3. Download and Run Installation Script
```bash
curl -L https://raw.githubusercontent.com/Sanatana-Linux/nixos-config/main/.assets/install.sh -o /tmp/install.sh
chmod +x /tmp/install.sh
sudo /tmp/install.sh
```

The script handles:
- Target disk selection
- Partitioning (LVM + LUKS encryption)
- Formatting and mounting
- Cloning the repository to `/mnt/etc/nixos`
- Hardware configuration generation
- Host selection (bagalamukhi, matangi, chhinamasta)
- `nixos-install` execution
- Root password prompt

### 4. First Boot
Reboot, remove USB, enter LUKS password. Login as your user (tlh/smg/user).

## Post-Installation

### Change Password
```bash
passwd
```

### Set Ownership
```bash
doas chown -R $USER:users /etc/nixos
```

### Configure Git
```bash
git config --global --add safe.directory /etc/nixos
```

## Secrets Management Setup

Secrets are managed via sops-nix with age encryption (based on SSH host keys). Each host's `/etc/ssh/ssh_host_ed25519_key.pub` is converted to an age key and added to `external/secrets/.sops.yaml`.

**Key file**: `external/secrets/secrets.yaml` (single encrypted YAML, shared across all hosts)

For detailed workflow, see [[nix-secrets-reference]] and the [sops-nix guide](https://github.com/Mic92/sops-nix).

## Quick Reference

```bash
# Build specific host
sudo nixos-rebuild switch --flake .#bagalamukhi

# Test config without switching
sudo nixos-rebuild test --flake .#$(hostname)

# Enter dev shell
nix develop

# Edit secrets
cd external/secrets && sops secrets.yaml
```
