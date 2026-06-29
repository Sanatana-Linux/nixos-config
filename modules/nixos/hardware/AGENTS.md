<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-06-21 -->

# modules/nixos/hardware/

## Purpose
Hardware support and driver configuration. Each module enables specific hardware capabilities — GPU drivers, bluetooth, sound, per-device quirks, and Lenovo-specific modules (keyboard, power, cooling, fan-control).

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports hardware submodules |
| `nvidia.nix` | NVIDIA driver config (PRIME sync, GPU firmware, dynamic power management) |
| `intel.nix` | Intel CPU features (undervolt kernel patch, microcode) |
| `bluetooth.nix` | Bluetooth support |
| `sound.nix` | PipeWire audio server |
| `udev.nix` | Custom udev rules |
| `thunderbolt.nix` | Thunderbolt/USB4 port configuration |
| `keyboard.nix` | Keyboard configuration (Copilot key remapping via keyd) |
| `lenovo/lenovo.nix` | Lenovo Legion hardware (legion-rgb-control, kernel modules, udev) |
| `lenovo/power.nix` | Laptop power management (TLP/power-profiles-daemon, upower, battery thresholds) |
| `lenovo/cooling.nix` | Thermal guard — monitors CPU and IC/VRM temp, throttles EPP when either overheats |
| `lenovo/fan-control.nix` | Fan curve daemon with per-sensor (CPU/GPU/IC) independent temperature bands |
| `devices/android.nix` | Android MTP/ADB support |
| `devices/iphone.nix` | iPhone/libimobiledevice support |
| `devices/logitech.nix` | Logitech device support (Solaar) |
| `devices/printer/` | Printer drivers (Brother) |

## For AI Agents

### Working In This Directory
- NVIDIA module uses PRIME **sync** mode (not offload) for hybrid GPU laptops, with GPU firmware enabled (`NVreg_EnableGpuFirmware=1`) and Dynamic Power Management (`NVreg_DynamicPowerManagement=0x02`)
- No udev rules are needed for NVIDIA — GPU firmware handles runtime PM transitions
- Intel module applies kernel patches via `boot.kernelPatches` with `structuredExtraConfig` using `lib.kernel` types
- Kernel module packages must use `config.boot.kernelPackages` (NOT `pkgs.linuxPackages`) to match the running kernel
- `boot.extraModulePackages` for out-of-tree drivers (e.g., rtl88x2bu, acpi_call)
- Networking, TPM, and security modules have moved to `modules/nixos/system/`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
