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
