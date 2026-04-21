# Nix Naming Conventions

## Module Naming

- Module directories: `kebab-case` (e.g., `nix-ld`, `virt-manager`)
- Module option paths: `modules.<category>.<name>` matching directory name
- Enable options: `mkEnableOption "Description"`

## Variable Naming

- Config variable: `cfg = config.modules.<category>.<name>;`
- Helper functions: `ifTheyExist` for conditional group lists
- Package sets: descriptive names (e.g., `essential`, `cli-tools`)

## File Naming

- Module files: `lowercase.nix` matching the option name
- Default re-exports: `default.nix` with `imports` list
- Host configs: `default.nix` + `hardware-configuration.nix`
- Custom packages: `<package-name>.nix` in `pkgs/`

## Attribute Paths

- NixOS options: `modules.<category>.<name>.<suboption>`
- Home-manager: `home-manager.users.<username>.<option>`
- Overlays: `outputs.overlays.<name>`