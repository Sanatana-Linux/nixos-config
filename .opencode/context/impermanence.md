# Impermanence

> Source: https://github.com/nix-community/impermanence | License: MIT | ⭐ 1.8k

Choose what files/directories to keep between reboots — the rest are thrown away. Handles persistent state on systems with ephemeral root storage.

## Why

- Keeps system clean by default
- Forces you to declare settings you want to keep
- Lets you experiment without clutter

## System Setup

### Option A: tmpfs root (easiest)

```nix
{
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=25%" "mode=755" ];
  };
  fileSystems."/persistent" = {
    device = "/dev/root_vg/root";
    neededForBoot = true;
    fsType = "btrfs";
    options = [ "subvol=persistent" ];
  };
  fileSystems."/nix" = {
    device = "/dev/root_vg/root";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/XXXX-XXXX";
    fsType = "vfat";
  };
}
```

**Drawbacks**: OOM risk with large downloads; crash = lost unsaved data.

### Option B: BTRFS subvolume rotation

Creates a fresh BTRFS subvolume for root on each boot. Old roots auto-deleted after 30 days. See repo README for the full `boot.initrd.postResumeCommands` script. Allows recovery from crashes.

## Flake Integration

```nix
{
  inputs.impermanence.url = "github:nix-community/impermanence";
  outputs = { self, nixpkgs, impermanence, ... }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      modules = [
        impermanence.nixosModules.impermanence
        ./configuration.nix
      ];
    };
  };
}

# Optional: prune dev deps from lock
{ impermanence.inputs.nixpkgs.follows = "";
  impermanence.inputs.home-manager.follows = ""; }
```

## NixOS Module: `environment.persistence`

```nix
{
  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
    users.tlh = {
      directories = [
        "Downloads" "Music" "Pictures" "Documents" "Videos"
        { directory = ".gnupg"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
        ".local/share/direnv"
      ];
      files = [ ".screenrc" ];
    };
  };
}
```

### Directory options

| Option | Description |
|--------|-------------|
| `directory` | Path to bind-mount to persistent storage |
| `user` / `group` | Ownership (applied on creation only) |
| `mode` | Permissions — octal (`0700`) or symbolic (`u=rwx,g=,o=`) |

### File options

| Option | Description |
|--------|-------------|
| `file` | Path to persist |
| `parentDirectory` | `{ user, group, mode }` for parent dir if missing |
| `method` | `"auto"` (bind mount if exists, symlink otherwise) or `"symlink"` |

### User persistence (`users.<name>`)

Paths are automatically prefixed with the user's home directory.

## Home Manager Module: `home.persistence`

Requires both the NixOS impermanence module AND home-manager NixOS module loaded. Paths are relative to `$HOME`.

```nix
{
  home-manager.users.tlh = {
    home.persistence."/persistent" = {
      directories = [
        "Downloads"
        { directory = ".gnupg"; mode = "0700"; }
      ];
      files = [ ".screenrc" ];
    };
  };
}
```

## Options Summary

| Option | Type | Description |
|--------|------|-------------|
| `enable` | bool | Enable persistence (default: `true`) |
| `hideMounts` | bool | Hide bind mounts in file manager (`x-gvfs-hide`) |
| `allowTrash` | bool | Enable trash support in GTK/GIO apps |
| `directories` | list | Directories to bind-mount |
| `files` | list | Files to link/bind-mount |
| `users.<name>` | submodule | Per-user home directory persistence |

## Critical Notes

- Mark all persistent AND ephemeral storage volumes with `neededForBoot = true`
- The `users` option prefixes paths with `/home/<name>` automatically
- Permissions (`user`, `group`, `mode`) only apply at creation time — changing later has no effect
