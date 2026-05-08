# Lanzaboote — Secure Boot for NixOS

**Source**: https://wiki.nixos.org/wiki/Lanzaboote  
**Ingested**: 2026-05-05  
**Last wiki edit**: 2025-12-29

## Overview

Lanzaboote is a project that enables **Secure Boot** on NixOS with relative ease. It has two main components:

- **`lzbt`** — CLI tool that signs and installs boot files on the ESP
- **`stub`** — A UEFI application that loads the kernel and initrd from the ESP

Currently only available for `nixos-unstable`.

## Requirements

- System installed in **UEFI mode** with **systemd-boot** enabled
- Verify with `bootctl status`

## Setup (Quick Start)

**Source**: https://github.com/nix-community/lanzaboote/blob/master/docs/getting-started/prepare-your-system.md

### 1. Generate Keys

Use `sbctl` (available as `pkgs.sbctl`):

```bash
sudo sbctl create-keys
```

Keys are stored in `/var/lib/sbctl`. Only root can read the secret key.

### 2. Add Flake Input (Flakes method)

```nix
inputs = {
  lanzaboote = {
    url = "github:nix-community/lanzaboote/v1.0.0";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

### 3. Configure NixOS

```nix
{ pkgs, lib, ... }: {
  imports = [ lanzaboote.nixosModules.lanzaboote ];

  environment.systemPackages = [ pkgs.sbctl ];

  # Lanzaboote replaces systemd-boot module
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
```

### 4. Rebuild & Verify

```bash
nixos-rebuild switch
sudo sbctl verify
```

Expected: all files in `/boot/EFI/` should show `✓ is signed`. Kernel images are expected to be unsigned.

## Key Management

- Currently only **local storage** of the keyring is supported
- Future backends planned:
  - Remote signing (HTTP server for signature requests)
  - PKCS#11-based signing (HSM / YubiKey / NitroKey)
- Key management is considered out of scope for the project — users must learn proper key management for effective boot protection

## Differences from systemd-stub

| Aspect | systemd-stub | Lanzaboote stub |
|--------|-------------|-----------------|
| Kernel/initrd per generation | Duplicated for each generation | **Deduplicated** across generations |
| Viability for NixOS | Not realistic (too many generations) | Designed for NixOS's generation model |

## Relevance to This Project

- This project uses **systemd-boot** (configured in `modules/nixos/system/boot.nix`)
- All hosts are UEFI systems with TPM2 support
- Could be integrated as a new module (`modules/nixos/system/lanzaboote.nix`) following the enable-by-option pattern
- Would require: flake input (`github:nix-community/lanzaboote`), key generation, and enrollment in UEFI firmware
