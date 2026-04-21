# Architecture

Core concept: Multi-host NixOS flake using activate-by-enable-option modules. Each host imports shared modules and enables only what it needs. Home-manager integrates at the system level via `home-manager.nixosModules.home-manager`.

Key Points:
- All modules follow `options.modules.<category>.<name>.enable = mkEnableOption` + `config = mkIf cfg.enable`
- User modules must only be imported on hosts that use them (never shared `default.nix` importing all users)
- Kernel modules/params belong with the hardware module that needs them, not centralized
- Overlays (additions, modifications, stable-packages, NUR) are applied in flake.nix and per-host
- Git submodules in `external/` are symlinked via `config.lib.file.mkOutOfStoreSymlink`

Example:
```nix
options.modules.hardware.nvidia.enable = mkEnableOption "NVIDIA GPU support";
config = mkIf cfg.enable {
  boot.kernelModules = ["nvidia" "nvidia-drm"];
  hardware.nvidia.enable = true;
};
```

Reference: [.documentation/ARCHITECTURE.md](../../.documentation/ARCHITECTURE.md)