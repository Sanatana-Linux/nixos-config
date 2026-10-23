# Wiki Operation Log

> Chronological record of all context operations. Append-only.

---

## 2026-07-15 | consume | Ingest and synthesize `.documentation/` into durable context

**Operation**: Consumed 10 source files from `.documentation/` directory, refined and synthesized into 6 well-organized context pages.

**Source files processed**:
- `.documentation/ARCHITECTURE.md` (583 lines)
- `.documentation/Nix_Modules_Explained_Coherently.md` (127 lines)
- `.documentation/quickstart.md` (360 lines)
- `.documentation/iso.md` (10 lines)
- `.documentation/live-usb.md` (19 lines)
- `.documentation/nix-commands.md` (63 lines)
- `.documentation/searching-and-installing-packages.md` (99 lines)
- `.documentation/zsh-keybindings.md` (62 lines)
- `.documentation/using-repository-templates.md` (56 lines)
- `.documentation/TODO.md` (12 lines)

**Files created**:
- `frameworks/nixos-architecture.md` — Synthesized from ARCHITECTURE.md + Nix_Modules_Explained_Coherently.md
- `frameworks/nixos-installation-guide.md` — Synthesized from quickstart.md + iso.md + live-usb.md
- `frameworks/nixos-package-management.md` — Synthesized from searching-and-installing-packages.md
- `frameworks/zsh-keybindings.md` — From zsh-keybindings.md (restructured with YAML frontmatter)
- `frameworks/nix-flake-templates.md` — From using-repository-templates.md (restructured with YAML frontmatter)
- `nix-commands-reference.md` — From nix-commands.md (restructured with YAML frontmatter)

**Infrastructure created/updated**:
- `wiki-schema.md` — New wiki schema describing structure, frontmatter, compliance procedures
- `index.md` — New full catalog of all 23 context entries across frameworks, decisions, references, research, and sessions
- `log.md` — This entry

**Cross-references added**:
- `[[nix-secrets-reference]]` linked from `nixos-installation-guide.md`
- All framework pages cross-linked through the catalog `index.md`

**Status**: All `.documentation/` source files remain in place for user review. Once confirmed, originals can be purged.

---

## 2026-07-15 | consume | Ingest debugging journal + advanced BIOS archive

**Operation**: Consumed 9 debugging journal entries and 1 archived BIOS document into 2 synthesized context pages.

**Source files processed**:
- `.documentation/debugging/index.md` — Journal overview
- `.documentation/debugging/nvidia-reinstallation-nightmare.md` — Hybrid graphics lesson
- `.documentation/debugging/nix-store-issue.md` — NarHash corruption
- `.documentation/debugging/cpu-mem-overload-install.md` — OOM during install
- `.documentation/debugging/zsh-slowdown.md` — ZSH loading latency
- `.documentation/debugging/gcc-cannot-compile-during-rebuild.md` — GCC build failure
- `.documentation/debugging/not-enough-memory.md` — Insufficient device memory
- `.documentation/debugging/nvim.md` — Neovim TSInstall clang fix
- `.documentation/debugging/systemd-vconsole-setup-font.md` — Console font resolution
- `.documentation/archived/advanced_bios/lenovo-advanced-bios.md` — SREP BIOS unlock story

**Files created**:
- `frameworks/nixos-troubleshooting.md` — Synthesized from 9 debugging entries into a categorized troubleshooting reference
- `research/lenovo-advanced-bios-srep.md` — Archival synthesis of the SREP chainload and undervolt story

**Cross-references added**:
- `nixos-troubleshooting.md` links to `[[decisions]]` for ADRs covering fan/thermal/NVIDIA fixes
- `lenovo-advanced-bios-srep.md` links to `[[decisions]]` for ADR-015 (SREP→fwsetup) and ADR-011 (TLP CPU caps)

**Remaining unconsumed files**:
- `.documentation/CHANGELOG.md` — Key decisions already captured in `decisions.md` ADRs
- `.documentation/TODO.md` — All items completed; no actionable content to synthesize
- `.documentation/new-TODO.md` — Empty placeholder
- `.documentation/debugging/template.md` — Blank template, no content

