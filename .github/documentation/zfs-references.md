# LVM + Encryption References

[Guide to LVM + Encryption on VM](https://mudrii.medium.com/nixos-native-flake-deployment-with-luks-drive-encryption-and-lvm-b7f3738b71ca) - [Related Repository](https://github.com/mudrii/systst) - [Encryption Options for LVM](https://github.com/thblt/nixos-config/blob/main/configuration-maladict.nix#L24-L30) - [Install Script Doing This For User](https://github.com/1000101/ni/blob/master/install.sh) - Maybe implementing a modified version would be a good idea?

# Secure Boot References

Looking to implement secure boot, disk encryption via Luks, TPM unlocking and `all that jazz` as a sort of challenge, I am not actually paranoid being too cynical for such absurd notions.

[Secure Boot with Systemd-boot turned off](jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde) - You can brew hemlock tea for me to drink if it bothers you that I don't think Grub is buggy or clunky, just that people saying that are probably unwilling to overcome its learning curve that isn't even that bad.

[Grub patching from AUR](https://discourse.nixos.org/t/is-there-grub-patched-for-booting-from-partition-encrypted-with-luks2/18398)

[Lanzaboote Quickstart](https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md)

[SD Card for Bootloading, Remove it and HDD appears unformatted](https://shen.hong.io/installing-nixos-with-encrypted-root-partition-and-seperate-boot-partition/) - super overkill but interesting

[NixOS Discourse where it is pointed out that Grub doesn't need to understand the encrypted root](https://discourse.nixos.org/t/nixos-grub-2-luks-lvm-issue/19996)

# ZFS References

Considering using ZFS, so here are some references from my cursory research on the topic that may be helpful if I do: - [NixOS Root on ZFS](https://openzfs.github.io/openzfs-docs/Getting Started/NixOS/Root on ZFS.html) - [OpenZFS NixOS Getting Startedz](https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/) - [NixOS Wiki: ZFS](https://wiki.nixos.org/wiki/ZFS#Simple_NixOS_ZFS_installation) - [Encrypted ZFS mirror with mirrored boot on NixOS](https://elis.nu/blog/2019/08/encrypted-zfs-mirror-with-mirrored-boot-on-nixos/)

**Thinking on Matter at Present:** Long term, will be the way to go. Especially if, God willing,
I am ever able to build my own NAS server and have disks larger than 16TB. First, however, I should
work out using LVM as the filesystem for root and getting encryption to work.
