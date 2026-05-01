<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# chhinamasta

## Purpose
Live USB ISO — portable NixOS live environment with AwesomeWM on Intel graphics, generic user. Minimal footprint ISO with xanmod kernel, essential packages (development minimal, gui minimal, multimedia minimal, system minimal), broad hardware support (Intel, bluetooth, RTL88x2bu WiFi, Android, TPM), Plymouth boot theme, and Ollama AI for demonstration.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Host config — imports ISO image profile, all-hardware profile, base profile, and user module; minimal overlays (NUR only, no additions/modifications/stable); enables system/boot/plymouth, base (timezone America/New_York), shell+zsh, nix-ld/appimage/thunar, performance (zram only), packages (core, development minimal, fonts, gui minimal, multimedia minimal, network with wireless, python, shell, system minimal), hardware (bluetooth, sound, udev, TPM, Intel, networking hostname chhinamasta with rtl88x2bu, Android), Stylix, awesome desktop, security (doas adminUser=user, sudo), Ollama AI; EFI+USB bootable ISO, xanmod kernel, GNOME keyring, qemuGuest, QEMU guest kernel modules |
| `README.md` | Host documentation — hardware specs reference (Lenovo Legion Pro 5 16irx9h, i9-14900Hx, 32GB DDR5, NVIDIA 470) |

## For AI Agents

### Working In This Directory
- No hardware-configuration.nix — uses `modulesPath` installer profiles instead of auto-detected hardware
- This is a Live ISO builder, not a traditional host — config uses iso-image.nix and all-hardware profiles
- Host config imports from shared modules — check `modules/` for available options before adding new packages/config inline
- Build ISO with: `nixos-rebuild build --flake .#chhinamasta`
- Many package categories use `minimal = true` to keep ISO size manageable

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->