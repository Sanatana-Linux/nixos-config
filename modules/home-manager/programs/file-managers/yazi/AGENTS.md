<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# yazi/

## Purpose
Yazi terminal file manager configuration with custom keymap, openers, and yatline status bar. Configured as a home-manager module with plugins for git, mount, mime-ext, ouch, restore, sudo, piper, and yatline.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Yazi module — `modules.programs.yazi.enable`, plugins, yatline initLua, and symlinked config files |
| `keymap.toml` | Full keymap — vim-style hjkl navigation, sorting, tabs, copy path commands, zoxide/fzf jump, search |
| `yazi.toml` | Yazi settings — manager layout, preview config, file openers (thunar, feh, vlc, dtrx, inkscape), open rules |
| `theme.toml` | Color theme — currently NOT installed (commented out) to avoid conflicts with Stylix theming |

## For AI Agents

### Working In This Directory
- `theme.toml` exists but is **not installed** — Stylix handles Yazi theming instead. Do not uncomment the theme symlink.
- Config files (`yazi.toml`, `keymap.toml`) are installed via `home.file` symlinks, not `programs.yazi.settings`
- The shell wrapper is aliased to `r` (`shellWrapperName = "r"`)
- `initLua` configures the yatline status bar with header and status line layouts — style uses plain color names (not hex)
- Plugins come from `pkgs.yaziPlugins.*` — check available plugins before adding
- Openers in `yazi.toml` use external tools (thunar, feh, vlc, dtrx, inkscape) — these must be installed separately

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->