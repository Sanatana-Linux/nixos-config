<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-22 | Updated: 2026-04-22 -->

# packages/

## Purpose
System-level package sets organized by category (archives, core, development, fonts, GUI, multimedia, network, python, shell, system, X11, Wayland). Each category has an enable option and fine-grained sub-options for selectively including package groups. Hosts opt-in by setting `modules.packages.<category>.enable = true` and toggling sub-features.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports `packages.nix` via imports |
| `packages.nix` | All package option declarations and `mkIf`-guarded `environment.systemPackages` lists for 12 categories |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| *(none)* | — |

## For AI Agents

### Working In This Directory
- This is the **largest** module in the repo — over 1100 lines. Use `optionals` patterns for sub-option gated packages; never add packages unconditionally
- Each category (e.g. `cfg.gui`, `cfg.development`) has a top-level `enable` plus sub-enables (e.g. `cfg.gui.libs.coreGraphics`)
- Minimal presets exist for `development`, `gui`, `multimedia`, and `system` — they use `mkDefault false` to disable heavy sub-options for ISO/live environments
- The `fonts` category also configures `fonts.fontconfig` settings, not just packages
- The `gui.libs` sub-category is nested two levels deep (e.g. `cfg.gui.libs.coreGraphics`)

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->