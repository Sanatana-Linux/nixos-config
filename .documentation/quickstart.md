# NixOS Installation Quickstart

> Host-agnostic install of any **physical** host in this flake using `disko`
> (declarative disks) + LUKS2 + TPM2 auto-unlock. Replace the `‹host›` and
> `‹user›` placeholders throughout with the target host/user.

## Hosts

| Host         | User | Disks                     | disko layout                          |
| ------------ | ---- | ------------------------- | ------------------------------------- |
| bagalamukhi  | tlh  | 2 × 1TB NVMe              | `hosts/bagalamukhi/disko.nix`           |
| kamala       | tlh  | NVMe + 1.8TB SATA         | `hosts/kamala/disko.nix`                |
| matangi      | smg  | 2 × 1TB NVMe              | `hosts/matangi/disko.nix`               |
| bhairavi     | tlh  | VM (not covered here)     | —                                     |
| chhinamasta  | user | Live ISO (not covered)    | —                                     |

Encrypted hosts share one LUKS2 passphrase per machine, unlocked in the initrd
by the platform TPM2 (Intel PTT / AMD fTPM); `/boot` is plaintext so GRUB never
prompts. Attach the machine's `hosts/‹host›/disko.nix` for the exact layout.

## Prerequisites

- Bootable NixOS installer USB (chhinamasta ISO or official NixOS ISO)
- Internet + membership in the `Sanatana-Linux` GitHub org (secrets submodule)
- TPM2 (fTPM/PTT) enabled in firmware for the zero-prompt path
- **All data on the target disks is erased**

## Steps

```bash
# 0. root + tooling
sudo -s
nix-shell -p gh git neovim sops age
export NIX_CONFIG="experimental-features = nix-command flakes"

# 1. GitHub auth (the secrets submodule is private)
gh auth login --hostname github.com --git-protocol https --web
gh auth setup-git
git config --global url."https://github.com/".insteadOf "git@github.com:"

# 2. ONE passphrase for both LUKS volumes (read by disko's passwordFile)
printf '%s' 'PASSPHRASE' > /root/luks.key && chmod 600 /root/luks.key

# 3. disko config straight from the flake
curl -fsSL -o /tmp/disko.nix \
  https://raw.githubusercontent.com/Sanatana-Linux/nixos-config/main/hosts/‹host›/disko.nix

# 4. format + mount the target (WIPES the disks)
nix run github:nix-community/disko/latest -- --mode disko /tmp/disko.nix

# 5. clone straight onto the TARGET, submodules included
mkdir -pv /mnt/etc
git clone --recurse-submodules \
  https://github.com/Sanatana-Linux/nixos-config /mnt/etc/nixos

# 6. make the hardcoded sops path resolve to the target copy
rm -rfv /etc/nixos
ln -sfvn /mnt/etc/nixos /etc/nixos

# 7. TPM2 auto-unlock (skip on unencrypted / VM hosts)
modprobe tpm; modprobe tpm_crb
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p3   # cryptroot
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme1n1p1   # cryptdata
#   kamala: nvme0n1p3 (cryptroot) + sda1 (cryptdata)
#   bagalamukhi/matangi: nvme0n1p3 + nvme1n1p1

# 8. hardware config (disko owns the mounts)
nixos-generate-config --root /mnt --no-filesystems
cp -v /mnt/etc/nixos/hardware-configuration.nix \
      /mnt/etc/nixos/hosts/‹host›/hardware-configuration.nix

# 9. sops system key into the target
cd /etc/nixos/external/secrets && nix run .#ensure-system-key-exists
install -v -D -o root -g wheel -m 440 /var/lib/sops/age-keys.txt \
  /mnt/var/lib/sops/age-keys.txt

# 10. install (binary caches: see "Binary caches during install" below)
nixos-install --flake /etc/nixos#‹host› --impure \
  --option accept-flake-config true

# 11. reboot, remove the USB
reboot
```

### Binary caches during install

`nixos-install` builds with the **installer environment's** Nix daemon, whose
`/etc/nix/nix.conf` is the stock ISO config — it only knows `cache.nixos.org`.
The rich `substituters`/`trusted-public-keys` in `modules/nixos/base/nix.nix`
are written into the *installed* system and do nothing until first activation.
Without intervention the install silently compiles from source:

