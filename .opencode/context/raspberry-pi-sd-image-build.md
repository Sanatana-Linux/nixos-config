---
title: "Building the Raspberry Pi SD Image on x86_64"
type: reference
tags: [raspberry-pi, sd-image, aarch64, binfmt, qemu, dhumavati, flashing, oomd]
created: 2026-11-17
updated: 2026-11-17
status: active
---

# Building the Raspberry Pi SD Image on x86_64

Operational guide for producing the `dhumavati` (Raspberry Pi 3, BCM2837,
aarch64) NixOS SD-card image from an x86_64 build host, flashing it, and
verifying the write. Everything below reflects fixes made after repeated
first-boot failures; each entry in the troubleshooting table is a real symptom
that was hit.

## 1. Build strategy: emulated native, not cross

The image is built **natively for aarch64** through QEMU binfmt emulation on
the x86_64 host. Do not cross-compile.

| Approach | Result |
|----------|--------|
| `nix build --system aarch64-linux` + binfmt | Works. Most paths substitute from `cache.nixos.org`; only the system-specific derivations build under emulation. |
| `crossSystem = aarch64-linux` | Breaks on `wrap-lua-hook`/`boxes` and rebuilds ~1609 derivations instead of ~218. Avoid. |

### Build host requirement

`hosts/bagalamukhi/default.nix` carries the only host-side prerequisite:

```nix
boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
```

Verify before building:

```bash
systemctl is-active systemd-binfmt      # active
ls /proc/sys/fs/binfmt_misc/aarch64-linux
```

Without the binfmt entry, evaluation succeeds but every aarch64 build step
fails with `exec format error`.

## 2. The flake attribute

`flake.nix` exposes the image as a top-level attribute (not a
`nixosConfiguration`), because it is built for a different system than the
host:

```nix
dhumavatiSdImage = (nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  modules = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    inputs.nixos-hardware.nixosModules.raspberry-pi-3
    # … shared modules, home-manager, ./hosts/dhumavati
    ({...}: { sdImage.firmwareSize = 64; })
  ];
}).config.system.build.sdImage;
```

Two details that matter:

- `.config.system.build.sdImage` (not `.toplevel`) — `.toplevel` produces a
  system closure, not a disk image.
- The attribute is separate from `nixosConfigurations.dhumavati` so the host
  can still be evaluated normally on x86_64 (`nix flake check`, `nix eval`).

## 3. Build

```bash
cd /etc/nixos
nix build --impure --system aarch64-linux .#dhumavatiSdImage
```

- `--impure` is mandatory: `sops.defaultSopsFile` is the absolute path
  `/etc/nixos/external/secrets/secrets.yaml`, and pure evaluation refuses
  absolute paths.
- `--system aarch64-linux` selects the emulated platform; the flake attribute
  alone does not switch the platform for the builder.
- Expect ~10 minutes cold (dominated by `ext4-fs.img` + the 9.4 GiB image
  assembly). Subsequent rebuilds reuse cached closures.

Output:

```
result/sd-image/nixos-image-sd-card-<version>-aarch64-linux.img.zst   ~3.0 GiB
                                                               (9.4 GiB uncompressed)
```

The build is deterministic — a clean rebuild of unchanged sources yields the
**same store path**. Treat a changed hash as evidence the inputs changed.

Disk space: budget ~12 GiB free for the store path plus decompressed
verification copies.

## 4. Host configuration requirements (Pi 3 specifics)

These are not cosmetic. Each one was the cause of a boot or network failure.

```nix
# hosts/dhumavati/default.nix

# Headless: U-Boot on the Pi 3 has no working USB keyboard, and the fleet
# default (`timeoutStyle = "hidden"`) renders TIMEOUT 0 = wait forever.
# Timeout 0 disables the extlinux menu and boots the default entry instantly.
boot.loader.timeout = lib.mkForce 0;

# The onboard LAN9514 Ethernet hangs off the dwc2 USB controller. The vendor
# device tree has no dr_mode, so mainline dwc2 comes up in OTG mode and the
# chip never enumerates. The stock overlay pins it to host mode.
hardware.raspberry-pi.configtxt.deviceTreeOverlays.pi3 = [
  {dwc2.dr_mode = "host";}
];

# 53 is the resolver, not just the UI. `services.adguardhome.openFirewall`
# only opens the web port.
networking.firewall.customTcpPorts = [53 3000];
networking.firewall.customUdpPorts = [53];
```

