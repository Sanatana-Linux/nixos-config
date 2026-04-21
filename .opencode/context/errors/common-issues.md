# Debugging: Common NixOS Issues

Core concept: Known issues encountered in this configuration with their solutions, primarily around hardware, builds, and system services.

## CPU/Memory Overload During Install

- **Problem:** CUDA packages cause 100% CPU/RAM, OOM kills vital processes, overheating
- **Fix:** `nixos-install --max-jobs 1 --cores 16` to limit parallelism; disable CUDA packages during install then re-enable after

## NVIDIA Reinstallation Lockout

- **Problem:** Removing `xorg_sys_opengl` and Intel graphics packages breaks hybrid NVIDIA+Intel setups
- **Fix:** Never remove `intel-media-driver` or `xorg` system packages on hybrid GPU systems

## Nix Store NarHash Corruption

- **Problem:** Corrupt narhash after NUR package install, rebuilds fail, store repair doesn't help
- **Fix:** Reinstall was only option; back up vital files first

## NeoVim TSInstall Error

- **Problem:** Neovim missing critical libraries after reinstall
- **Fix:** Add `clang` to configuration

## Systemd VConsole Font Not Found

- **Problem:** Console can't find configured font at boot
- **Fix:** Terminal fonts must be specified in `console.packages` separately from `fonts.packages`

## ZSH Slowdown

- **Problem:** Slow shell startup, ZLE/completion errors
- **Fix:** Move zmodule loading to completion init, eliminate redundant plugins, simplify `.zshenv`

## Not Enough Memory During Rebuild

- **Problem:** `nixos-rebuild` fails with device full
- **Fix:** A recent change is likely copying a huge directory into the nix store; roll back or quote path values

## Upstream Bug After Channel Update

- **Problem:** A nixpkgs update breaks a package and no fix is in the channel yet
- **Fix:** Cherry-pick the unmerged PR using `applyPatches` + `fetchpatch`. The patch will fail when the fix lands in your channel, reminding you to remove it. See `guides/desktop-tips.md` for the full pattern

Reference: [.documentation/debugging/](../../.documentation/debugging/)