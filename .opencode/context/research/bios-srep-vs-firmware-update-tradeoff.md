# BIOS SREP / Advanced BIOS vs Firmware Update — Trade-off Analysis

> Decision context for bagalamukhi (Lenovo Legion Pro 5 16IRX9, BIOS N0CN).  
> Date: 2026-06-14

## Current State

- **BIOS version**: N0CN (back-flashed from a newer version)
- **SREP/Advanced BIOS access**: Working (via GRUB EFI chainloading — SMX Runtime Extensible Policy)
- **Kernel module**: `lenovo-legion-module` (from johnfanv2/LenovoLegionLinux, overlay-bumped to `352cb4b3`)
- **Fan/cooling control**: Working via hwmon sysfs (fan curves, thermal mode 4, power mode 4)
- **EC WMI**: Partially failing (power limits, overclocking, rapid charge — see `lenovo-legion-kernel-overlay-fixes.md`)

## The Two Separate Layers

### Layer 1: SREP / SMM (System Management Mode)

- **What it is**: SREP is a GRUB module that makes SMM calls to set specific **UEFI variables** (`Setup` or `Custom` flags) at boot time. This unhides "Advanced" BIOS menu pages that Lenovo hides from the standard UI.
- **How it works**: GRUB loads the SREP EFI application → sets SMM variables → chain-boots the normal bootloader. The BIOS reads the flag variables and shows the Advanced menu.
- **What it controls**: CPU voltage offsets, PLL overclocking toggles, memory timings, Platform Power Management config, IMON slope, AC/DC load line, SA/Ring voltage, and Intel P-State configuration. These are **firmware-level** settings that persist across boots.
- **Vulnerability surface**: SMM call handlers in the BIOS. These are privileged, firmware-level call gates. Newer BIOS versions **patch these handlers** specifically to prevent SREP from working.

### Layer 2: EC WMI (OS-level Embedded Controller access)

- **What it is**: ACPI bytecode methods embedded in the BIOS that the `lenovo-legion-module` kernel driver calls via WMI GUIDs. These methods translate OS-level calls to EC register reads/writes.
- **How it works**: Kernel module → WMI call → ACPI method in BIOS → EC register read/write → result returned to kernel.
- **What it controls**: Power limits, overclocking toggles, rapid charge, GPU temp limit — the **same features** that Advanced BIOS menus expose, but accessible from the OS.
- **Firmware dependency**: These are ACPI bytecode methods, not SMM calls. They're in a separate part of the BIOS from the SMM handlers that SREP exploits.

**Key insight**: These two layers are **independent**. The BIOS can fix the EC WMI methods without patching the SMM call handlers, or vice versa. However, in practice, Lenovo's newer BIOS releases typically update **both**.

## What Newer BIOS Would Fix

Looking at the specific dmesg errors:

```
Unexpected ACPI result for 14afd777-106f-4c9b-b334-d388dc7809be:1:
  expected type 3 but got 1; expected length 16 but got 0;
WMI evaluation error for: da7547f1-824d-405f-be79-d9903e29ced7:8
```

These are **ACPI bytecode bugs** — the methods exist but return incorrect data types. A newer BIOS version would likely fix these because they're straightforward implementation errors in the ACPI method bodies, not intentional locks.

## What Newer BIOS Would Break

SREP works by calling specific SMM entry points that the BIOS exposes. Newer firmware versions:
1. Remove or gate these SMM entry points
2. Add signature verification for SMM calls
3. Set `SuppressIf` flags on Advanced menu pages that SREP can't override

Once updated, **there is no known software-only method** to regain Advanced BIOS access on this generation of Legion laptops. Hardware methods (SPI flash programmer, chip clips) exist but are "dubious in the extreme" and risk bricking the board.

## The Redundancy Analysis

The features that matter for "stable, cool CPU/GPU operation" are already handled by non-EC-WMI interfaces:

| Goal               | How It's Done                                  | EC WMI Needed? |
| ------------------ | ---------------------------------------------- | -------------- |
| Fan curves         | `hwmon` sysfs → `legion-fan-control.service`       | No             |
| Thermal mode       | `thermalmode` sysfs → `legion-cooling.service`     | No             |
| Power mode         | `powermode` sysfs → `legion-cooling.service`       | No             |
| CPU power limits   | `undervolt.nix` via Intel P-State `powercap` sysfs | No             |
| GPU power limits   | `nvidia-smi -pl` or `nvidia-settings`             | No             |
| GPU temp limit     | Would be nice via EC WMI                        | Yes (broken)   |
| RapidCharge        | Cosmetic — hardware handles this                | Yes (broken)   |

The WMI failures are **cosmetic GUI issues** — they make the `legion_gui` show zeros/grayed-out fields but don't affect actual thermal management. The P-State powercap interface used by `undervolt.nix` is a completely independent control path that works on any BIOS version.

## Verdict

**Keep the current BIOS.** The only gain from updating would be:
- GPU temp limit control through the GUI (redundant with `nvidia-smi`)
- GUI display of current power limits (can read from `powercap` sysfs instead)
- RapidCharge toggle in GUI (the hardware already handles this)

The loss would be:
- Access to Advanced BIOS → no ability to set firmware-level power limits, voltage offsets, or P-State config that might be useful in the future
- SREP access is a one-way door — once lost, it cannot be regained without hardware flashing

**No meaningful cooling capability would be gained** by updating. The current setup already provides aggressive thermal management through the kernel module's non-WMI interfaces (fan curves, thermal mode, power mode) and Intel P-State powercap.