```nix
# hosts/dhumavati/hardware-configuration.nix
boot.kernelModules = ["bcm2708_rng" "snd_bcm2835" "smsc95xx"];
```

### Memory protection (1 GiB board)

`modules.system.performance.oomd` marks `system.slice` and `-.slice` with
`ManagedOOMMemoryPressure=kill` at 80%. On a Pi 3 those thresholds are reached
routinely, and systemd-oomd SIGKILLs whole services — observed killing AdGuard,
then NetworkManager, then getty/sshd, which drops the console. Scope oomd to
user slices and mark the critical units:

```nix
systemd.oomd = {
  enableRootSlice = lib.mkForce false;
  enableSystemSlice = lib.mkForce false;
};

systemd.services.adguardhome.serviceConfig = {
  OOMScoreAdjust = -900;
  ManagedOOMPreference = "avoid";
  MemoryMin = "64M";
};
systemd.services.NetworkManager.serviceConfig = {
  OOMScoreAdjust = -800;
  ManagedOOMPreference = "avoid";
  MemoryMin = "32M";
};
systemd.services.sshd.serviceConfig = {
  OOMScoreAdjust = -600;
  ManagedOOMPreference = "avoid";
};
```

Verify in the built closure before flashing:

```bash
nix eval --impure --json '.#nixosConfigurations.dhumavati.config.systemd.slices."system".sliceConfig'
# → {}   (must be empty: no ManagedOOMMemoryPressure)

grep -E "OOMScoreAdjust|ManagedOOMPreference|MemoryMin" \
  /nix/store/*-unit-adguardhome.service/adguardhome.service
```

> A non-empty `system.slice` sliceConfig means the override did not apply and
> oomd can still kill DNS/network.

## 5. Flash

Confirm the target device **by size/model**, never by letter — device letters
move between re-plugs (`sda` = 28.9 G SD card, `sdb` = 465 G SSD):

```bash
lsblk -d -o NAME,SIZE,TRAN,MODEL,RM
sudo blockdev --getsize64 /dev/sda     # must report ~28.9 GB, not 0
```

Then write:

```bash
zstd -dc result/sd-image/*.img.zst \
  | sudo dd of=/dev/sda bs=4M status=progress conv=fsync
```

`conv=fsync` is required: without it `dd` returns before the card's cache is
flushed and the read-back check can pass on data that is not yet durable.

`/dev/sda` reporting `0B` / `dd: No medium found` means the reader is empty —
the card is probably still in the Pi.

## 6. Verify by reading the card back

Flashing without verification is how a "the image is broken" diagnosis gets
made against a bad write.

```bash
sudo fsck.vfat -n /dev/sda1        # clean, 435 files
sudo fsck.ext4 -fn /dev/sda2       # clean, ~353k files

sudo mount -o ro /dev/sda1 /mnt && head -40 /mnt/config.txt
sudo mount -o ro /dev/sda2 /mnt && head -6 /mnt/boot/extlinux/extlinux.conf
```

Expected on the card:

| Check | Expected |
|-------|----------|
| Partition layout | `sda1` 64 MiB FAT32 label `FIRMWARE` at sector 16384; `sda2` ext4 label `NIXOS_SD`, bootable |
| `config.txt` | `[all] … kernel=u-boot.bin`, `[pi3] dtoverlay=dwc2` + `dtparam=dr_mode=host` + `dtoverlay=` |
| `overlays/dwc2.dtbo` | present (the firmware installer copies the whole vendor overlay set) |
| `extlinux.conf` | `DEFAULT nixos-default`, `TIMEOUT 1`, no `MENU TITLE` |
| `/boot/nixos/` | kernel `Image`, initrd, dtbs |

