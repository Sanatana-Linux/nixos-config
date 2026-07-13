# Lenovo Advanced BIOS Baked Into NixOS Configuration

My initial efforts to install NixOS on my new Lenovo Legion laptop, equipped with a 14th generation Intel Core i9 processor, were immediately thwarted by critical system instability during the installation process and hardly something I could blame Nvidia's drivers for. Specifically, when attempting to deploy my custom NixOS configuration tailored to the system's hardware via my home-rolled flake, the installation process consistently failed due to system overheating causing the system to reboot and when booting via Live USB this means back to square one for the most part. It quickly became evident that indeed thermal issues were the primary cause. Under even moderate load during the early phases of the NixOS installation environment,long before anything involving CUDA sought to get compiler time, the CPU was generating excessive heat, triggering thermal protection mechanisms that forced an abrupt system reboots to prevent potential hardware damage. After obtaining the latest firmware for the system and the latest microcode available for the CPU using the Windows installation I keep isolated to little more NVME space than its debloated install requires for these purposes, the problem remained and research indicated I would likely benefit from undervolting.

## When There Is No Obvious Solution, I Dive Deeper Into the Rabbit Hole

While several well regarded tools are available for Windows to achieve these ends, that does me
little good as I happen to like my NixOS environment and have used Linux too long now to even
consider giving up full control of my own hardware. Furthermore, Linux based undervolting software
would be of little help to me while trying to install via a Live USB environment I needed to install
my own environment in which such tools could be utilized within. Luckily, there
were murmurings about the internet that there was something known as the "Advanced BIOS" that one
could unlock for certain systems including my own. None of the key combinations did anything,
frankly I felt like one of BF Skinner's superstitious pigeons bobbing its head a certain number of
times hoping food pellets would dispense doing them. However, obsessive research does pay off and
I eventually found a set of EFI executables that in combination with a specific configuration file,
collectively referred to as SREP, when placed on a FAT32 USB drive would unlock the Advanced BIOS
if the system were booted to this USB!

## Problem Solved

The logic underlying the SREP configuration and EFI executables is hardly magic, though a detailed
description is out of scope for this particular post-mortem so I will let the reader discover as
much for themselves for now. Needless to say, I was thus able to access the lower level BIOS
settings, apply voltage limits to the CPU that were shickingly not set by default, thus the system
was stable enough to run through the `nixos-install --flake .#flake --impure` process and the rest
is history.

## Paying It Forward

Yet I didn't stop there, having made my own custom ISO of Arch Linux and its cariants in the past,
I realized I could package the EFI executables together with the SREP configuration file into an ISO
file and then it would be as easy as flashing to a USB for anyone interested in accessing Advanced
BIOS on systems that are similar to my own. So I did that, while posting the while mess of files on
GiyHub and offering the ISO in a release on [that repo](https://github.com/Thomashighbaugh/Lenovo-Legion-Advanced-Bios) as my way of giving back since it was other people freely offering their work that enabled me to do this in the first place, it's the least I can do.

## Taking It A Step Further

While I now configure most of my undervolting related settings via the undervolt service at runtime,
I sometimes want to boot into Advanced BIOS and check things out, if not tinker a bit to squeeze out
a little better performance and booting to a USB which I keep configured for this task can be
a clunky way to do this, if not a barrier to such.

But including the SREP files in my NixOS configuration and having Grub load them if I select a menu
entry from the Grub menu is easy enough and with NixOS' declarative configuration something i can
set once and forget about, tibial after the initial setup. So that's exactly what I did and is
available for anyone to check out for themselves
[here](https://github.com/Sanatana-Linux/nixos-config/blob/main/hosts/bagalamukhi/default.nix#L162).

Now to get an icon to load next to the menu entry's title...
