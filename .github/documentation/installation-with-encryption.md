# Installation + Root Encrption

> [!NOTE]  
> This process is currently being handled by the nifty installation script I put together for fresh installs, _which I may move to using a justfile for_, **we shall see**. Therefore these notes are not my precise workflow but kept as part of my overall research on the subject and in case I opt to move away from using the installation script I will have access to the notes still (which is sort of the point of all this documentation).

Originally sourced and adapted from: [https://github.com/ksevelyar/idempotent-desktop/blob/main/doc/encrypted-root.md](https://github.com/ksevelyar/idempotent-desktop/blob/main/doc/encrypted-root.md)

## 1. Obtain Administrator Access

```
sudo su
```

## Create partitions

Let's assume you will be using `ext4` as your root filesystem, for simplicity's sake.

**References**: - [NixOS Manual - Creating Partitions](https://nixos.org/manual/nixos/stable/index.html#sec-installation-partitioning-UEFI)

```
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 0% 1024MiB
parted /dev/nvme0n1 -- mkpart primary ext4 1024MiB 100%
parted /dev/nvme0n1 -- set 1 esp on
```

## Wipe partition for the future /

```
lsblk -f
```

```
dd if=/dev/zero of=/dev/nvme0n1p2 bs=4M status=progress
dd if=/dev/urandom of=/dev/nvme0n1p2 bs=4M status=progress
```

## Create LUKS2 container

```
cryptsetup luksFormat --type luks2 /dev/nvme0n1p2
cryptsetup config /dev/nvme0n1p2 --label enc-nixos
cryptsetup luksOpen /dev/nvme0n1p2 nixos
```

## Mount

```
mkfs.ext4 -L nixos /dev/mapper/nixos
mount /dev/mapper/nixos /mnt

mkfs.vfat -F 32 -n boot /dev/sda1
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

## Clone configs

```
git clone https://github.com/SanatanaLinux/nixos-config /mnt/etc/nixos
chown -R 1000:users /mnt/etc/nixos

cd /mnt/etc/nixos/
nixos-generate-config --root /mnt
rm /mnt/etc/nixos/configuration.nix
mv hardware-configuration.nix hosts/[hostname]/
nvim hosts/[hostname]/hardware-configuration.nix
```

## Add LUKS2 container to hardware-configuration.nix

```

boot.initrd.luks.devices.nixos = {
  device = "/dev/disk/by-label/enc-nixos";
  allowDiscards = true;
};

fileSystems."/boot" = {
  device = "/dev/disk/by-label/boot";
  fsType = "vfat";
  options = [ "noatime" "nodiratime" ];
};

fileSystems."/" = {
  device = "/dev/disk/by-label/nixos";
  fsType = "ext4";
  options = [ "noatime" "nodiratime" ];
};


```

## Install

```
nixos-install --root /mnt --flake /mnt/etc/nixos#[hostname]
reboot
```

## Result

```
lsblk -f
```

```
nvme0n1
├─nvme0n1p1 vfat        FAT32 boot      E675-3AA7                             392.1M    21% /boot
├─nvme0n1p2 crypto_LUKS 2     enc-nixos 959a5350-4973-4971-a6e5-b725f1fac59e
│ └─root    ext4        1.0   nixos     090b5f4e-bea7-49cb-9ea2-d667019d9966  156.8G    13% /nix/store
│                                                                                           /
└─nvme0n1p4 ntfs              win10     7492024D92021470
```
