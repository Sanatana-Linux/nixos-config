# Sanatana Linux

> सनातन SANĀTANA (adjective)
>
> 1.  Perpetual, constant, eternal, permanent
> 2.  Firm, fixed, settled;
> 3.  Primeval, ancient. ः
>
> [UChicago's DSAL Online Sanskrit Dictionary](https://dsal.uchicago.edu/cgi-bin/app/apte_query.py?qs=Sanatana&matchtype=default)

<img width="100%" height="100%"  src="./assets/eternal.gif" alt="A gif symbolic of eternity that features a rotating triangle that when pointed upwards is analoguous to the Deva symbol and when pointed down is symbolic of the Devi, thus subtly referring to the Divine in both essential aspects." align="center" />

---

> **Warning**
>
> While I hope you can gain from my configuration and have attempted, for my own sake at least, to document what is going on in the configuration as thoroughly as possible, this is my configuration that I use personally and as such it is reasonable to assume it is unstable and a work in progress.

---

## Installation

> NOTE: This is my bootstrapping process, yours probably will vary.

<img src="./assets/patrick-meme.jpg" width="100%" alt="Patrick Star wearing a shirt about wanting to be picked up by his mother because he is scared. This is to make a light joke at my own and the reader's expense about the overwhelming aspects of the bootstrap process"/>

- Boot into the installer environment
- Format and mount your disks inside /mnt
- execute this

```sh
# Jump into a root shell head first
sudo su

# Get the nix shell with the features you need
nix-shell -p git nixUnstable

# Create the /etc/ file you'll be working in
mkdir -p /mnt/etc/

# clone the repo
git clone https://github.com/the-Electric-Tantra-Linux/nixos-config /mnt/etc/nixos --recurse-submodules

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

> You could get some hashes errors, just change the bad hashes in the config file to the given ones by the Nix Output.

- Reboot, login as root, and change the password for your user using `passwd`
- Log-in in to the display manager.
- Then do this:

```sh
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

---

## Enjoy

I hope you find something useful or something that enables you to come to a better understanding
of NixOS, flakes, etc when reviewing this configuration and encourage you to use whatever portions of this code you would like for your own purposes, whatever they may be.

### Feel Free to Get in Touch!

If you are confused, want better explanations, find an error/inefficiency in this repo or even just want to tell me that all I have done for the last several years has been a complete waste of time (hey Mom!), just open an issue and I will respond when I notice it (my life is chaos so sometimes this may take a while, you can also email me [here](mailto:me@thomasleonhighbaugh.me).

## Credit Where It's Due

This configuration, like many if not most others, owes a huge debt of gratitude to other configurations that have inspired it and provided many snippets, organizational patterns and epiphanies when rummaged through.

### NixOS + awesomewm

- [rxyhn's yuki](https://github.com/rxyhn/yuki)
- [chadcat7's fuyu](https://github.com/chadcat7/fuyu)
- [AlphaTechnolog's nixdots](https://github.com/AlphaTechnolog/nixdots)
- [MCotocel's nixdots](https://github.com/MCotocel/nixdots)
- [rxyhn's yuki](https://github.com/rxyhn/yuki)
- [nuxshed's dotfiles](https://github.com/nuxshed/dotfiles)
- [hlissner's dotfiles](https://github.com/hlissner/dotfiles)

### More Generalized NixOS + Flakes

- [devos example provided by digga](https://github.com/divnix/digga/tree/main/examples/devos)
- [GTrunSec's nixos-flk](https://github.com/GTrunSec/nixos-flk)
- [thiagokokada/nix-configs](https://github.com/thiagokokada/nix-configs)
- [lourkeur's distro](https://github.com/lourkeur/distro)
- [cole h's nixos-config](https://github.com/cole-h/nixos-config)
- [viperML's dotfiles](https://github.com/viperML/dotfiles)

...and a whole lot more, see below

#### Additional Lists of NixOS Resources

- [My NixOS stars list](https://github.com/stars/Thomashighbaugh/lists/nixos)
- [NixOS Wiki's Configuration Collection](https://nixos.wiki/wiki/Configuration_Collection)
- [Awesome Nix List](https://github.com/nix-community/awesome-nix)
- [Comparison of NixOS Setups](https://nixos.wiki/wiki/Comparison_of_NixOS_setups)
- [NixOS Wiki's Resources Page](https://nixos.wiki/wiki/Resources)

## ISO

Mostly a personal reminder of how to generate the iso

```bash
 doas nixos-generate --flake '/etc/nixos/#live-usb' --format iso -o sanatana_linux
```
