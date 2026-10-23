---
title: "Secure Boot Chain of Trust — GRUB, UKIs, and Why Lanzaboote Is Out"
type: synthesis
tags: [secure-boot, grub, uefi, lanzaboote, limine, uki, bootloader, theming]
created: 2026-10-23
updated: 2026-10-23
sources: [lanzaboote-secure-boot, bios-srep-vs-firmware-update-tradeoff]
status: active
---

# Secure Boot Chain of Trust

Investigation prompted by a hard constraint: the **Bhairava GRUB theme is not
negotiable**. Question: can this machine have Secure Boot that actually verifies
kernel + initrd, without losing the theme?

**Short answer: yes in principle** — GRUB's `chainloader` delegates the load to
firmware `LoadImage`, which authenticates the image. Lanzaboote and Limine are
not required. Nothing is implemented; the design and its open questions are
below. The decision taken *so far* is ADR-021 (no bootloader change), not the
implementation.

## 1. The model — enforcement is an action, not a property

Secure Boot does not make a file "trusted". It makes **the code performing the
load** refuse an image whose signature is not in `db`. So the only well-formed
question is: *which path loads this image, and does it delegate to firmware?*

| Load                          | Performed by | Verifier                                          |
| ----------------------------- | ------------ | ------------------------------------------------- |
| firmware → first EFI binary   | firmware     | PE signature vs `db` / `dbx`                        |
| loader → next stage           | the loader   | **whatever that loader does** — this is the variable |

Because of this, "the theme is unsigned data" and "the config is unsigned data"
are not the same finding. The relevant question is whether anything
*security-relevant* on that loader's input path is verified.

## 2. Evidence — GRUB has two load paths and they behave oppositely

