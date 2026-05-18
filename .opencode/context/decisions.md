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

## ADR-008: Suppress ACPI _OSI errors on Lenovo Legion boot

- **Date**: 2026-05-18
- **Context**: Without Plymouth (or when Plymouth isn't available/hidden), the Lenovo Legion laptops showed noisy ACPI errors during boot: `AE_NOT_FOUND`, `AE_AML`, etc. These occur because the Lenovo UEFI firmware contains Windows-specific ACPI methods (DSDT tables) that Linux doesn't implement. The kernel's ACPI driver, by default, responds to Windows `_OSI` queries, causing the firmware to attempt Windows methods that fail.
- **Decision**: In `modules/nixos/hardware/lenovo.nix`, changed `boot.kernelParams` from `["acpi_osi=Linux"]` to `["acpi_osi=Linux", "acpi_osi="]`. The key is `acpi_osi=` (empty string), which tells the kernel to strip its built-in `_OSI` strings. This prevents the kernel from claiming Windows compatibility, which stops the firmware from attempting Windows-specific methods that don't exist on Linux.
- **Consequences**: All hosts using the lenovo module (bagalamukhi, matangi) will have cleaner boot logs. The empty `acpi_osi=` doesn't disable ACPI entirely — it only stops the kernel from pretending to be Windows. ACPI power management, thermal control, platform profiles, and all other ACPI features continue to work normally since `acpi_osi=Linux` is still set, telling the firmware we're Linux.

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