`TIMEOUT 1` with no `MENU TITLE` is what "instant boot" looks like: the
extlinux builder emits `TIMEOUT 1` and no menu when `boot.loader.timeout = 0`.

## 7. Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| No green ACT LED, nothing on screen | firmware cannot read the card (bad write / unseated / bad card) | re-flash, verify read-back, try another card |
| `cannot persist EFI variables without system partition` | U-Boot EFI boot manager warning — harmless, boot continues | ignore |
| Menu shows "hit 1 for NixOS", keyboard dead | `TIMEOUT 0` = wait forever; U-Boot has no USB keyboard on Pi 3 | `boot.loader.timeout = lib.mkForce 0` |
| Boots to login prompt, no network, no DHCP packets on the wire | `dwc2` in OTG mode → LAN9514 never enumerates | `[pi3] dtoverlay=dwc2 / dtparam=dr_mode=host` + overlays staged |
| Interface exists but DNS unreachable from LAN | firewall has no port 53 | open 53 tcp **and** udp |
| Services and console die under load | oomd kills `system.slice` at 80% pressure | disable root/system slice monitoring, negative `OOMScoreAdjust` |
| `nix copy` fails: "lacks a signature by a trusted key" | locally-built paths are unsigned; remote user is untrusted | export the diff and import as root (below) |

### Deploying a config change without reflashing

Prefer reflashing for anything structural. For a small change (firewall port),
build the closure on the x86_64 host and import it as root:

```bash
SYS=$(nix build --impure --system aarch64-linux --no-link --print-out-paths \
  '.#nixosConfigurations.dhumavati.config.system.build.toplevel')

# compute what the Pi lacks
ssh -p 2222 tlh@<pi> 'ls /nix/store | sort' > /tmp/pi-store.txt
nix-store -qR "$SYS" | xargs -n1 basename | sort > /tmp/our-store.txt
comm -23 /tmp/our-store.txt /tmp/pi-store.txt > /tmp/missing.txt

sed 's|^|/nix/store/|' /tmp/missing.txt | xargs -d '\n' nix-store --export > /tmp/missing.nar
scp -P 2222 /tmp/missing.nar tlh@<pi>:/tmp/
ssh -p 2222 tlh@<pi> 'echo <pw> | sudo -S sh -c "nix-store --import < /tmp/missing.nar"'

ssh -p 2222 tlh@<pi> "echo <pw> | sudo -S nix-env -p /nix/var/nix/profiles/system --set $SYS"
ssh -p 2222 tlh@<pi> "echo <pw> | sudo -S $SYS/bin/switch-to-configuration switch"
```

Two cautions learned the hard way:

- `xargs` must be used for the path list — this shell is **zsh**, where unquoted
  `$var` does not word-split, and `nix-store --export` receives one giant
  invalid path.
- `switch-to-configuration` restarts NetworkManager and can drop the SSH
  session mid-run; on a memory-constrained Pi with oomd mis-scoped it can also
  take the machine down. If the host becomes unreachable with all ports closed
  but still answers ping, that is oomd, not a network fault — reboot and prefer
  reflashing.

## 8. SSH access

The Pi runs OpenSSH on **2222**, not 22:

```bash
ssh -p 2222 tlh@<pi-ip>          # or dhumavati.lan
```

Initial credentials are baked into the image (`initialPassword`) plus
`users.users.tlh.openssh.authorizedKeys` from the build host. Port 53 closed
while 2222/3000 open is the firewall, not sshd.

## 9. Post-flash checklist

1. Card in reader, `/dev/sda` reports the right size.
2. `zstd -dc … | dd … conv=fsync`.
3. `fsck.vfat` + `fsck.ext4` clean.
4. `config.txt` has the `[pi3]` dwc2 block; `extlinux.conf` has `TIMEOUT 1`.
5. Boot: login prompt appears without any keypress.
6. `ping <pi>`, then `ssh -p 2222`.
7. `dig @<pi> example.com` answers; `dig @<pi> doubleclick.net` → `127.0.0.1`.
8. Point the LAN's DNS at the Pi (router-side, not declarative here).
