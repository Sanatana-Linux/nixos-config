# Architecture Decision Records

## ADR-001: Sea-greeter theme directory patch (themes/ vs greeterThemes/)

- **Date**: 2026-05-05
- **Context**: sea-greeter C source code hardcodes `/usr/share/web-greeter/themes/` for theme directory, but Nix package `substituteInPlace` was searching for `greeterThemes/` — causing silent substitution failure and runtime path mismatch.
- **Decision**: Changed `substituteInPlace` calls in `configurePhase` to match the actual C source path `/usr/share/web-greeter/themes/`. Also changed the `installPhase` to install themes to `themes/` instead of `greeterThemes/`.
- **Consequences**: Themes now load correctly at runtime. The binary embeds correct Nix store paths.

## ADR-002: Patch sea-greeter NULL pointer crash on missing index.yml

- **Date**: 2026-05-05
- **Context**: When a theme lacks `index.yml`, sea-greeter's `load_theme_config()` calls `yaml_parser_set_input_file(&parser, NULL)` which triggers an assertion failure and crash. Some themes (like `lightdm-webkit2-sanatana`) don't have `index.yml`.
- **Decision**: Added `substituteInPlace` patch in `postPatch` to add `g_free(path_to_theme_config); return;` after the warning log when file is NULL.
- **Consequences**: sea-greeter gracefully skips theme config loading when `index.yml` is absent. Themes that don't need custom config work fine since sea-greeter defaults to `primary_html = "index.html"`.

## ADR-003: Flake input for lightdm-webkit2-sanatana (git+https)

- **Date**: 2026-05-05
- **Context**: The Sanatana-lightdm-webkit2 theme repository is brand-new and GitHub hasn't generated archive URLs yet, so `fetchFromGitHub` fails with 404.
- **Decision**: Added as a flake input with `url = "git+https://github.com/Sanatana-Linux/lightdm-webkit2-sanatana.git?ref=main"` and `flake = false`. Pass `inputs` to `pkgs/default.nix` so the package can receive `src` directly from the flake input.
- **Consequences**: The overlay (`overlays/default.nix`) and flake's `packages` output both pass `{pkgs, inputs}` to `pkgs/default.nix`. The `lightdm-webkit2-sanatana` package takes `src` as a parameter from the flake input rather than using `fetchFromGitHub` internally.

## ADR-004: Sea-greeter theme performance optimization (package-level)

- **Date**: 2026-05-05
- **Context**: The `lightdm-webkit2-sanatana` theme shipped 8.9MB of assets including the full Material Design Icons library (4.1MB) for only 4 used icons, a 962KB TTF font with no woff2 variant, an on-screen console logger, and a 60fps clock update loop. Loading was noticeably slow ("ungodly amount of time").
- **Decision**: Applied 4 optimizations in the Nix package derivation:
  1. **Stripped Material Icons** from 4.1MB→~340KB (kept woff2 only, replaced 7K+ CSS rules with 4-icon CSS)
  2. **Converted BlackHanSans-Regular** from TTF (962KB)→WOFF2 (187KB), updated `@font-face` in styles.css
  3. **Fixed clock loop** from `requestAnimationFrame` (60fps)→`setTimeout(updateTime, 1000)` (1fps)
  4. **Removed unused fonts**: BodoniModa.ttf (162KB) and Knewave-Regular.ttf (31KB) were never referenced
- **Consequences**: Total package size reduced from ~8.9MB to ~2.0MB (77% reduction). Significantly less CSS to parse (4 icon rules vs 7000+). Clock CPU usage dropped from ~60 layout/recalc/sec to ~1/sec. Font loads and decodes faster in woff2 format. All changes are in the packaging layer — upstream repo is untouched.

## ADR-005: Disable detect_theme_errors by default, wire debug option

- **Date**: 2026-05-05
- **Context**: The `debug` option in `modules.nixos.desktop.lightdm.debug` was declared but never wired through to the sea-greeter package — setting it to `true` had zero effect. Also, `detect_theme_errors: True` in the default sea-greeter config adds startup latency by scanning themes for errors.
- **Decision**: 
  1. Added `debug` and `detectThemeErrors` parameters to `pkgs/sea-greeter-configurable.nix` with `substituteInPlace` for both in `web-greeter.yml`
  2. Added `detectThemeErrors` option to `modules/nixos/desktop/lightdm.nix` (default: false)
  3. Wired both `debug` and `detectThemeErrors` from the module options to the `callPackage` invocation
  4. `detect_theme_errors` is set to `False` by default, skipping the startup scan