**Note**: Several README-linked files (`encrypted-root.md`, `FLAKES.md`, `flake.nix.md`, `nvidia-settings.md`, `secrets*`, `sops*`, `credits.md`, `debugging/display-manager.md`, `debugging/cuda-compat.md`, `debugging/annoying-permissions-errors.md`) no longer exist in `.documentation/` — the README references are stale.

## 2026-10-22 — CUDA build strategy captured

**Source**: rebuild session on `bagalamukhi` (nixos-unstable-small, cudaSupport on)

**Files created**:
- `cuda-build-strategy.md` — why CUDA derivations compile locally, the `enableCuda` override argument, verified cache behaviour, build-throughput settings, and rebuild operator rules

**Files updated**:
- `decisions.md` — ADR-019 (disable `enableCuda` for opencv4/peakperf, keep it for ollama/torch, maxJobs 4 + cores 6)
- `index.md` — registered `cuda-build-strategy`

**Findings left in code, not context**:
- `peakperf` GPU path targets `compute_50`, dropped in CUDA 13
- `svgwrite` `test_performance` is a wall-clock assertion that fails on a loaded host

## 2026-10-22 — rebuild throughput: weights vs caps

**Source**: interactive-slowness report during a `gimp` rebuild

**Files updated**:
- `cuda-build-strategy.md` — expanded the build-throughput section: activation-lag trap (config says 4/6 while the live daemon runs 32/0), `cores = 0` meaning unlimited, CPUWeight/IOWeight vs `daemonCPUSchedPolicy` vs `CPUQuota`
- `decisions.md` — ADR-020 (weight the daemon build subtree; rejected SCHED_IDLE and hard quota)

**Operational note recorded**: `systemctl set-property --runtime nix-daemon.service CPUWeight=15 IOWeight=40` relieves an in-flight rebuild without killing it.

## 2026-10-23 — Secure Boot chain of trust + CUDA 13/Pascal pin

**Source**: design discussion on `kamala` under a hard "the GRUB theme stays" constraint, plus a failed evaluation of the kamala system closure

**Files created**:
- `research/secure-boot-chain-of-trust.md` — enforcement as an action at UEFI `LoadImage` rather than a property of a file; `chainloader` evidence from upstream source; why lanzaboote is systemd-boot-only; Limine's style ceiling against the Bhairava theme; measured UKI budget (~132M each → 3 generations); the proposed GRUB + signed-UKI design with ordering and open questions

**Files updated**:
- `decisions.md` — ADR-021 (keep GRUB + theme, reject lanzaboote and Limine, Secure Boot stays off) and ADR-022 (pin `cudaPackages` to 12.9 for sub-7.5 capabilities)
- `cuda-build-strategy.md` — the CUDA 13.4 `backendStdenv` assertion, probe results, and the pinning rule
- `research/lanzaboote-secure-boot.md` — cross-reference to the new synthesis
- `index.md` — registered `research/secure-boot-chain-of-trust`

**Claims asserted then retracted during the discussion** (kept here so they are not re-derived):
- "a signed GRUB's verification is decorative" — true for the `linux` path, false for `chainloader`, which calls firmware `LoadImage`
- "lanzaboote fits 10 generations in a 512M ESP" — true only because it deduplicates kernel+initrd; one UKI per generation costs ~132M
- "there is no chainloader entry in this repo" — there was, in history: `956d7e7` used `chainloader @bootRoot@/EFI/Boot/BootX64.efi`, replaced by `fwsetup` in `9bd2c33`

**Findings left in code, not context**:
- `modules/nixos/system/boot.nix:167` hardcodes `efiSysMountPoint = "/boot/efi"`; the `efiMountPoint` option is dead and `hosts/matangi/default.nix` sets it to no effect
- nixpkgs packages `shim-unsigned` but no bootloader path consumes it; the nixpkgs GRUB EFI build carries 293 modules with neither `shim_lock` nor `verify`

**Open**: the drive/LUKS migration for the same host is staged outside context at `/etc/nixos/.tmp/kamala-storage/` (gitignored) — summarised in §8 of the new research page.