- **`linux`** (and Fedora's `linuxefi` counterpart): GRUB parses the bzImage and
  enters it itself. `LoadImage` is never called for the kernel, so the firmware
  never sees it. This is exactly the hole Fedora closed with shim + `linuxefi`.
- **`chainloader`**: GRUB reads the file into memory and calls the firmware's
  `LoadImage`. From `grub-core/loader/efi/chainloader.c`:

  ```c
  image_handle = grub_efi_get_last_verified_image_handle ();
  if (image_handle == NULL)
    status = grub_efi_load_image (0, grub_efi_image_handle, file_path,
                                  boot_image, size, &image_handle);
  ```

**Consequence:** a signed UKI chainloaded from GRUB is authenticated by the
firmware, and the kernel, initrd and command line inside it inherit that
authentication because they live inside the signed PE image. No shim, no
`shim_lock`, no GRUB patch.

Corollary worth remembering: the earlier claim that a signed GRUB would
"chainload anything because the signature is decorative" was wrong — that is
true of the `linux` path, not the `chainloader` path.

## 3. Why lanzaboote is out

`nix/modules/lanzaboote.nix` reads `config.boot.loader.systemd-boot.*`, passes
`--systemd-boot-loader-config`, and states "boot via systemd-boot". There is no
GRUB branch; a GRUB path would be a fork. Since systemd-boot has no theming
upstream and a themed fork of it was ruled out, lanzaboote is unavailable here.

What lanzaboote actually contributes, and where each piece already lives:

| Lanzaboote piece    | Already available without it                                                    |
| ------------------- | ------------------------------------------------------------------------------- |
| build a UKI         | `system.build.uki` — `nixos/modules/system/boot/uki.nix` (ukify: Linux, Initrd, Cmdline, Stub, OSRelease) |
| sign it             | `sbctl sign`                                                                      |
| install it          | filesystem copy                                                                   |
| write `loader.conf`   | systemd-boot menu syntax — the only genuinely loader-specific part                |
| dedupe across generations | lanzaboote-specific, and the reason it fits a 512M ESP                        |

Lanzaboote verifies nothing itself. It is a packager.

## 4. Why Limine is out

nixpkgs ships Limine 12.9.4 with a real style subsystem — `wallpapers`,
`wallpaperStyle`, `backdrop`, `interface.{branding,brandingColor,helpColor,resolution}`,
`graphicalTerminal.{font.scale,spacing,palette,brightPalette,foreground,background,margin,marginGradient}` —
and a `secureBoot` block (signs limine with sbctl; `autoGenerateKeys`,
`autoEnrollKeys`).

The Bhairava theme is deeper than that vocabulary:

| Theme feature (from `theme.txt`)                     | Limine equivalent |
| ---------------------------------------------------- | ----------------- |
| 1920×1080 `background.jpg`                             | yes (wallpaper)   |
| `boot_menu` box at 19%/18%, 28%×54%                     | no                |
| 48×48 per-entry distro icons                         | no                |
| `select_*.png` nine-slice selection pixmap             | no                |
| 590×518 `logo.png` fixed at 54%/29%                    | no                |
| Unifont 24 items, Terminus 18 terminal, countdown label | partial (one font scale) |

Limine can carry the artwork and the colours, not the layout. It also only
signs the loader, so it would lose the theme *and* keep the kernel gap.

## 5. Measured constraints on `kamala`

Measured 2026-10-23:

| Thing                        | Value                                             |
| ---------------------------- | ------------------------------------------------- |
| ESP `nvme0n1p1` → `/boot/efi`    | vfat, 511M, 33M used (479M free)                  |
| `/boot` `nvme0n1p2`              | ext4, 974M, 277M used (630M free)                 |
| GRUB EFI binary              | `/boot/efi/EFI/NixOS-boot-efi/grubx64.efi`          |
| Kernel (`bzImage`)             | 15M                                               |
| initrd                       | **117M** per generation                               |
| Naive UKI (kernel+initrd)    | ~132M → **3 generations**, not 10                    |

This is where the earlier "`configurationLimit = 3`" instinct was right for the
wrong reason: lanzaboote fits 10 generations on 512M because it deduplicates
kernel+initrd and stores a small stub per generation. One UKI per generation
does not dedupe, so the budget is 3–4 and the limit has to drop.

## 6. Proposed design (not implemented)

| # | Piece         | Implementation                                                                                                                          |
| - | ------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| 1 | Sign GRUB     | `boot.loader.grub.extraInstallCommands` → `sbctl sign -s /boot/efi/EFI/NixOS-boot-efi/grubx64.efi`, so it re-signs on every GRUB change     |
| 2 | Build UKIs    | `system.build.uki`; copy at activation to a stable boot path                                                                            |
| 3 | Sign each UKI | `sbctl sign -s` on the copy                                                                                                             |
| 4 | Menu entries  | `boot.loader.grub.extraConfig = "source /grub/uki.cfg"`; an activation oneshot rewrites that file newest-first, pruned to the budget      |

Normal bzImage menu entries must be suppressed, or the menu itself becomes the
bypass.

**Ordering, each step gated:** `sbctl create-keys` → BIOS clear PK (Setup Mode)
→ `sbctl enroll-keys -m` (`-m` for the Pascal option ROM) → switch with signing,
SB not yet enforcing → reboot and select a UKI entry manually, `sbctl verify` →
enable enforcement in BIOS → re-enroll TPM at PCR 7 **last** (key enrollment
moves PCR 7).

**Open questions that must be settled on `bhairavi` first:**

1. Does firmware authenticate an image chainloaded from a non-FAT partition?
   `LoadImage` verifies image bytes, so `/boot` (ext4, 630M free) should work and
   would buy a slot over the ESP — but this needs empirical confirmation.
2. `boot.loader.grub.configurationLimit = 0` — confirm it yields zero generation
   entries rather than "unlimited".
3. Pascal GOP under enforcement can black-screen until the driver loads; `-m`
   covers Microsoft-signed option ROMs only. Rollback is clearing PK.
4. An unsigned GRUB under enforcing SB is unbootable; Setup Mode is the only
   way back. Snapshot before enabling enforcement.

**Accepted bound:** `grub.cfg` stays writable. An attacker with `/boot` write
access can reorder or select entries, or point one at a Microsoft-signed loader
— the standard SB hole, identical under systemd-boot. They cannot execute an
unsigned UKI.

## 7. History — chainloader is already proven in this repo

`modules/nixos/system/boot.nix` holds the `advancedBios` entry. Git shows it was
a chainloader before the firmware patch broke it:

- `956d7e7` — `insmod fat` / `insmod chain` / `search --no-floppy --set=root --file /EFI/Boot/BootX64.efi` / `chainloader @bootRoot@/EFI/Boot/BootX64.efi`
- `9bd2c33` — replaced with `fwsetup` (ADR-015)

So the mechanism proposed here is the one the repo already used to reach the
Lenovo advanced BIOS.

## 8. Cross-reference — pending storage work

The drive/LUKS migration for the same machine lives outside context, in
`/etc/nixos/.tmp/kamala-storage/` (gitignored, so it does not survive a clean
checkout): 2TB+2TB RAID1 → `cryptartifacts` → btrfs at `/srv/storage/artifacts`,
5TB → `cryptbulk`, 3TB → `cryptarchive`, new 500G NVMe → `cryptcontainers` for
`/var/lib/containerd`. Any future Secure Boot work must re-enroll TPM after it,
and any TPM enrollment must come after the final bootloader/PCR state.

## Sources

- `nixpkgs/nixos/modules/system/boot/loader/grub/grub.nix` — `extraInstallCommands` (413), `extraConfig` (372), `configurationLimit` (634)
- `nixpkgs/nixos/modules/system/boot/loader/limine/limine.nix` — style block (261+), `secureBoot` (219+)
- `nixpkgs/nixos/modules/system/boot/uki.nix` — `system.build.uki`
- `nixpkgs/pkgs/development/cuda-modules/backendStdenv/default.nix` — capability assertions (124–206)
- `lanzaboote/nix/modules/lanzaboote.nix` — systemd-boot coupling
- `grub-core/loader/efi/chainloader.c` (upstream, fetched 2026-10-23) — `grub_efi_load_image` call
- Local measurements from `kamala`: `findmnt`, `ls -lh /boot/kernels`, `df -h`