- **The kernel.** `boot.kernelPackages` is
  `cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3`. That flake
  (`xddxdd/nix-cachyos-kernel`) publishes to `attic.xuyh0120.win/lantian` and
  declares it through its own `nixConfig`. Flake `nixConfig` is honored only
  with `accept-flake-config = true` — the target sets it, the installer does
  not — so the LTO + BORE + x86-64-v3 kernel and its modules build locally.
- **Overlay-modified packages.** `additions`, `modifications`,
  `stable-packages`, `nur`, and `cachyos-patches` all change derivation hashes
  (python scope, `lenovo-legion-module`, custom `pkgs/`, stable-pinned apps),
  so no cache can satisfy them. These rebuilds are unavoidable — pre-seeding
  the store is the only way around them.

Give the installer daemon the caches on the command line. Use the `extra-*`
forms so `cache.nixos.org` stays in the list (plain `substituters` replaces it):

```bash
nixos-install --flake /etc/nixos#‹host› --impure \
  --option accept-flake-config true \
  --option extra-substituters "https://cache.numtide.com" \
  --option extra-substituters "https://cache.nixos-cuda.org" \
  --option extra-substituters "https://nix-community.cachix.org" \
  --option extra-trusted-public-keys "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" \
  --option extra-trusted-public-keys "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
```

`--option accept-flake-config true` on its own already fixes the kernel by
pulling in the lantian cache. To also skip the overlay rebuilds, pre-seed the
store from a machine that already has the closure (e.g. bagalamukhi):

```bash
# on the build machine
nix build .#nixosConfigurations.‹host›.config.system.build.toplevel --impure
nix copy --to ssh-ng://nixos@‹target-ip› "$(readlink -f result)"
```

Confirm the daemon sees the caches before committing to a long build:

```bash
nix config show | grep -E 'substituters|accept-flake-config'
nix build .#nixosConfigurations.‹host›.config.system.build.toplevel --impure --dry-run
```

### TPM enrollment notes

- Intel hosts (bagalamukhi, matangi) use **Intel PTT**; enabled in firmware.
- AMD host (kamala) uses **AMD fTPM**; enabled in firmware.
- `--tpm2-pcrs=7` binds to the Secure Boot policy. Without Secure Boot it is
  stable but only protects against moving the disk to another machine.
- Enrollment only rewrites the LUKS headers — no reinstall needed. If it fails,
  the passphrase still unlocks at boot (fallback).

### Host-config prerequisites for an encrypted install

The disko file alone is not enough; the host's `default.nix` must also have:

```nix
boot.initrd.systemd.tpm2.enable = true;   # pulls tpm-crb/tpm-tis into the initrd
```

and `modules/nixos/system/boot.nix` must keep `boot.initrd.systemd.enable = true`
(it does). **matangi only:** the new layout moves the ESP to `/boot/efi`, so change
`boot.efiMountPoint = "/boot"` → `"/boot/efi"` (see `hosts/matangi/default.nix`).

## Post-install

```bash
# take ownership of the cloned config + let git trust it
sudo chown -R $USER:users /etc/nixos
git config --global --add safe.directory /etc/nixos

# rebuild after edits
sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --impure
```

## Troubleshooting

| Symptom | Fix |
| ------- | --- |
| `experimental Nix feature 'nix-command' is disabled` | re-run `export NIX_CONFIG="experimental-features = nix-command flakes"` |
| `Repository not found` on `external/secrets` | `git submodule set-url external/secrets https://github.com/Thomashighbaugh/secrets.git && git submodule sync --recursive && git submodule update --init --recursive` |
| `/dev/tpmrm0: No such file or directory` | `modprobe tpm; modprobe tpm_crb`, or enable fTPM/PTT in firmware |
| `fallbackToPassword is implied by systemd stage 1` | don't set it — the systemd initrd falls back automatically |
| GRUB asks for a passphrase | `/boot` wasn't a separate plaintext partition — re-check the disko layout |
| Install builds the kernel / many packages from source | installer daemon lacks the flake's caches — add `--option accept-flake-config true`, or the full `extra-substituters`/`extra-trusted-public-keys` set (see "Binary caches during install") |
