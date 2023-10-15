# Installation

> NOTE: This is my bootstrapping process, yours probably will vary.

- Boot into the installer environment
- Format and mount your disks inside /mnt
- execute the following in terminal:

```sh
# Jump into a root shell head first
sudo su

# Get the nix shell with the features you need
nix-shell -p git nixUnstable neovim

# Create the /etc/ file you'll be working in
mkdir -p /mnt/etc/

# clone the repo
git clone https://github.com/Sanatana-Linux/nixos-config /mnt/etc/nixos

# Remove my hardware-configuration file
rm /mnt/etc/nixos/hosts/hp-laptop-amd/hardware-configuration.nix

# Generate the config, move it in place and remove the extraneous configuration file
nixos-generate-config --root /mnt
rm /mnt/etc/nixos/configuration.nix
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/hp-laptop-amd

# Ensure you are in the correct directory
cd /mnt/etc/nixos

# to install the xorg version:
nixos-install --flake '.#hp-laptop-amd' --impure

```

> You could get some hashes errors, just change the bad hashes in the configuration file to the given ones by the Nix Output.

- Reboot, login as root, and change the password for your user using `passwd`
- Log-in in to the display manager.
- Then:

```sh
# changes ownership, will still build but now complains less when syncing with Git
doas chown -R $USER /etc/nixos
```

- Since you will probably want to change things, that is done with the following commands:

```bash
# If you want your own repo, you will have to delete the existing .git and make your own
git init

# First you must commit the changes to update the flake.lock
git add .
git commit -m 'steep learning curves bruh'

# then you can rebuild your configuration as normal with the changes available to the nix store
nixos-rebuild switch --impure --flake '/etc/nixos#hp-laptop-amd'

```

<img src="../.github/assets/patrick-meme.jpg" width="400px" alt="Patrick Star wearing a shirt about wanting to be picked up by his mother because he is scared. This is to make a light joke at my own and the reader's expense about the overwhelming aspects of the bootstrap process"/>
