# Nix Commands

While all of this is wrapped in a helper script in this configuration, the `nux` script, I find it is valuable to keep around a list anyway `just in case`

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
