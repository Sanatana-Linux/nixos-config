# Sanatana Linux

> सनातन SANĀTANA a. (-नी f.) 1. Perpetual, constant, eternal, permanent; ज्वलन्मणिव्योमसदां सनातनम् Ki.8.1; एष धर्मः सनातनः. 2. Firm, fixed, settled; एष धर्मः सनातनः U.5.22. 3. Primeval, ancient. -तः
>
> [UChicago's DSAL Online Sanskrit Dictionary](https://dsal.uchicago.edu/cgi-bin/app/apte_query.py?qs=Sanatana&matchtype=default)

<img width="100%" height="100%"  src="./assets/dreams.gif" alt="Palm trees aflame on Bikini Atoll in the early 1960s as part of US thermonuclear testing in the Pacific" align="center" />

**Note:** While I hope you can gain from my configuration and have attempted, for my own sake at least, to document what is going on in the configuration as thoroughly as possible, this is my configuration and is liable to broken as I am still piecing the whole Nix ecosystem together from its many disjointed pieces and ambiguous terminology.

## What and Why of NixOS

Just as `notion.so` has opened up a dark potential to fully over

## Installation

To install it see the next steps:

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

# to install the wayland version
nixos-install --flake '.#fancy' --impure
```

> You could get some hashes errors, just change the bad hashes in the config file to the given ones by the Nix Output.

- Reboot, login as root, and change the password for your user using `passwd` (by default, it's alpha)
- Log-in in the displayManager.
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

### Note About Submodules

The way that I have set up the inclusion as is of several pieces of this configuration that
are included as submodules is that if the directory already exists on the system during a
`nixos-build switch`, the configuration from the submodules will not be included.

This is because that means I can locally clone the submodule and work on it locally, then
run the typical git commands locally as they will not have been checked out at a specific
commit and detatched from the repository's HEAD.

This makes for a cleaner experience working on those pieces of my overall system than creating
a monorepo and enables a style of compartmentalization that I find more productive and is the
way that professional projects are administered as well, but requires me to explain in order
for those trying to find inspiration in this configuration to be able to best determine how
it is working, a labor I clearly don't mind considering my reputation as a `wall post` generator.

### Note on Effort Duplication

While submodules provide my other projects needed for this one, recently I have overcome the need
to reinvent wheels, which in development is known as effort duplication and

---

## Enjoy

I hope you find something useful or something that enables you to come to a better understanding
of NixOS, flakes, etc. While new documentation is in the works according to the NixOS project, and
many resources are available to give you some insight (even if a gold standard remains
elusive), some of which are listed below for your benefit.

Keep in mind, that I am using this as my personal configuration, it is subject to change
as I am often stumbling upon information that deepens my own knowledge (and tend to immeadiately
apply it even if it means large rewrites of critical code such as this because its a personal project).

If you are confused, want better explainations, find an error/ineffciency in this repo or even just want to tell me that all I have done for the last several years has been a complete waste of time (hey Mom!), just open an issue and I will respond when I notice it (my life is chaos so sometimes this may take a while, you can also email me [here](mailto:me@thomasleonhighbaugh.me).

## Credit Where It's Due

Thanks to these configurations and their authors that I was able to

### NixOS + awesomewm

- [AlphaTechnolog's nixdots](https://github.com/AlphaTechnolog/nixdots)
- [MCotocel's nixdots](https://github.com/MCotocel/nixdots)
- [JavaCafe01's frostedflakes]
- [rxyhn's yuki](https://github.com/rxyhn/yuki)
- [nuxshed's dotfiles](https://github.com/nuxshed/dotfiles)
- [hlissner's dotfiles](https://github.com/hlissner/dotfiles)

### More Generalized NixOS + Flakes

- [devos example provided by digga](https://github.com/divnix/digga/tree/main/examples/devos)
- [GTrunSec's nixos-flk](https://github.com/GTrunSec/nixos-flk)
- [thiagokokada/nix-configs](https://github.com/thiagokokada/nix-configs)
- [lourkeur's distro](https://github.com/lourkeur/distro)
-

## ISO

Mostly a personal reminder of how to generate the iso

```bash
 doas nixos-generate --flake '/etc/nixos/#live-usb' --format iso -o sanatana_linux
```
