<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# zsh/

## Purpose
Zsh shell configuration as a home-manager module. Configures vi-mode keybindings, extensive completion system with zstyle settings, zplug plugins, carapace/sk integration, autosuggestions, history substring search, custom aliases, and startup banner.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Zsh module — `modules.shell.zsh.enable` with sub-options for aliases (`enableAliases`) and plugins (`enablePlugins`) |

## For AI Agents

### Working In This Directory
- Default keymap is `viins` (vi insert mode) — maintain vi-style bindings consistency
- Home/End keys are bound for multiple terminal escape sequence variants (xterm, Kitty, app mode) and both insert and vicmd modes
- Completion uses vim-style `hjkl` navigation in the menu select mode
- Zplug plugins are imported from GitHub repos — check availability before adding new ones
- Aliases replace many coreutils with modern alternatives (eza for ls, bat for cat, dust for du, procs for ps, rga for grep)
- History is configured for very large retention (9000000 save, 9900000 size) with shared history across sessions
- `initContent` runs after zsh init — carapace, skim, and custom functions (`lk`, `ollama_update`) are defined here
- XDG directories are used for zsh config (`dotDir`), history path, and cache

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->