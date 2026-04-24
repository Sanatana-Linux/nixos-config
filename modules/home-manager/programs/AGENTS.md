<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/home-manager/programs/

## Purpose
User-level program configurations managed via home-manager. Each module configures a specific application with the enable-by-option pattern.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports program submodules |
| `firefox.nix` | Firefox browser (config from `external/firefox`) |
| `kitty.nix` | Kitty terminal emulator |
| `ghostty.nix` | Ghostty terminal emulator |
| `neovim.nix` | Neovim editor (config from `external/nvim`) |
| `yazi.nix` | Yazi terminal file manager |
| `fastfetch.nix` | Fastfetch system info |
| `gpg.nix` | GnuPG configuration |
| `zathura.nix` | Zathura PDF viewer |
| `vesktop.nix` | Vesktop (Discord client) |
| `editorconfig.nix` | EditorConfig defaults |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `fastfetch/` | Fastfetch config files |
| `yazi/` | Yazi keymap and theme config |

## For AI Agents

### Working In This Directory
- Firefox and neovim configs are loaded from `external/` git submodules — do not inline their settings
- These are home-manager modules, not NixOS modules — use `programs.<name>` options, not `services` or `environment`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->