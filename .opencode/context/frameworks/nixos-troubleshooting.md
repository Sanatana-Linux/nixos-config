---
title: "NixOS Troubleshooting Notes"
type: concept
tags: [troubleshooting, debugging, nixos, errors, workarounds]
created: 2026-07-15
updated: 2026-07-15
sources: [.documentation/debugging/index.md, .documentation/debugging/nvidia-reinstallation-nightmare.md, .documentation/debugging/nix-store-issue.md, .documentation/debugging/cpu-mem-overload-install.md, .documentation/debugging/zsh-slowdown.md, .documentation/debugging/gcc-cannot-compile-during-rebuild.md, .documentation/debugging/not-enough-memory.md, .documentation/debugging/nvim.md, .documentation/debugging/systemd-vconsole-setup-font.md]
status: active
---

# NixOS Troubleshooting Notes

A collection of issues encountered, root causes, and resolutions from actual setup and maintenance of this configuration. These range from NixOS-specific gotchas to hardware quirks on the Lenovo Legion 5 Pro.

---

## Build & Installation Issues

### CPU/Memory Overload During Installation

**Problem**: During `nixos-install` with CUDA-enabled packages, CPU hits 100% and memory maxes out. Systemd OOM kills vital processes, and the system may overheat and shut down (14th-gen Intel i9).

**Root Cause**: CUDA package compilation is extremely resource-intensive. The 14th-gen Intel i9 runs hot under sustained full load, and the default unlimited voltage exacerbates this.

**Workaround**: Apply build constraints to prevent resource exhaustion:
```bash
sudo nixos-rebuild switch --flake .#hostname --max-jobs 1 --cores 16
```
This limits parallel builds and reserves cores for system responsiveness. Installation takes longer but succeeds without OOM or thermal shutdown.

**Prevention**: Apply voltage limits via BIOS undervolt or via the undervolt service in the NixOS config. See [[lenovo-advanced-bios-srep]] for the SREP-based approach (now archived — BIOS updated past N0CN35WW locked advanced menu).

---

### Not Enough Memory on Device

**Problem**: `nixos-rebuild` fails claiming insufficient memory on the device.

**Root Cause**: A recent change is likely trying to copy an excessively large file tree into the Nix store, exceeding the partition's capacity. Often caused by missing quotes around path values.

**Fix**: Roll back the offending change. Ensure path values are properly quoted (`"path"` rather than just `path`).

---

### GCC Cannot Compile During Rebuild

**Problem**: Rebuilds fail with errors that GCC is present but cannot compile executables. Triggered after a `nix flake update` that refreshed Firefox build inputs.

**Root Cause**: Potentially related to the `--impure` flag and sandboxing of the build environment. May involve stale build artifacts conflicting with updated dependencies.

**Attempted Mitigations** (not always sufficient):
- Deleting related Nix files from the store
- `nix-store --gc`, `nix optimize-store`, `nix-store --repair`

---

### Nix Store NarHash Corruption

**Problem**: After installing a package from a NUR (Nix User Repository), a narhash becomes corrupt, preventing any rebuild.

**Attempted Mitigations**:
- Cleaning the store
- Deleting caches
- Manual store optimization
- All failed

**Resolution**: Reinstall from scratch. The narhash corruption persisted through all standard recovery methods.

---

## Thermal & Hardware Issues

### NVIDIA Reinstallation Lockout (Don't Remove Intel Graphics)

**Problem**: After removing `xorg_sys_opengl` and Intel graphics packages on an NVIDIA+Intel hybrid graphics laptop, the system became unbootable. CUDA packages caused excessive resource consumption and overheating.

**Root Cause**: On hybrid graphics (NVIDIA + Intel), Intel graphics packages and `xorg_sys_opengl` are **required** — even if the dGPU is NVIDIA. Removing them breaks the graphics stack.

**Resolution**: Reinstall with Intel graphics packages present.
**Lesson**: Never remove `intel-media-driver` or `xorg` system packages on hybrid graphics laptops.

---

### Systemd VConsole Setup Font Not Found

**Problem**: Console font not found by `systemd-vconsole-setup`, causing boot-time errors.

**Root Cause**: `console.packages` must be configured separately from system fonts. The font package was included in `fonts.packages` but not in `console.packages`.

**Fix**: Added the font package to `console.packages` as well:
```nix
console.packages = with pkgs; [ terminus_font ];
```

---

## Shell & Editor Issues

### ZSH Slowdown at Loading Time

**Problem**: ZSH shell loads slowly with ZLE errors and completion engine stalls. Worsened over time with plugin accumulation.

**Fixes Applied**:
1. Moved zmodule loading to the completion init section
2. Eliminated redundant plugins
3. Rearranged config logic
4. Simplified/eliminated large swaths of code in the nix-rendered `~/.zshenv`
5. Reduced third-party plugin count

**Status**: Loading improved but some latency remains. A leaner approach (possible BASH migration or minimal ZSH) is under consideration.

---

### Neovim TSInstall Error

**Problem**: Neovim repeatedly throws error messages about missing critical libraries during `:TSInstall`.

**Root Cause**: Clang/LLVM toolchain not available in the system or home-manager environment.

**Fix**: Add `clang` to the configuration:
```nix
environment.systemPackages = with pkgs; [ clang ];
```
Or enable it in the home-manager programs module.

---

## Resources

- [Debugging Journal Template](template.md) — Template for documenting future issues systematically.
- [[decisions]] — Architecture Decision Records covering fan control, thermals, NVIDIA, and PCIe ASPM changes that resolved many of these issues.
