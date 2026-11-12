<!-- Generated: 2026-11-12 -->

# rpi3

## Purpose
Raspberry Pi 3 Model B (BCM2837, AArch64), 32 GB SD card. Headless AdGuard
Home DNS adblocking server for the LAN. Built remotely from bagalamukhi;
hardware-configuration.nix is a starter that must be regenerated on the Pi
before first switch.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Host config — imports hardware-configuration, sops, user tlh; enables AdGuard Home DNS blocking, extlinux boot, Raspberry Pi firmware |
| `hardware-configuration.nix` | Starter hardware config — ext4 root + FAT32 firmware partition, aarch64-linux. UUIDs/labels must be regenerated on the target |
| `sops.nix` | sops-nix wiring — same repo age key as bagalamukhi/kamala; no TPM on the Pi |

## For AI Agents

### Working In This Directory
- **Raspberry Pi 3, AArch64** — not x86_64. `nixpkgs.system = "aarch64-linux"`.
- Boot path: Raspberry Pi firmware → U-Boot → extlinux.conf → NixOS generation.
  - `boot.loader.grub.enable = false`
  - `boot.loader.generic-extlinux-compatible.enable = true`
  - `hardware.raspberry-pi.firmware.enable = true` + `uboot.enable = true`
- Use `inputs.nixos-hardware.nixosModules.raspberry-pi-3` for the Pi 3 downstream kernel and board defaults
- No desktop, no Stylix, no NVIDIA/Intel/AMD hardware modules — headless
- `hardware-configuration.nix` is a starter; regenerate on the target with `nixos-generate-config --show-hardware-config` before first switch
- AdGuard Home (`services.adguardhome`) provides network-wide DNS ad blocking on port 53, web UI on port 3000
- Build remotely: `nixos-rebuild switch --flake .#rpi3 --impure --sudo` (run on the Pi after copying the flake)

### Module enables
- `modules.system.performance.default.enable = true` (oomd + zram, no undervolt)
- `services.adguardhome.enable = true` — DNS adblocker
- `services.avahi.enable = true` — mDNS for `rpi3.local`
- `users.tlh.enable = true` — primary user

### Boot process
ROM → Raspberry Pi firmware → U-Boot → extlinux.conf → NixOS generation.
The firmware partition is mounted at `/boot/firmware`. Firmware partition updates
require `hardware.raspberry-pi.firmware.enable` and the partition mounted.

### Notes
- Pi 3 has 1 GB RAM — local kernel builds or large derivations may exhaust memory; use an AArch64 remote builder or add swap if needed
- Wireless firmware is not included in the Pi 3 profile — `hardware.enableRedistributableFirmware` may be needed for WiFi
- 32 GB SD card — no swap partition, zram enabled instead, cron GC disabled to reduce write churn
