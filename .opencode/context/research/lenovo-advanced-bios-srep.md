---
title: "Lenovo Advanced BIOS — SREP Chainload and Undervolt"
type: source-summary
tags: [lenovo, bios, advanced-bios, srep, undervolt, uefi, grub]
created: 2026-07-15
updated: 2026-07-15
sources: [.documentation/archived/advanced_bios/lenovo-advanced-bios.md]
status: active
---

# Lenovo Advanced BIOS — SREP Chainload and Undervolt

## Background

The Legion 5 Pro (14th-gen Intel i9) was unstable during NixOS installation due to excessive CPU heat — the i9's default voltage is unlimited, causing thermal shutdowns under build load. The solution was accessing the **Advanced BIOS** to set voltage limits.

## SREP Approach (Archived)

The SREP (Setup Representation) method uses a set of EFI executables and a configuration file to unlock hidden BIOS menus:

- `DisplayEngine.efi`, `BootX64.efi`, `Loader.efi`, `SetupBrowser.efi`, `SuppressIFPatcher.efi`, `UiApp.efi`
- `SREP_Config.cfg` — configuration file for the unlocked menus

Originally, these were:
1. Placed on a FAT32 USB to unlock the Advanced BIOS at boot
2. Later bundled into the NixOS GRUB config via `extraFiles` and chainloaded from a GRUB menu entry

## Current Status — Archived

The BIOS update from N0CN31WW to N0CN35WW locked out the advanced BIOS menu. The SREP files were moved to `.documentation/archived/advanced_bios/` for historical reference.

The GRUB chainload entry was replaced with the standard `fwsetup` command (UEFI Firmware Settings). All thermal/power controls that were in the advanced BIOS are now handled through NixOS:

- **TLP** — CPU max performance caps, energy performance policy, platform profile
- **Kernel params** — `pcie_aspm=force`, `intel_pstate=passive`, `nvme_core.default_ps_max_latency_us`
- **Undervolt service** — runtime voltage control
- **platform_profile** — forced to "balanced" at boot

See [[decisions]] for ADR-015 (SREP → GRUB fwsetup replacement) and ADR-011 (TLP CPU power caps).
