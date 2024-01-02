[![Build Status](https://build.lounge.rocks/api/badges/18/status.svg)](https://build.lounge.rocks/repos/18)

# nix

Nixlas OS

## What is this?

This NixOS repository is based on the configuration of [MayNiklas](https://github.com/MayNiklas/nixos).
It uses Nix flakes to achieve a declarative & reproducible system configuration.
Home manager is used to manage dotfiles.

### Documentation

- [Options Reference](https://search.nixos.org/options/)
- [Package Search](https://search.nixos.org/packages/)
- [Home manager search](https://rycee.gitlab.io/home-manager/options.html)
- [NixOS Manual](https://nixos.org/nixos/manual/)
- [NixOS Wiki](https://nixos.wiki/wiki/Main_Page)
- [NixOS on GitHub](https://github.com/NixOS/nixpkgs/)
- [NixOS on Discourse](https://discourse.nixos.org/)
- [NixOS with encrypted root](https://pablo.tools/blog/computers/nixos-encrypted-install/)

### common commands

```bash
# basic flake check
nix flake check

# update flake.lock -> updates all flake inputs (e.g. system update)
nix flake update

# update a single flake input
nix flake lock --update-input nixpkgs

# show contents of flake
nix flake show

# show flake info
nix flake info

# build / check config without applying
nix build -v '.#nixosConfigurations.laptop.config.system.build.toplevel'

# switch to new config
nixos-rebuild --use-remote-sudo switch --flake .

# build flake output
nix build build .#rick-roll

# run flake app
nix run .#rick-roll

# run flake app externally
nix run 'github:mayniklas/nixos#vs-fix'

# run flake app
nix run nixpkgs#python39 -- --version

# run nix-shell with nodejs-14
nix-shell -p nodejs-16_x

# run app in nix-shell
nix-shell -p nodejs-16_x --run "node -v"

# lists all syslinks into the nix store (helpfull for finding old builds that can be deleted)
nix-store --gc --print-roots

# delete unused elements in nix store
nix-collect-garbage

# also delete iterations from boot
sudo nix-collect-garbage -d

# use auto formatter on flake.nix
nix fmt flake.nix
```

## TODO

- Propperly pair Bluetooth with dual-bootet Win10
- NFC
- Wireguard
- Zsh Dotfiles
- Command Line Utilities
- Aarch64 Runner for Gitlab
- Make X220 great again