- **Consequences**: The `debug` option now actually enables debug mode. Theme error detection is disabled by default, reducing startup latency. Users can opt-in to error detection with `detectThemeErrors = true` if they encounter theme problems.

## ADR-007: Enable WebKit HW acceleration for sea-greeter

- **Date**: 2026-05-08
- **Context**: The sea-greeter (WebKitGTK-based LightDM greeter) had a ~1 minute delay between showing the background theme and rendering the login form. The sanatana theme uses heavy CSS `backdrop-filter` chains: `blur(8px) saturate(150%) contrast(140%) brightness(150%)` on the clock glass effect, plus `blur(9px) saturate(180%)` on the login container. The bagalamukhi host config did not enable hardware acceleration, causing the sea-greeter package to wrap the binary with `WEBKIT_DISABLE_DMABUF_RENDERER=1`, forcing CPU-only software rasterization.
- **Decision**: Added `enableHWAcceleration = true` to bagalamukhi's lightdm config. This removes the `WEBKIT_DISABLE_DMABUF_RENDERER=1` wrapper, allowing WebKitGTK to use the Intel integrated GPU for rendering via DMABUF. The Intel GPU on the Legion 5 Pro (i7-13700HX) has full DMABUF support — no NVIDIA Prime conflict since LightDM runs on the Intel GPU.
- **Consequences**: WebKitGTK now renders CSS backdrop-filters with GPU acceleration instead of CPU. The ~1 minute delay should drop to ~1-2 seconds. If graphical glitches occur (unlikely on Intel), the CSS filters can be simplified as a fallback: reduce the glass-effect filter chain to just `blur(8px)`, add `font-display: swap`, or remove the login container's backdrop-filter.

## ADR-006: Bump lenovo-legion kernel module to latest upstream

