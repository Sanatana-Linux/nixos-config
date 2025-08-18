# AGENTS.md - NixOS Configuration Codebase

## Build, Lint, and Test Commands
- **Build system config:** `sudo nixos-rebuild switch --flake .#<host>` (replace `<host>` with bagalamukhi, matangi, chhinamasta)
- **Test config (no switch):** `sudo nixos-rebuild test --flake .#<host>`
- **Run a single test:** Use `nixos-rebuild test --flake .#<host>` after editing relevant files; for module/unit tests, see documentation/debugging/
- **Enter dev shell:** `nix develop` (uses shell.nix)
- **Format code:** `nix fmt` (Alejandra, see flake.nix)
- **Build ISO:** `nix build .#nixosConfigurations.<host>.config.system.build.isoImage`

## Code Style Guidelines
- **Formatting:** Always run `nix fmt` before committing.
- **Imports:** Inputs first, then local modules; see hosts/shared/default.nix:8-16.
- **Attribute sets:** Multi-line, trailing semicolons.
- **Naming:** kebab-case for files/dirs, camelCase for Nix attrs.
- **Function signatures:** Multi-line, named params in curly braces.
- **Comments:** Use `#` for lines; prefer descriptive attribute names over comments.
- **Types:** Use explicit types for Nix options and module arguments.
- **Error handling:** Use `lib.mkIf` for conditionals; pass inputs via `specialArgs`.
- **Testing:** Always run `nixos-rebuild test` before switching; check debugging/ for more.

## Architecture
- Hosts: `hosts/` (machine configs)
- Modules: `hosts/shared/`, `modules/` (reusable)
- Home Manager: `home/` (user configs)
- Overlays: `overlays/` (package mods)
- Templates: `templates/` (dev envs)
