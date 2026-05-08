# Changelog

## 2026-05-05

### Fixes
- **DM crash**: Sea-greeter display manager no longer crashes on boot. Root cause was a path mismatch in the Nix build — `substituteInPlace` searched for `greeterThemes/` but the C source hardcodes `themes/`. Also patched a NULL-file assertion in `load_theme_config()` that crashed when themes lack `index.yml`.
- **Theme migration**: Switched bagalamukhi from the old litarvan WebKit theme to the new Sanatana glassmorphism theme (`lightdm-webkit2-sanatana`).

### Added
- New package: `pkgs/lightdm-webkit2-sanatana` — Sanatana glassmorphism sea-greeter theme
- New flake input: `inputs.lightdm-webkit2-sanatana` (git+https, non-flake)
- Context docs: sea-greeter architecture reference and ADRs

### Changed
- `pkgs/default.nix` — now accepts `{pkgs, inputs}` (was `pkgs:`)
- `overlays/default.nix` — passes `inputs` to `pkgs/default.nix`
- `pkgs/sea-greeter-configurable.nix` — fixed theme path substitution and NULL crash
- `hosts/bagalamukhi/default.nix` — uses `lightdm-webkit2-sanatana` theme

Commit: `9fb3248`

## 2026-05-05 (Perf Fix)

### Performance
- **Theme asset optimization**: `pkgs/lightdm-webkit2-sanatana` reduced from ~8.9MB to ~2.0MB (77%). Stripped full Material Design Icons (4.1MB → 340KB, only woff2 + 4 icon CSS rules), converted BlackHanSans TTF→WOFF2 (962KB→187KB), removed unused fonts (BodoniModa.ttf, Knewave-Regular.ttf). Clock loop changed from requestAnimationFrame (60fps) to setTimeout (1fps).
- **Startup latency**: `detect_theme_errors` now defaults to `False`, skipping sea-greeter's theme error scan on boot. Controlled by new `detectThemeErrors` module option.
- **Debug wiring fixed**: `modules.desktop.lightdm.debug` option was declared but never wired to the sea-greeter package. It now correctly enables `debug_mode: True` in `web-greeter.yml`.

### Changed
- `pkgs/lightdm-webkit2-sanatana.nix` — added `woff2` build input, comprehensive asset optimization in `installPhase`
- `pkgs/sea-greeter-configurable.nix` — added `debug` and `detectThemeErrors` function params with `substituteInPlace` for `web-greeter.yml`
- `modules/nixos/desktop/lightdm.nix` — added `detectThemeErrors` option, wired `debug` and `detectThemeErrors` to `callPackage`

### Added
- ADR-004: Sea-greeter theme performance optimization (package-level)
- ADR-005: Disable detect_theme_errors by default, wire debug option

## 2026-05-07

### Changed
- **lenovo-legion kernel module**: Replaced fragile sed-patching of C structs with a clean `src` override bumping to latest upstream main (commit `352cb4b3`, May 2026). This fixes N0CN (Legion Pro 5 16IRX9/83DF) support using `model_g8cn` (same fields as our old `model_n0cn`), plus adds NRCN, R3CN DMI entries and fixes `ec_register_offsets_loq_v0` register values.

### Removed
- `overlays/default.nix` — removed the sed-based `model_n0cn` struct patch and DMI allowlist entry injection. Entirely replaced by `src` override of the full upstream source.

### Added
- ADR-006: Bump lenovo-legion kernel module to latest upstream
