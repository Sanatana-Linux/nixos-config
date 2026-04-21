# Installation Quickstart

Core concept: Automated NixOS installation via script from the chhinamasta live ISO, with optional sops-nix secrets setup.

Key Points:
- Boot live ISO → `nix-shell -p git curl wget` → run install script
- Script handles: partitioning (LVM+LUKS), cloning repo, generating hardware config, nixos-install
- First boot: change password, `doas chown -R $USER:users /etc/nixos`, git safe.directory
- Secrets: sops-nix with age keys derived from SSH host keys
- Rebuild: `sudo nixos-rebuild switch --flake .#$(hostname)`

Example:
```bash
curl -L https://raw.githubusercontent.com/Sanatana-Linux/nixos-config/main/.assets/install.sh -o /tmp/install.sh
sudo /tmp/install.sh
```

Reference: [.documentation/quickstart.md](../../.documentation/quickstart.md)