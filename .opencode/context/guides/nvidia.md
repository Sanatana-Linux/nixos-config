# NVIDIA on NixOS

Core concept: NVIDIA GPU configuration on NixOS requires proprietary kernel modules (+ `hardware.graphics.enable`), PRIME setup for hybrid GPU laptops (Intel/AMD iGPU + NVIDIA dGPU), and careful mode selection (offload/sync/reverse sync). Driver ≥560 requires choosing `hardware.nvidia.open = true/false`.

Key Points:
- **Enabling**: `services.xserver.videoDrivers = ["nvidia"]` + `hardware.graphics.enable = true`
- **Open vs proprietary modules**: `hardware.nvidia.open = true` for Turing+ GPUs (RTX 20+); userspace stays proprietary either way — always need `allowUnfree`
- **Legacy drivers**: `hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470` for Kepler/older
- **Beta/production branches**: `nvidiaPackages.beta` or `nvidiaPackages.production`
- **Specific driver version**: `nvidiaPackages.mkDriver { version = "555.58.02"; sha256_64bit = "..."; ... }`

## PRIME Modes (Hybrid GPU Laptops)

**Critical**: Laptops with iGPU+dGPU MUST configure PRIME. Find bus IDs via `lspci -D -d ::03xx`, format as `PCI:<busDec>@<domainDec>:<deviceDec>:<funcDec>`.

| Mode | Option | Behavior | Battery | Performance |
|------|--------|----------|---------|-------------|
| **Offload** | `prime.offload.enable = true` | iGPU handles all; dGPU only on demand | Best | On-demand |
| **Sync** | `prime.sync.enable = true` | dGPU renders everything; iGPU displays | Worst | Best, less tearing |
| **Reverse sync** | `prime.reverseSync.enable = true` | dGPU is primary output (experimental) | Worst | Good, external displays |

- **Offload**: Video drivers must include `"modesetting"` (Intel) or `"amdgpu"` (AMD) alongside `"nvidia"`
- **Offload command**: `nvidia-offload` (when `prime.offload.enableOffloadCmd = true`) or set env vars `__NV_PRIME_RENDER_OFFLOAD=1`, `__GLX_VENDOR_LIBRARY_NAME=nvidia`
- **Sync/reverse sync**: X11 only; do NOT work under Wayland
- **NixOS specialisations**: Create boot profiles e.g. `specialisation.on-the-go.configuration = { ... }`

## Wayland

- `hardware.nvidia.modesetting.enable = true` required
- Drivers ≥555 add explicit sync (improves frame pacing/flickering)
- PRIME sync/reverse sync do NOT work under Wayland; offload works
- GNOME Wayland ≥535 supported; KDE Plasma 6 usable; Hyprland works but unofficially

## Troubleshooting

- **Boots to text mode**: Add `boot.initrd.kernelModules = ["nvidia"]`
- **Screen tearing**: Try `hardware.nvidia.forceFullCompositionPipeline = true` or PRIME sync mode
- **Picom flickering**: Set `unredir-if-possible = false; backend = "xrender"; vsync = true`
- **Suspend/resume crash**: `hardware.nvidia.powerManagement.enable = true`; redirect VRAM save path with `boot.kernelParams = ["nvidia.NVreg_TemporaryFilePath=/var/tmp"]`
- **Black screen on laptops**: May need `boot.kernelParams = ["module_blacklist=i915"]` (Intel) or `"module_blacklist=amdgpu"` (AMD) — but this breaks PRIME, use only when not using hybrid graphics

## CUDA / MPS

- CUDA: see this repo's `modules.hardware.nvidia.cuda.enable`
- MPS: custom systemd service wrapping `nvidia-cuda-mps-control`
- Pin specific driver: `nvidiaPackages.mkDriver { version = "..."; sha256_64bit = "..."; }`

Example (this repo's bagalamukhi config):
```nix
hardware.nvidia = {
  enable = true;
  open = true;  # or false for proprietary
  prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
};
```

Reference: [wiki.nixos.org/wiki/NVIDIA](https://wiki.nixos.org/wiki/NVIDIA)