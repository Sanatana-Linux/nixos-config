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

---

# Exotic / code-first options (maximum control, wide open to modify)

> For a user who wants to **write the WM logic and the widget layer as code**, not adopt someone's
> pre-built shell. Workspaces fine (tags optional). Frameworks, not dotfile distros.

## Scriptable compositors (you write WM logic in code)

| Name | Lang / base | Framework or config? | Scripting lang | Control depth | Maintained | Daily-drivable | Notes |
|---|---|---|---|---|---|---|---|
| **Pinnacle** | Rust / Smithay | **Framework** — configured as code | **Lua or Rust** | full (layouts, window behavior, keybinds, decorations, signals) | ✅ active (2026-06) | usable | **AwesomeWM-inspired, tag system, dynamic tiling.** The single best match: awesome's model, configured in real Lua (or Rust), on Smithay. Has a Nix flake. [github.com/pinnacle-comp/pinnacle](https://github.com/pinnacle-comp/pinnacle) |
| **jay** | Rust | framework-ish | TOML + live-reload | high (keybinds, layout, input in config; core is code) | ✅ very active (2026-10) | yes | i3-feel, Rust, single-author but consistent. Workspaces not tags. [github.com/mahkoh/jay](https://github.com/mahkoh/jay) |
| **kiwmi** | C / wlroots | **Framework** — you write `main()`/Lua | **Lua** | full (layouts, input, rendering behavior scripted) | ⚠️ slow (2025-08) | toy/usable | "Fully programmable, enforces no logic." True awesome-spirit (Lua, script everything) but WIP + steep curve. [github.com/buffet/kiwmi](https://github.com/buffet/kiwmi) |
| **japokwm** | C / dwl+wlroots | config | text file | layout-centric (built around creating layouts) | ⚠️ slow (2025-11) | usable | Dynamic tags, layout-focused, dwl-descended. [github.com/itsjakobx/japokwm](https://github.com/itsjakobx/japokwm) |
| **vivarium** | C / wlroots | config + C header | TOML (custom code in C via `viv_config.h`) | layouts/keybinds hardcoded; custom layouts need C + recompile | ❌ dormant (2023-09) | usable-ish | xmonad semantics. Author *wants* to make it a FFI library but hasn't. [github.com/inclement/vivarium](https://github.com/inclement/vivarium) |
| **way-cooler** | Rust | framework | Lua (planned) | — | ❌ archived 2020 | dead | Historical only. |

**The standout here is Pinnacle** — it's the only living, actively-developed, awesome-*inspired* compositor where the config IS Lua (or Rust) code and the tag system is first-class. Built on Smithay, ships a Nix flake (drops into this repo cleanly), documented Lua + Rust API references. kiwmi is the purer "script literally everything in Lua" ideal but is slow-moving and unfinished.

## Code-first widget/shell frameworks (the wibox you write yourself)

| Framework | Language | Your code vs framework | Services included | Maturity | Maintained | Control (1–10) |
|---|---|---|---|---|---|---|
| **quickshell** | QML/JS (Qt6) | **all your code** (types + services, zero layouts shipped) | pipewire, net, bt, notif-daemon, mpris, tray, upower, pam, polkit, greetd, lock, screencopy, hyprland/i3 | high (v0.3.2, 2026-10) | ✅ | **9** |
| **astal + Gnim** | TS/JSX (GJS) over Vala/C libs | **all your code** (library-first, ships no widgets) | wireplumber, net, bt, brightness, notif, mpris, tray, battery, apps, auth, idle, cava, greetd, ext-workspace | high | ✅ | **8** |
| **ignis** | Python (GTK4) | mostly your code | audio, backlight, bt, net, notif, mpris, tray, upower, apps, recorder, wallpaper, systemd, hyprland, niri | medium (Rust rewrite announced) | ✅ w/ caveat | 7 |
| **fabric** | Python (GTK3) | mostly your code | partial (audio, bt, notif, tray, power, hyprland/i3/niri) | medium-high | ✅ | 6.5 |
| **raw gtk4-layer-shell** | C/Rust/Python/Vala/**Lua via lgi** | **everything yours** | none (just layer-shell + session-lock) | high (the substrate) | ✅ | **10** |
| **Lua: lgi + gtk4-layer-shell GIR** | Lua | **everything yours** | none | unproven | n/a (DIY) | 10 (solo expedition) |
| **ironbar** | TOML/YAML + embedded Lua | bar framework, Lua for widget logic | tray/net/bt/audio/clipboard as bar modules | alpha, daily-driven | ✅ | 5 |
| **eww** | Rust + yuck DSL | DSL-limited, script via shell | none built-in | aging | ⚠️ dormant | 4 |

**Framework notes:** quickshell is the wibox-replacement ceiling — ships *types and services*, no
layouts, so you write every pixel in QML/JS (reactive property bindings ≈ awesome's signal model) and
it covers lockscreen/polkit/greetd/screencopy. astal is the most library-honest and has the deepest
service list + a **river** module. **There is no maintained Lua-native Wayland widget framework** — the
Lua path is lgi → GTK4 → gtk4-layer-shell GIR, which works but you're the entire ecosystem. Raw
gtk4-layer-shell (Rust gtk4-rs/relm4 or Python) is the true "no framework" floor — 10/10 control,
you re-derive the services yourself.

## Modular tools (assemble the shell from single-purpose scriptable pieces)

| Role | Best-in-class 2026 | Scriptable via | Notes |
|---|---|---|---|
| Wallpaper | **awww** (née swww) | CLI + unix socket | animated transitions, daemonized |
| OSD (rich) | **swayosd** | CLI flags | GTK OSD: volume/brightness/capslock |
| OSD (minimal) | **wob** | FIFO/socket | pure overlay bar, zero deps |
| Notifications | **mako** / dunst / fnott | makoctl/dunstctl + D-Bus | mako = dunst-style config |
| Launcher | **walker** (+elephant) | unix socket + dmenu + custom menus | GTK4/Rust front, Go backend, providers |
| Launcher (minimal) | **fuzzel** / tofi | stdin→stdout dmenu | tiny, C, wlroots |
| Lockscreen | **gtklock** | config + CSS + PAM | ext-session-lock via gtk-session-lock |
| Bar (config fallback) | **ironbar** | TOML/YAML + Lua + IPC | escape hatch if a framework bar is too much some week |

## The actual answer for maximum control

**Pinnacle (compositor, Lua/Rust config) + quickshell (widget layer, QML)** is the exotic code-first
pair: both are frameworks, neither ships opinions, and you write the WM logic *and* the wibox as code.
Pinnacle is awesome-inspired with a real tag system and Lua config; quickshell is the deepest
build-it-yourself widget toolkit. If you want to keep everything in **Lua**, Pinnacle handles the WM
in Lua and you'd write widgets via lgi+gtk4-layer-shell (lonely) — or accept QML for the shell.
If the plumbing is the fun, **raw gtk4-layer-shell in Rust** is the no-framework floor.

---

# Deep-cut programmable compositors (the exotic tier)

> Found via `gh search` across obscure repos, sorted by recent activity — not the first search page.
> These are the ones where the WM logic itself is code you write, not a config file. Verified against
> READMEs and GitHub API (created/pushed dates) on 2026-10-21.

| Name | Core | You write WM logic in | In-process reactive UI? | Maturity | Notes |
|---|---|---|---|---|---|
| **ShojiWM** | Rust / Smithay | **TypeScript/TSX** (embedded Deno/V8) or **Rust** | **Yes** — TSX components with signals render SSD/chrome reactively | young (created 2026-03, pushed 2026-10, 751★) | **The closest thing to "awesome but the whole WM is your code."** Compositor is a framework; the WM is the default *config* you rewrite. Pluggable `ConfigRuntime` — write a runtime for Lua/Python/C#. Custom per-element shader pipeline, tearing, xwayland-satellite. NixOS module. [bea4dev/ShojiWM](https://github.com/bea4dev/ShojiWM) |
| **minde** | Rust / Smithay | **Guile Scheme** policy layer | No (ext via IPC/Eww) | RC (1.0.0-rc1, created 2026-08, 0★) | StumpWM model: frames/groups/master-stack. **Live Scheme eval on the compositor thread**, hooks, atomic config reload, JSON state + event socket, agent control surface with typed actions + receipts. Docs are exceptional. One maintainer. [9s-l-s9/minde](https://github.com/9s-l-s9/minde) |
| **Pinnacle** | Rust / Smithay | **Lua or Rust** | Partial (snowcap widget layer) | active (2026-06, 647★) | Awesome-inspired, tag system, real Lua config code. Has a Nix flake — drops into this repo. [pinnacle-comp/pinnacle](https://github.com/pinnacle-comp/pinnacle) |
| **rhizome** | River protocol | **Common Lisp** | No | young (created 2026-07, 6★) | StumpWM-style WM as a **client of river's** `river-window-management-v1` protocol — the WM is a separate Lisp program. Proof the "WM-as-process" pattern is real on river. [parenworks/rhizome](https://github.com/parenworks/rhizome) |
| **clear** | Rust | **Rhai** extensions | Optional (ships a quickshell example) | experimental (0★) | Modular Rust compositor with Rhai scripting + an optional Quickshell pairing. [aneeshthunga26/clear](https://github.com/aneeshthunga26/clear) |
| **fwm** | C / wlroots | TOML + `fwmctl` JSON IPC | No (built-in shell: launcher/mixer/visualiser) | active daily driver (184★) | Physics WM (Box2D) + BSP tiling + built-in shell, all one TOML. Deep live IPC, every setting scriptable. Not a real programming language, but the most feature-dense single binary. Nix flake. [iluaii/fwm](https://github.com/iluaii/fwm) |
| **halley** | Rust | config | No | active (182★) | Spatial / infinite-workspace navigation. |
| **Aqueous** (+ **Pearl** shell) | Zig | config | Pearl = GTK4 shell | young (42★) | One-process Zig compositor + Vulkan effects; Pearl is the matching shell. |
| **solium** | Rust / Smithay | **Lua + QML** | Yes (QML) | brand new (created 2026-09, 4★) | Lilium DE's compositor: Smithay + Lua + QML. The "Lua config + QML widgets" combo in one process, but days old. |
| **jay** | Rust | TOML live-reload | No | very active (719★) | i3-feel, single-author, consistent. More "configured" than "programmed." |

## What actually answers the brief

Three stand out for "write the WM as code, wide open":

1. **ShojiWM** — the WM layer is **TypeScript/TSX you write**, with reactive signals, in a framework
   compositor (Smithay). Most awesome-like *philosophy* (the WM is your program), and TSX is the same
   family as quickshell's QML/JS — so the compositor logic and a quickshell shell are nearly the
   same language. Young (2026-03) but the architecture is exactly the brief.
2. **minde** — **Guile Scheme** policy layer over a Rust/Smithay core, with live-eval, hooks, atomic
   reload, and a real agent/IPC control surface. StumpWM model. Best documentation and most
   principled "program your environment" design; one maintainer, brand new.
3. **Pinnacle** — **Lua or Rust**, awesome-*inspired* with a real tag system, actively maintained,
   Nix flake. The most established of the three and the easiest to drop into this repo today.

The "**same language across WM + widgets**" reality: only **ShojiWM** (TSX/JS) comes close to letting
you write WM logic and (via quickshell, QML/JS) the widget layer in one language family. **qtile +
ignis** is the only *strictly* same-language (Python) stack, but its Wayland backend (wayc) is young.
Everywhere else the WM config language ≠ the widget language.
