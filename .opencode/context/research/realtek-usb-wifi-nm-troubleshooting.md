# Realtek USB WiFi + NetworkManager Troubleshooting

> Source: Gemini troubleshooting session (2026-06-20)
> Extracted lessons applied to NixOS config in `modules/nixos/hardware/networking.nix`

## Summary

A Realtek USB WiFi adapter (rtw88 in-kernel driver) failed to connect under NetworkManager on NixOS with AwesomeWM. An identical machine with identical hardware worked fine. After exhaustive troubleshooting, the only thing that worked was raw `wpa_supplicant` with manual configuration. The root causes were all NetworkManager behaviors hostile to Realtek USB adapters.

## Root Causes Identified

### 1. MAC Randomization During Scans
NM randomizes MAC on every scan probe. Realtek drivers (both in-kernel rtw88 and out-of-tree rtl88x2bu) cannot handle rapid MAC flips. The adapter enters a broken state requiring physical replugging.

**Fix:** `scanRandMacAddress = false` + `macAddress = "permanent"`

### 2. USB Autosuspend (Reason Code 3)
The kernel's USB power management cuts power when the WiFi card draws high voltage for the cryptographic handshake (WPA2 4-way, WPA3 SAE). The radio crashes mid-handshake and sends DEAUTH_LEAVING (Reason Code 3). NM reports "association took too long, failing activation."

**Fix:** udev rule targeting Realtek vendor `0bda` to set `power/control=on`

### 3. Missing Secret Agent (WPS Fallback)
In AwesomeWM without GNOME Keyring/Polkit, NM cannot store WiFi passwords. It falls back to WPS button prompts ("push of wps button or a password required") even with correct passwords.

**Fix:** NM dispatcher script setting `psk-flags=0` (system-owned secret) and `wps-method=1` (WPS disabled) on every WiFi connection up event

### 4. Regulatory Domain
Realtek drivers fail to auto-detect regulatory domain from AP beacons, defaulting to restrictive "world" domain (00) which limits channels and TX power.

**Fix:** `networking.wireless.regulatoryDomain = "US"`

### 5. BSSID Thrashing
Dual-band routers broadcasting 2.4GHz and 5GHz under same SSID cause adapter to thrash between radios, triggering association timeouts.

**Fix:** Lock BSSID to single radio (per-network, not global config — deferred unless needed)

### 6. WPA3/WPA2 Mixed-Mode
Linux WiFi drivers (especially Realtek) are buggy when forced to use WPA3 (`sae`) on mixed-mode networks. Forcing `wpa-psk` with explicit cipher suite (`proto=RSN`, `pairwise=CCMP`, `ieee80211w=0`) was required for raw wpa_supplicant to connect.

**Note:** This is per-network configuration, not a global NM fix.

## The Working Raw wpa_supplicant Config

The only configuration that successfully connected:

```
network={
    ssid="SSID"
    bssid=AA:BB:CC:DD:EE:FF
    psk=HASHED_PSK
    key_mgmt=WPA-PSK
    proto=RSN
    pairwise=CCMP
    group=CCMP
    ieee80211w=0
}
```

With:
- `iw dev wlan0 set power_save off`
- `iw reg set US`
- Kernel-level MAC spoofing (`ip link set dev wlan0 address ...`)
- Static IP + hardcoded DNS (bypassed DHCP entirely)

## Key Insight

The user's original privacy goal (not broadcasting hostname, randomizing identity) was achieved by accident: **manually configuring a static IP completely bypasses DHCP**, meaning no DHCP Request is ever sent, so hostname and Client ID are never broadcast to the router.

## Applied NixOS Fixes

All fixes applied to `modules/nixos/hardware/networking.nix`:

| Fix | Mechanism | Line |
|-----|-----------|------|
| MAC randomization disabled | `scanRandMacAddress = false`, `macAddress = "permanent"` | 79-80 |
| Regulatory domain | `networking.wireless.regulatoryDomain = "US"` | 99 |
| WPS disabled + system secrets | NM dispatcher script | 111-135 |
| USB autosuspend disabled | udev rule (vendor `0bda`) | 147-150 |
| Power saving disabled | `wifi.powersave = false` (already default) | 73 |
