<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/nixos/hardware/

## Purpose
Hardware support and driver configuration. Each module enables specific hardware capabilities — GPU drivers, bluetooth, networking, sound, and per-device quirks.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports hardware submodules |
| `nvidia.nix` | NVIDIA driver config (PRIME offload, power management) |
| `intel.nix` | Intel CPU features (undervolt kernel patch, microcode) |
| `bluetooth.nix` | Bluetooth support |
| `networking.nix` | Network configuration and NetworkManager |
| `sound.nix` | PipeWire audio server |
| `tpm.nix` | TPM2 security module |
| `udev.nix` | Custom udev rules |
| `android.nix` | Android MTP/ADB support |
| `iphone.nix` | iPhone/libimobiledevice support |
| `lenovo.nix` | Lenovo-specific hardware (legion-rgb-control) |
| `logitech.nix` | Logitech device support (Solaar) |

## For AI Agents

### Working In This Directory
- NVIDIA module uses PRIME offload mode by default for hybrid GPU laptops
- Intel module applies kernel patches via `boot.kernelPatches` with `structuredExtraConfig` using `lib.kernel` types
- Kernel module packages must use `config.boot.kernelPackages` (NOT `pkgs.linuxPackages`) to match the running kernel
- `boot.extraModulePackages` for out-of-tree drivers (e.g., rtl88x2bu, acpi_call)

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->