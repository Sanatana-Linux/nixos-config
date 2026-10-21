---
title: Wayland compositors & shells — AwesomeWM feature parity
type: research
date: 2026-10-21
status: current
tags: [wayland, compositor, awesomewm, window-manager, desktop-shell, lua]
sources: deep-research subagent (general), primary docs + GitHub repos
---

# Wayland Compositors & Shells — AwesomeWM Feature Parity

> Research snapshot 2026-10-21. **Hyprland excluded by requirement.** Goal: find a Wayland
> compositor/shell that matches AwesomeWM's model — Lua scripting, tags (not workspaces),
> wibox widgets, rules engine, user-writable layouts, signal-driven client lifecycle.

## Parity bar (8 AwesomeWM capabilities)

1. **Lua scripting** — full programmable config, not a static config file
2. **Tiling + floating** — dynamic layouts, switchable per-tag
3. **Tags** — a window can hold multiple tags; multiple tags visible at once; per-tag layout
4. **Widget toolkit** — wibox-style bars/panels/OSD built in-process
5. **Key/mouse bindings** — arbitrary global hotkeys, keygrabbers, client mouse bindings
6. **Rules engine** — declarative matching of new clients → tags/floating/geometry
7. **Extensible layouts** — write new layouts in the scripting language
8. **Signals/lifecycle** — event-driven scripting on manage/focus/unfocus/property-change

## Comparison table

| Candidate | Lang | Maintained 2025–26 | Lua scripting | Tile+Float | Tags (multi) | Widgets | Keybinds | Rules | Ext. layouts | ≈Awesome (1–10) |
|---|---|---|---|---|---|---|---|---|---|---|
| **somewm** | C + LuaJIT | ✅ active (2.1, 2026-10) | ✅ awesome Lua API | ✅ | ✅ multi + per-tag layout | ✅ wibox-compatible | ✅ +keygrabber | ✅ awful.rules | ✅ in Lua | **10** |
| **cwc / cwcwm** | C + LuaJIT | ✅ (v0.4 2026-06, commits 2026-10) | ✅ Lua API (gears ported) | ✅ | ✅ tags not workspaces | ❌ external layer-shell | ✅ kbind/kbindmap | ✅ cuteful.rules | ✅ Lua custom layouts | **8** |
| **somewm-kiln** (sibling) | C + Lua? | ✅ (same maintainer, experimental) | ✅ | ✅ | ✅ | ✅ Clay layout tree | ✅ | ✅ | ✅ | 8 (experimental) |
| **qtile** (Wayland) | Python | ✅ active | ✅ Python (not Lua) | ✅ many layouts | ❌ groups = workspaces | ✅ built-in bar widgets | ✅ | ◑ Match/dgroups | ✅ in Python | 7 |
| **river-classic** | Zig | ✅ maintenance fork of 0.3 | ❌ riverctl IPC | ✅ | ✅ bitmask multi-tag | ❌ external | ✅ | ✅ rule-add globs | ✅ external layout generators | 6 |
| **mangowm (mango)** | C | ✅ very active | ❌ text config + IPC | ✅ many layouts | ✅ per-tag layouts | ❌ external | ✅ | ✅ window rules | ❌ compile-time | 5 |
| **wayfire** | C++ | ✅ active | ❌ INI | ◑ simple-tile plugin | ❌ workspace grid | ❌ wf-shell external | ✅ key/btn/gesture/corner | ✅ rich criteria | ◑ C++ plugins | 4 |
| **miracle-wm** | C++ (Mir) | ✅ active | ❌ YAML + IPC | ✅ | ❌ workspaces | ❌ external | ✅ | ✅ custom rules | ◑ WASM plugins | 4 |
| **dwl** | C | ✅ active | ❌ config.h recompile | ✅ | ✅ bitmask tags | ❌ external (by design) | ✅ | ✅ config.h rules | ◑ C patches | 4 |
| **sway / swayfx** | C | ✅ both active | ❌ config + JSON IPC | ✅ | ❌ workspaces | ❌ swaybar/waybar external | ✅ | ✅ for_window criteria | ❌ | 3 |
| **niri** | Rust | ✅ very active | ❌ KDL config + IPC | ✅ scrollable tiling | ❌ dynamic workspaces | ❌ external (quickshell) | ✅ | ✅ window-rule blocks | ❌ | 3 |
| **labwc** | C | ✅ active (feature-frozen 2026) | ❌ XML | ❌ stacking + snap | ❌ workspaces | ❌ external | ✅ | ✅ openbox app rules | ❌ | 2 |
| **newm-atha** | Python | ⚠️ dormant keeper fork | ✅ Python | ◑ zoomable wall | ❌ | ❌ external panels | ✅ | ◑ | ◑ Python | 2 |
| **way-cooler** | Rust | ❌ **archived 2020-01-11** | (Lua planned, never finished) | ◑ | — | — | — | — | — | dead |

