# Yazi Keymap Configuration — Researched 2026-06-29

## Source
- Context7: `/sxyazi/yazi` (635 code snippets, High reputation)
- Official default keymap: https://raw.githubusercontent.com/sxyazi/yazi/main/yazi-config/preset/keymap-default.toml
- Plugin docs: Read from nix store paths and GitHub READMEs

## Keymap Structure (Modern Yazi v25+)

Sections: `[mgr]`, `[tasks]`, `[spot]`, `[pick]`, `[input]`, `[confirm]`, `[cmp]`, `[help]`

Each section supports:
- `prepend_keymap = [...]` — prepended to defaults (takes priority)
- `keymap = [...]` — replaces defaults

## Key Syntax Changes (vs old yazi)

| Old | New |
|-----|-----|
| `arrow -1` / `arrow 1` | `arrow prev` / `arrow next` |
| `arrow -99999999` / `arrow 99999999` | `arrow top` / `arrow bot` |
| `search fd` / `search rg` | `search --via=fd` / `search --via=rg` |
| `search none` | `escape --search` |
| `peek -5` / `peek 5` | `seek -5` / `seek 5` |
| `<C-q>` close | `<C-c>` close (modern) |
| `[manager]` | `[mgr]` (renamed in v25.5.28+) |
| `tasks_show` | `tasks:show` |

## Installed Plugins and Their Keymap Syntax

### Official yazi-rs/plugins
- **smart-enter**: `plugin smart-enter` (bind to `l`)
- **full-border**: init.lua only, no keymap
- **git**: init.lua + yazi.toml fetchers, no keymap
- **mount**: `plugin mount` (bind to `M`)
- **piper**: yazi.toml previewer config, no keymap
- **chmod**: `plugin chmod` (bind to `c m`)
- **smart-paste**: `plugin smart-paste` (bind to `p`)

### Community plugins (from nixpkgs yaziPlugins)
- **bookmarks** (dedukun): `plugin bookmarks save`, `plugin bookmarks jump`, `plugin bookmarks delete`, `plugin bookmarks delete_all`
- **compress** (KKV9): `plugin compress`, `plugin compress -p`, `plugin compress -ph`, `plugin compress -l`, `plugin compress -phl`
- **dupes** (mshnwq): `plugin dupes interactive`, `plugin dupes override`, `plugin dupes dry`, `plugin dupes apply` — requires jdupes + init.lua setup with profiles
- **gitui** (gclarkjr5): `plugin gitui` — requires gitui binary
- **glow** : previewer plugin, configured in yazi.toml
- **gvfs** (boydaihungst): `plugin gvfs -- select-then-mount --jump`, `-- select-then-unmount --eject`, `-- add-mount`, `-- jump-to-device` — requires init.lua setup
- **nav-parent-panel** (yaqihou): `plugin nav-parent-panel prev`, `plugin nav-parent-panel next`, `first`, `last`
- **ouch** (ndtoan96): `plugin ouch` for compression, `ouch` as previewer in yazi.toml — requires ouch binary
- **recycle-bin** (uhs-robert): `plugin recycle-bin` (menu), `-- open`, `-- restore`, `-- delete`, `-- empty`, `-- emptyDays` — requires trash-cli
- **restore** (boydaihungst): `plugin restore`, `plugin restore -- --interactive` — requires trash-cli
- **sudo** (TD-Sky): `plugin sudo -- paste`, `-- paste --force`, `-- rename`, `-- remove`, `-- remove --permanently`, `-- create`, `-- link`, `-- hardlink`, `-- chmod`
- **yatline**: init.lua only, no keymap