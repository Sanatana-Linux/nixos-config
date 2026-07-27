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
