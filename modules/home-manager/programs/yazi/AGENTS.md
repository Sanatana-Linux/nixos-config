<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-07-04 -->

# yazi/

## Purpose
Yazi terminal file manager configuration with custom keymap, openers, status bar, and 20+ plugins. Configured as a Nix-native home-manager module using `programs.yazi.settings`/`keymap`/`plugins` (no raw TOML, no initLua).

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Yazi module — `modules.programs.yazi.enable`, settings (manager layout, preview, openers, tasks, git fetchers, ouch previewers), keymap (only `prepend_keymap` for plugin bindings — built-in defaults apply for everything else), plugins (16 Nix-packaged + 2 external from GitHub) |

## For AI Agents

### Working In This Directory
- **Config approach**: All Yazi config is set via `programs.yazi.settings`, `programs.yazi.keymap`, and `programs.yazi.plugins` — no raw `yazi.toml`/`keymap.toml`/`theme.toml` files, no `home.file` symlinks, no `initLua`
- `theme.toml` exists but is **not installed** — Stylix handles Yazi theming instead. Do not uncomment the theme symlink.
- The shell wrapper is aliased to `r` (`shellWrapperName = "r"`)
- **Plugins with settings** use the submodule form: `programs.yazi.plugins.<name> = { package = pkgs.yaziPlugins.<name>; settings = {...}; }`
- **Plugins without settings** use the package-only form: `programs.yazi.plugins.<name> = pkgs.yaziPlugins.<name>`
- Most plugins come from `pkgs.yaziPlugins.*` (Nix-packaged). Two external plugins are fetched from GitHub via `pkgs.fetchFromGitHub`: `fd-fzf` and `fuzzy-search` (not yet in nixpkgs `yaziPlugins`)
- Openers use external CLI tools (thunar, feh, vlc, dtrx, exiftool, inkscape, mediainfo) — these are installed via `home.packages`
- `gitui` CLI tool is installed via `home.packages` — required by the gitui.yazi plugin
- **Keymap only has `prepend_keymap`** for custom plugin bindings. All built-in default keybindings come from Yazi's compiled-in defaults. Do NOT add `keymap` arrays duplicating defaults — they replace built-in bindings instead of extending them
- Plugin keymap prefixes are carefully chosen to avoid conflicts with default keybindings:
  - `l` → smart-enter, `p` → smart-paste (both intentionally shadow defaults)
  - `m` → bookmarks save (shadows linemode prefix)
  - `c m` → chmod, `c a` → compress (extends copy prefix)
  - `C` → ouch (compress), `X` → ouch (decompress), `M` → mount, `U` → restore (unused by default)
  - `g i` → gitui, `g v` → gvfs (extends goto prefix)
  - `R` → recycle-bin prefix, `<A-d>` → dupes, `<A-s>` → sudo

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->