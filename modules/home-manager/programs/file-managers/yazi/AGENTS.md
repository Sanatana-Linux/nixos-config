<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# yazi/

## Purpose
Yazi terminal file manager configuration with custom keymap, openers, and yatline status bar. Configured as a home-manager module with plugins for git, mount, mime-ext, ouch, restore, sudo, piper, and yatline.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Yazi module — `modules.programs.yazi.enable`, plugins, initLua setup for all plugins, yatline status bar, and symlinked config files |
| `keymap.toml` | Full keymap rewritten from official yazi default + plugin keybindings from each plugin's docs. Uses `[mgr]` section with `prepend_keymap` for plugins and `keymap` for defaults. Includes `[tasks]`, `[spot]`, `[pick]`, `[input]`, `[confirm]`, `[cmp]`, `[help]` sections. |
| `yazi.toml` | Yazi settings — manager layout, preview config, file openers, git fetchers for git.yazi plugin, ouch previewers |
| `theme.toml` | Color theme — currently NOT installed (commented out) to avoid conflicts with Stylix theming |

## For AI Agents

### Working In This Directory
- `theme.toml` exists but is **not installed** — Stylix handles Yazi theming instead. Do not uncomment the theme symlink.
- Config files (`yazi.toml`, `keymap.toml`) are installed via `home.file` symlinks, not `programs.yazi.settings`
- The shell wrapper is aliased to `r` (`shellWrapperName = "r"`)
- `initLua` configures all plugins: git, full-border, smart-enter, bookmarks, recycle-bin, dupes, restore, gvfs, and yatline
- Plugins come from `pkgs.yaziPlugins.*` — check available plugins before adding
- Openers in `yazi.toml` use external tools (thunar, feh, vlc, dtrx, inkscape) — these must be installed separately
- `gitui` CLI tool is installed via `home.packages` — required by the gitui.yazi plugin
- Keymap uses modern yazi syntax: `arrow prev`/`arrow next` (not `arrow -1`/`arrow 1`), `search --via=fd` (not `search fd`), `seek` (not `peek`)
- Plugin keymap prefixes are carefully chosen to avoid conflicts with default keybindings:
  - `l` → smart-enter, `p` → smart-paste (both intentionally shadow defaults)
  - `m` → bookmarks save (shadows linemode prefix)
  - `c m` → chmod, `c a` → compress (extends copy prefix)
  - `C` → ouch, `M` → mount, `U` → restore (unused by default)
  - `g i` → gitui, `g v` → gvfs (extends goto prefix)
  - `R` → recycle-bin prefix, `<A-d>` → dupes, `<A-s>` → sudo

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->