- **Date**: 2026-05-07
- **Context**: The nixpkgs version of `lenovo-legion-module` (0.0.20, July 2025) was missing N0CN DMI support for the Legion Pro 5 16IRX9 (bagalamukhi). The previous overlay approached this by sed-patching individual C structs (`model_n0cn` + DMI entry) into the source. However, the nixpkgs version also had a stale `ec_register_offsets_loq_v0` with wrong register values (0xC530 vs upstream's 0xcf02), meaning the sed-patch approach only partially fixed things — the LOQ EC registers were still wrong for any LOQ model user.
- **Decision**: Replaced the fragile sed-patching approach with a clean `src` override that fetches the latest upstream commit (`352cb4b3`, May 2026). This brings in:
  1. N0CN DMI entry (Legion Pro 5 16IRX9/83DF) mapped to `model_g8cn`
  2. NRCN DMI entry (Legion Slim 5 16AHP9/83DH) with new `model_nrcn`
  3. R3CN DMI entry (LOQ 15IRX10) with new `model_r3cn`
  4. Fixed `ec_register_offsets_loq_v0` with correct LOQ EC register values
  5. New `ec_register_offsets_loq_v1` variant
  6. `has_extreme_powermode` support for NRCN and R3CN models
- **Consequences**: The lenovo-legion kernel module now tracks upstream main directly. All new model support comes for free. The fragile sed patches are eliminated entirely. The version string updates from `0.0.20-unstable-2025-07-11` to `unstable-2026-05-07`. Since this is a kernel module, a reboot is required to load the new version.

## ADR-008: Purge Zathura, fix Firefox MIME handling

- **Date**: 2026-06-11
- **Context**: Zathura (PDF viewer) was installed on all user profiles (tlh, user) and enabled in Stylix theming targets. Despite being a PDF viewer, it was registering itself as a handler for zip/archive MIME types — causing Firefox to try opening `.zip` downloads with Zathura instead of file-roller. Firefox's built-in PDF viewer (`pdfjs`) was also intercepting PDF downloads instead of delegating to the system handler (foliate).
- **Decision**:
  1. **Removed Zathura entirely**: Disabled `zathura.enable` in `home/tlh/default.nix` and `home/user/default.nix`, removed `targets.zathura.enable` from Stylix config, removed `./zathura.nix` from the programs import list, deleted the module file.
  2. **Forced Firefox to use system MIME handlers**: Added `widget.use-xdg-desktop-portal.mime-handler = true` to use the portal for MIME dispatch, `browser.download.forbid_open_with = false` to allow external handlers, `browser.download.open_pdf_attachments_inline = false` and `pdfjs.enabled = false` to disable built-in PDF viewer, and `browser.download.viewableInternally.enabledFor = ""` to prevent Firefox from claiming any MIME type as viewable internally.
- **Consequences**: Zathura is completely gone from all profiles. Firefox now delegates all file downloads to the system XDG MIME handler (file-roller for archives, foliate for PDFs, etc.). The XDG MIME associations in `modules/home-manager/environment/xdg.nix` already correctly mapped archives to `file-roller.desktop` and PDFs to `foliate.desktop` — the issue was Firefox overriding these with its own internal handlers.

## ADR-009: Provision Nix ecosystem artifacts for subagent orchestration

- **Date**: 2026-06-11
- **Context**: The ShizNix repo has `.opencode/` configured with durable context but no project-specific agents, skills, tools, or rules. When orchestrating subagents (`@executor`, `@planner`, `@architect`, etc.) via Hubs, the subagents have no awareness of ShizNix-specific conventions — the enable-by-option module pattern, 4-host topology, Nix flake input structure, or common failure modes. This forces subagents to re-derive project context from scratch each session.
- **Decision**: Created 16 provisioned artifacts in `.opencode/`:
  1. **5 agent wrappers** (`agents/`) — executor, planner, architect, debugger, code-reviewer — each `extends` the global agent and injects ShizNix-specific project context (host matrix, module pattern, build commands, common errors) so subagents are immediately productive.
  2. **6 skills** (`skills/`) — nix-build (build/switch/test), nix-module (enable-by-option pattern), nix-flake (input mgmt), nix-test (VM testing), nix-host (per-host mgmt), nix-secrets (sops-nix).
  3. **2 TypeScript tools** (`tools/`) — `nix-build` (orchestrate build/switch/test across hosts), `nix-info` (project metadata lookup).
  4. **3 rules** (`rules/`) — 00-nix-conventions (Nix idioms), 01-architecture (config layering diagram), nix-flake-strategy (build/debug commands).
- **Consequences**: Subagents now have deep project context on invocation. Skills provide repeatable workflows without asking. Tools give programmatic access to project metadata. The Hubs orchestrator can delegate NixOS tasks with confidence that subagents understand ShizNix conventions. All artifacts registered in `opencode.jsonc` so they load automatically.

## ADR-010: REVERTED — Provisioned artifacts broke OpenCode (invalid config keys)

- **Date**: 2026-06-12
- **Context**: The provisioned artifacts (ADR-009) registered invalid config keys (`"agents"`, `"skills"`, `"tools"`, `"project"`, `"rules"."paths"`) in `.opencode/opencode.jsonc` that do not exist in the OpenCode schema. Additionally, TypeScript tool files required `@opencode-ai/plugin` npm dependencies (58MB of `node_modules/`) with a version mismatch vs the installed opencode binary (plugin 1.14.25 vs opencode 1.15.13). The embedded bun runtime inside opencode's nixpkgs binary likely segfaulted on the unknown config keys.
- **Decision**: **REVERTED**. All 16 provisioned artifacts deleted. `opencode.jsonc` restored to a minimal valid config with only known keys: `$schema`, `default_agent`, `permission`, `instructions`. `node_modules/`, `package.json`, `package-lock.json` removed. ADR-009 consequences invalidated.
- **Root cause of failure**: Reckless provisioning without validating config schema. OpenCode's nixpkgs build embeds a bun runtime that is sensitive to unknown config keys.
- **Lesson learned**: Never create config keys that haven't been validated against the real OpenCode schema. The valid config keys are: `$schema`, `model`, `default_agent`, `provider`, `permission`, `instructions`, `mcp`, `plugin`. Everything else will break opencode's embedded bun runtime.

## ADR-004: Fan curve PWM values and accel/decel range fix

- **Date**: 2026-06-14
- **Context**: The `fan-control.nix` module was writing raw RPM values (1800-6000) to `pwm*_auto_point*_pwm` sysfs files, but the kernel module expects PWM 0-255. The kernel's `fancurve_set_speed_pwm()` function for `FAN_SPEED_UNIT_RPM_HUNDRED` converts the PWM value to RPM/100 internally via `clamp_t(u8, (value * MAX_RPM + (100 * 255) - 1) / (100 * 255), 0, 255)`. Additionally, `accel` and `decel` values of 1 were being written, but the kernel rejects values < 2 (valid range is 2-5).
- **Decision**: Converted all fan curve values from RPM to PWM 0-255. Changed accel/decel from 1-5 to 2-5 range. Added an "extreme" profile with aggressive ramp (fans at 100% PWM by 80°C).
- **Consequences**: Fan curves now actually write to the EC. The daemon's `apply_curve` function will no longer silently fail with `EOPNOTSUPP` from the kernel.

## ADR-005: Legion cooling module for EC thermal/power modes

- **Date**: 2026-06-14
- **Context**: The `lenovo-legion-module` exposes `thermalmode` (0-4) and `powermode` (0-4) sysfs controls, but these were not being set at boot. The system was running at thermalmode=3 (extreme) and powermode=3 (turbo) instead of 4 (full speed / custom).
- **Decision**: Created `modules/nixos/performance/cooling.nix` — a oneshot systemd service that sets thermalmode=4, powermode=4, and platform-profile=performance at boot. Optionally supports `fanFullSpeed=true` for immediate max fans.
- **Consequences**: Maximum EC cooling is now applied at boot. The system will run cooler under load.

## ADR-006: Fix lenovo-legion GUI — hardcoded PNP0C09:00 driver path

- **Date**: 2026-06-14
- **Context**: The `legion_gui` / `legion_cli` from nixpkgs (`lenovo-legion-app-0.0.20`) hardcodes `LEGION_SYS_BASEPATH = '/sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00'`, but on kernel 7.x (xanmod), the driver registers as `/sys/module/legion_laptop/drivers/platform:legion/legion`. Every feature search returned `path: None` with warnings like "Feature does not exist", making the GUI completely unable to read or write any Legion-specific sysfs attributes.
- **Decision**: Added a `substituteInPlace` patch in the overlay to replace the hardcoded path.
- **Consequences**: The GUI now finds all Legion sysfs attributes correctly. No need to bump the entire package to a newer upstream rev — the single path fix resolves all feature discovery failures.

## ADR-007: Bagalamukhi default fan profile set to "extreme" on AC

- **Date**: 2026-06-14
- **Context**: The bagalamukhi host was using "performance" as the AC fan profile, but the performance curve was too conservative (max 153 PWM / ~60% fan speed at 86°C). The new "extreme" profile ramps to 100% PWM by 80°C.
- **Decision**: Changed `onAc` from "performance" to "extreme" for bagalamukhi.
- **Consequences**: Fans will run faster under load, keeping the laptop cooler. Slightly more noise but significantly better thermal performance.

## ADR-008: BIOS update N0CN31WW→N0CN35WW via fwupdtool install-blob

- **Date**: 2026-06-30
- **Context**: The Legion 5 Pro 16IRX9 (bagalamukhi) was running BIOS N0CN31WW. The VRM/IC region was running excessively hot under load. The BIOS update image `WinN0CN35WW.fd` (27MB) was extracted from the Lenovo-supplied `n0cn35ww.exe` Windows flasher. The UEFI shell method failed (EFI shell couldn't recognize the filesystem), so the update was applied via `fwupdtool install-blob` which stages a UEFI capsule update and flashes on reboot.
- **Decision**: Updated BIOS from N0CN31WW to N0CN35WW using:
  ```
  sudo fwupdtool install-blob ~/Downloads/BIOS/WinN0CN35WW.fd 97a155291f41b383be1520ac4355012ecb875e3f
  ```
  Also disabled "always charge" and "charge in low power states" in the BIOS settings.
- **Consequences**: VRM region heat is noticeably mitigated after the update. The BIOS charge settings changes may also contribute to reduced thermal load. The `cooling.nix` and `fan-control.nix` modules were removed from the NixOS config — they were making things worse by writing to the EC too frequently, causing the system to heat up further with no positive effect. The `legion-default-profile` service was added to force `platform_profile` to "balanced" at boot (overriding the BIOS/EC-persisted Fn+Q state), and `TLP_DEFAULT_MODE` was changed from `"BAT"` to `"AC"` so TLP starts in balanced mode by default.
- **Note**: The BIOS update locked out the advanced BIOS menu (previously accessible via a key combo or modded BIOS). This is not a concern — the advanced BIOS only provided firmware-level thermal/power controls that are now handled entirely through NixOS (TLP, CPU_MAX_PERF_ON_AC=80, platform_profile forcing, kernel params). Since the system runs NixOS exclusively, all the functionality that was in the advanced BIOS is replicated and more flexibly managed through the NixOS config.