Legend: ✅ full · ◑ partial · ❌ none/absent · **bold** = genuine awesome-parity contenders.

## Desktop shells (recreate the wibox/widget layer on any compositor)

These are **not compositors** — they replace awesome's *widget* layer atop a tag-capable compositor.

| Shell | Lang | Role | Notes |
|---|---|---|---|
| **Quickshell** | QML/QtQuick | bars, widgets, OSD, lockscreens | De-facto successor to the awesome widget role; live-reload; what Noctalia / DankMaterialShell build on. niri steers users to it. |
| **ags** (Aylur's GTK Shell) | JS/GJS (GTK) | shell widgets | Mature, compositor-agnostic via layer-shell; scripts the shell, not the WM. |
| **eww** | Rust + yuck (GTK) | widgets | Same role; external to the WM. |

## Findings

- **somewm is the literal answer.** A from-scratch wlroots compositor (C + LuaJIT, GPLv3) implementing
  the AwesomeWM Lua API — tags, wibox widgets, awful.rules, signals, user Lua layouts. `release/1.4`
  targets 100% awesome parity; `main` (2.x-dev) has documented deviations. An awesomeWM maintainer
  pointed users to it on upstream issue awesomeWM/awesome#159 (2026-03). Risk: young project, small
  bus factor. ~403 stars, NixOS/AUR/Debian/Fedora packaging. [github.com/trip-zip/somewm](https://github.com/trip-zip/somewm) · [somewm.org docs](https://somewm.org/docs/next/getting-started/installation)
- **cwc** is second-best and arguably better-engineered — awesome-shaped object model (`cwc.client`,
  `cwc_tag`, `cuteful.rules`, ported `gears.*`), but **no wibox** (bring an external bar). Author warns
  crashes may happen. [github.com/Cudiph/cwcwm](https://github.com/Cudiph/cwcwm)
- **awesome upstream will never be a Wayland compositor** — issue #159 closed `wontfix`/locked (2022).
  "Awesome on Wayland" = somewm or cwc, not upstream. [awesomeWM/awesome#159](https://github.com/awesomeWM/awesome/issues/159)
- **river renamed/split:** `river` (main) is now a non-monolithic compositor delegating WM policy to a
  client protocol; the awesome-relevant dynamic-tiling feature set lives in **`river-classic`** (0.3
  maintenance fork). Tags + external layout generators + riverctl rules.
- **qtile** is the pragmatic pick if you want scripting + built-in widgets and can accept workspaces
  (groups) instead of tags. Wayland backend has known gaps; "wayc" C rewrite in progress.
- **way-cooler is dead** (archived 2020). **newm-atha is dormant.** **piemi: no such compositor found.**
- Nothing outside somewm/cwc ships all 8 capabilities. Everything else = compositor + external shell
  (quickshell), and you lose the unified in-process signal model.

## Practical recommendation for this repo

| Priority | Path | Why |
|---|---|---|
| Literal parity | **somewm** (`release/1.4`) | Only option carrying existing awesome configs/widgets/themes to Wayland |
| Best engineering, accept ext. bar | **cwc** | awesome model minus wibox; cleaner; pair with quickshell for widgets |
| Scripting + widgets, accept workspaces | **qtile (Wayland)** | Python config, built-in bar; lose tag semantics |
| Assemble from parts | **river-classic + quickshell** | tags + rules + external widgets over IPC |

## Conflicts & gaps

- **river naming** — awesome-relevant features are in `river-classic`, not mainline `river`.
- **maomaowm → mangowm** — same author; maomaowm superseded/renamed; old mirrors linger.
- **qtile Wayland widget gap list** lives on a non-fetchable GitHub Projects board → Medium confidence.
- **somewm 2.x deviations** — exact list in-repo (`DEVIATIONS.md`), not independently verified.
