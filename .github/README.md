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
> While I hope you can gain from my configuration and have attempted, for my own sake at least, to document what is going on in the configuration as thoroughly as possible, this is my configuration and is liable to broken as I am still piecing the whole Nix ecosystem together from its many disjointed pieces and ambiguous terminology.

## The NixOS Experience Summarized in a Digestible Format

<img src="./assets/NIXOS-LEARNING-CURVE.jpg" width="100%" alt="Tux as the deranged husband in the Shining that approximates the process of learning how to deal with NixOS"/>

### "What About the Documentation?"

Documentation for NixOS, especially since it has pivoted towards flakes you want?
<img src="./assets/jack-nicholson-laugh.gif" alt="Jack Nicholson laughing while on an airplane, suggesting there is not documentation to the degree suggesting as much induces hysterical laughing" />

There is plenty, some are better than others but comparatively it is easier to find high quality guides on making caustic chemicals with cleaning products than finding anything that is going to impart the wisdom of the Nix upon you. The only reasonable way involves trial and error. Lots and lots of error.

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
- [rxyhn's yuki](https://github.com/rxyhn/yuki)
- [nuxshed's dotfiles](https://github.com/nuxshed/dotfiles)
- [hlissner's dotfiles](https://github.com/hlissner/dotfiles)

### More Generalized NixOS + Flakes

- [devos example provided by digga](https://github.com/divnix/digga/tree/main/examples/devos)
- [GTrunSec's nixos-flk](https://github.com/GTrunSec/nixos-flk)
- [thiagokokada/nix-configs](https://github.com/thiagokokada/nix-configs)
- [lourkeur's distro](https://github.com/lourkeur/distro)
- tons more I will add later if I remember to ;]

## ISO

Mostly a personal reminder of how to generate the iso

```bash
 doas nixos-generate --flake '/etc/nixos/#live-usb' --format iso -o sanatana_linux
```
