# Session: TODO.md Sweep + Module Reorganization

> **Date:** 2026-06-21
> **Scope:** All 9 items from `/etc/nixos/TODO.md` implemented; major `modules/nixos/` directory restructuring

## Architecture Change: Module Directory Topology

**Before:** 14 top-level directories with mixed concerns (hardware/ contained networking, tpm, devices)
**After:** 7 top-level directories with clean separation — system services vs hardware drivers

```
modules/nixos/
├── base/              ← unchanged
├── hardware/          ← drivers only: GPU, bluetooth, keyboard, sound, udev, thunderbolt
│   ├── lenovo/        ← all Lenovo modules grouped (lenovo, power, cooling, fan-control)
│   └── devices/       ← peripherals + mobile (android, iphone, logitech, printer)
├── packages/          ← unchanged + security packages added
├── stylix/            ← unchanged
├── system/            ← expanded: boot, cron, systemd, networking, apps, desktop, performance, security
├── users/             ← unchanged
└── virtualization/    ← unchanged
```

## Option Path Migration Map

| Old Path | New Path |
|----------|----------|
| `modules.hardware.networking.*` | `modules.system.networking.*` |
| `modules.security.*` | `modules.system.security.*` |
| `modules.hardware.tpm` | `modules.system.security.tpm` |
| `modules.power.laptop.*` | `modules.hardware.lenovo.power.*` |
| `modules.performance.*` | `modules.system.performance.*` |
| `modules.ai.*` | `modules.system.apps.ai.*` |
| `modules.desktop.*` | `modules.system.desktop.*` |
| `modules.apps.*` | `modules.system.apps.*` |
| `modules.hardware.android` | `modules.hardware.devices.android` |
| `modules.hardware.iphone` | `modules.hardware.devices.iphone` |
| `modules.hardware.logitech` | `modules.hardware.devices.logitech` |
| `modules.printer.*` | `modules.hardware.devices.printer.*` |
| `modules.hardware.fan-control.*` | `modules.hardware.lenovo.fan-control.*` |
| `modules.performance.cooling` | `modules.hardware.lenovo.cooling` |

## Bug Fixes

### fail2ban service (Item 5)
`systemd.services.fail2ban = { after = ...; wants = ...; }` **replaced** the entire NixOS-generated unit (stripped ExecStart). Fixed to merge syntax: `systemd.services.fail2ban.after = ...; systemd.services.fail2ban.wants = ...;`

### Copilot key (Item 3)
keyd mapped `f23 = "rightctrl"` but Lenovo Legion sends `LeftMeta+LeftShift+F23` chord. Fixed to `"leftmeta+leftshift+f23" = "rightctrl"`.

### Keyboard backlight race condition (Item 2)
Polling `legion-kb-backlight` systemd service waited up to 30s for ITE HID device. Replaced with udev `RUN+=` rule triggered on device detection — instant, race-free.

### Realtek USB WiFi + NetworkManager (prior session)
- `scanRandMacAddress = false` + `macAddress = "permanent"` — disables MAC randomization during scans (crashes Realtek drivers)
- `cfg80211.ieee80211_regdom=US` — kernel-level regulatory domain (Realtek fails auto-detect)
- NM dispatcher: `psk-flags=0` (system-owned secrets) + `wps-method=1` (WPS disabled)
- Udev rule: USB autosuspend off for vendor `0bda` (prevents DEAUTH_LEAVING/Reason Code 3)

## Enhancements

- **Fan curves 4→3:** extreme→performance, performance→balanced, balanced→quiet; old quiet removed
- **expose_all_fans=Y:** kernel modprobe param for dual-fan hwmon control
- **UPower battery warning:** systemd timer polls every 2min, `notify-send` at 8% threshold
- **Security packages:** nested under `modules.packages.security` with per-package sub-options

## Files Changed

- **Modules:** 19 moved via `git mv`, 12 modified, 5 new default.nix files created
- **Host configs:** 4 restructured (bagalamukhi, matangi, bhairavi, chhinamasta)
- **Documentation:** 7 AGENTS.md files updated
- **Context:** `realtek-usb-wifi-nm-troubleshooting.md` saved from Gemini troubleshooting session
