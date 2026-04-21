# Nix Commands

Core concept: Key Nix flake and system commands for building, updating, and maintaining the configuration.

Key Points:
- `sudo nixos-rebuild switch --flake .#<host>` — build and activate
- `nix flake update` — update all flake inputs (system update)
- `nix flake lock --update-input <input>` — update single input
- `nix build '.#nixosConfigurations.<host>.config.system.build.toplevel'` — dry build
- `nix-collect-garbage -d` — clean old generations
- `nix fmt` — format with alejandra

Example:
```bash
sudo nixos-rebuild switch --flake .#bagalamukhi
nix flake lock --update-input nixpkgs
nix-collect-garbage -d
```

Reference: [.documentation/nix-commands.md](../../.documentation/nix-commands.md)