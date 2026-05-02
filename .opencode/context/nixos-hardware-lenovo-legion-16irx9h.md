# nixos-hardware: Lenovo Legion 16IRX9H

> Source: https://github.com/NixOS/nixos-hardware/blob/b8f8163/lenovo/legion/16irx9h/default.nix

Reference hardware profile for Lenovo Legion Pro 7 16IRX9H (2024 model).

## Imports (inherited profiles)

| Import | Purpose |
|--------|---------|
| `common/cpu/intel` | Intel CPU microcode, features |
| `common/gpu/nvidia/prime.nix` | NVIDIA PRIME offload |
| `common/gpu/nvidia/ada-lovelace` | Ada Lovelace GPU support |
| `common/pc/laptop` | Laptop power management, battery |
| `common/pc/ssd` | SSD optimizations |
| `common/hidpi.nix` | HiDPI display scaling |

## Full Configuration

```nix
{ lib, config, ... }: {
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ada-lovelace
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/hidpi.nix
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];

  hardware.nvidia = {
    powerManagement.enable = lib.mkDefault true;
    prime = {
      intelBusId = "PCI:00:02:0";
      nvidiaBusId = "PCI:01:00:0";
    };
  };

  # Sound speaker fix, see #1039
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto
  '';
  boot.blacklistedKernelModules = [ "snd_soc_avs" ];

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  # √(2560² + 1600²) px / 16 in ≃ 189 dpi
  services.xserver.dpi = 189;
}
```

## Key Details

- **GPU**: NVIDIA Ada Lovelace + Intel iGPU (PRIME offload), PCI buses `00:02:0` / `01:00:0`
- **Audio**: Requires `snd-hda-intel model=auto`, blacklists `snd_soc_avs`
- **Kernel module**: `lenovo-legion-module` for fan/BIOS control
- **DPI**: 189 (2560×1600 on 16" display)
- **Cooling**: `thermald` for thermal management
- Uses `config.boot.kernelPackages` (not `pkgs.linuxPackages`) for kernel module packages
