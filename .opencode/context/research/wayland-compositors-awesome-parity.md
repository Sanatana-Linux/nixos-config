---
title: Wayland compositor + desktop shell stacks — AwesomeWM parity
type: research
date: 2026-10-21
status: current
tags: [wayland, compositor, desktop-shell, awesomewm, quickshell, window-manager]
sources: deep-research subagents (general), primary docs + GitHub repos
---

# Wayland Compositor + Shell Stacks — AwesomeWM Parity

> Snapshot 2026-10-21. **Hyprland excluded by requirement.**
> The realistic path off awesome is a **two-part stack**: a tag-capable compositor
> (window management) + a desktop shell (the wibox/bar/OSD/notification layer).
> Reference the user already likes: **mangowm + quickshell**.

## Recommended compositor + shell stacks (ranked by awesome-likeness)

| Rank | Compositor | Shell | Why it's awesome-like | Gap |
|---|---|---|---|---|
| **1** | **mangowm** | **DMS (dux-shell)** | dwm-descended tags + per-tag layouts + rules + hot-reload + `mmsg` IPC; DMS replaces waybar/swaylock/mako/fuzzel/polkit in one, **first-class MangoWC support** | Two programs; IPC not in-process; DMS is Material-opinionated |
| **2** | **mangowm** | **Noctalia v5** | Same WM virtues; Noctalia lists **Mango** as a supported backend; lightweight native runtime, TOML hot-reload | v5 is a fresh rewrite (no Qt); TOML less scriptable than QML |
| **3** | **mangowm** | **quickshell (raw)** | Max scriptability — write your own wibox in QML/JS with live reload, mango IPC for tag state | You build notif daemon / launcher / OSD yourself |
| **4** | **river-classic** | **ags/astal** | river's multi-tag + multi-view is the **truest awesome tag semantics** on Wayland; astal has a dedicated river module | river-classic slow-moving; ags ecosystem shrinking vs quickshell |
| **5** | **dwl** | **waybar + swaync + rofi-wayland + swayosd** | dwm purity: tags, rules, status-stdout bar contract; every piece mature | Needs dwl IPC patch; 4–5 programs for the shell layer; compile-time config |
| **6** | **qtile-wayland** | built-in bar **+ ignis** | All-Python in-process WM + bar = awesome's actual architecture | `wayc` C backend rewrite (2026) is young; groups aren't quite tags |
| **7** | **niri** | **DMS / Noctalia** | Best-supported shell ecosystem, live-reload KDL, window rules | Dynamic workspaces ≠ tags — no multi-tag views, no sticky across tags |

## Desktop shells (the wibox/OSD/notification layer)

| Shell | Config lang | Bar | OSD | Notif | Launcher | Lock | Maintained | Maturity | Compositor-agnostic |
|---|---|---|---|---|---|---|---|---|---|
| **quickshell** | QML/JS | framework | framework | framework | framework | framework | ✅ active | high | ✅ |
| **DMS (dux-shell)** | QML/JS + Go | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ active | high | ✅ (optimized: niri/sway/**mango**/labwc/miracle) |
| **Noctalia v5** | TOML + native | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ active | medium (fresh rewrite) | ✅ (incl. **Mango**, **dwl**) |
| **Caelestia** | QML + shell.json | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ active | high | ❌ Hyprland-only |
| **end-4 ii** | QML + py venv | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ active | high | ❌ Hyprland-only dotfiles distro |
| **ags/astal v3** | TS/JSX (GJS) + Vala | framework | framework | framework | framework | framework | ✅ astal active | high | ✅ (hyprland/**river**/niri modules) |
| **eww** | Rust + yuck | ✅ | ◑ build it | ❌ | ❌ | ❌ | ⚠️ slow (author on yolk) | high (aging) | ✅ |
| **waybar** | JSONC + CSS | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ active | very high | ✅ (**river**/**dwl**/**mango** modules) |
| **ironbar** | TOML/YAML + Lua | ✅ | popups | ❌ | ❌ | ❌ | ✅ active | alpha | ◑ (sway/hyprland, niri partial) |
| **fabric** | Python + GTK3 | framework | framework | framework | framework | framework | ✅ slow cadence | medium | ✅ |
| **ignis** | Python + GTK4 | framework | framework | ✅ services | framework | framework | ✅ (Rust rewrite pending) | medium | ✅ layer-shell |

**Shell notes:** quickshell is the toolkit everything converges on (ships no bar/OSD itself — it's the
wibox framework). **DMS** = most complete pre-built shell, explicit mango support. **Noctalia v5** =
ground-up native rewrite (no Qt/GTK), supports mango + dwl. Caelestia & end-4 are Hyprland-coupled —
out. **ags/astal** has the only dedicated **river** module. **ignis** is the all-Python play (pairs
with qtile). **eww** is the most conceptually awesome-like widget DSL but widget-layer only and dormant.

## Compositors (the WM half) — tags/rules model

| Compositor | Lang | Tag model | Rules | Runtime config | Maintained |
|---|---|---|---|---|---|
| **mangowm** | C/wlroots | ✅ tags, per-tag layouts | ✅ window rules | ✅ hot-reload + `mmsg` IPC | ✅ very active |
| **river-classic** | Zig | ✅ **multi-tag windows + multi-tag views** (true awesome semantics) | ✅ riverctl rules | ✅ riverctl + ext layout gens | ✅ slow (0.3 fork) |
| **dwl** | C | ✅ bitmask tags | ✅ config.h rules | ❌ compile-time | ✅ active |
| **qtile-wayland** | Python | ◑ groups+scratchpads | ✅ Match/dgroups | ✅ Python | ✅ (wayc backend young) |
| **niri** | Rust | ❌ dynamic workspaces | ✅ window-rule blocks | ✅ KDL live-reload | ✅ very active |
| **wayfire** | C++ | ❌ Compiz grid | ✅ rich criteria | ✅ INI | ✅ |

**Compositor notes:** `river` split — awesome-relevant features live in **`river-classic`** (upstream
river went non-monolithic). **dwl** expects the two-part stack (no bar by design); mango exists because
of dwl's compile-time config. **niri**'s shell ecosystem is best-in-class but its model is workspaces,
not tags. **qtile** has the only built-in widget bar (in-process, awesome's real architecture).

## Dotfile distros (bundled shell+compositor; strip difficulty)

| Distro | Shell | Compositor | Strip-to-shell |
|---|---|---|---|
| **DMS/Dux** | quickshell+Go | any (mango-optimized) | **Trivial — ships as a shell package** |
| **Noctalia v5** | native | any (mango, dwl) | **Trivial — shell-only default** |
| Caelestia | quickshell | Hyprland (hard-coded) | Hard |
| end-4 ii | quickshell | Hyprland (hard-coded) | Very hard |

## Bottom line

The answer to "awesome on Wayland" in 2026 is a stack, not a single compositor. **mangowm + DMS**
is the least-assembly path to a complete awesome-like desktop (tags + rules + a full
bar/OSD/notif/launcher/lock shell with native mango support — CachyOS already ships it).
**mangowm + raw quickshell** is the max-control path (write your own wibox in QML). **river-classic +
ags/astal** is the most faithful to awesome's *tag semantics* specifically. The single-program
alternatives (somewm, cwc) chase the literal awesome Lua API but "targets 100% parity" is not "is
100% parity" — young projects, small bus factor.
