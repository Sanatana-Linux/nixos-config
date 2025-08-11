# AGENTS.md - NixOS Configuration Codebase

## Build/Deploy Commands
- **Build system configuration**: `sudo nixos-rebuild switch --flake .#bagalamukhi` (or `matangi`, `chhinamasta`)
- **Test configuration without switching**: `sudo nixos-rebuild test --flake .#bagalamukhi`
- **Build and enter shell**: `nix develop` (uses shell.nix with development tools)
- **Format code**: `nix fmt` (uses alejandra formatter from flake.nix:60)
- **Build ISO image**: `nix build .#nixosConfigurations.chhinamasta.config.system.build.isoImage`

## Code Style Guidelines
- **Formatting**: Use Alejandra formatter (configured in flake.nix)
- **Imports**: Group by type - inputs first, then local modules (see hosts/shared/default.nix:8-16)
- **Attribute sets**: Use multi-line format with trailing semicolons
- **Naming**: Use kebab-case for files/directories, camelCase for Nix attributes
- **Function signatures**: Multi-line with named parameters in curly braces
- **Comments**: Use `#` for line comments, prefer descriptive attribute names over comments

## Architecture
- **Hosts**: Machine-specific configs in `hosts/` (bagalamukhi, matangi, chhinamasta)
- **Modules**: Reusable components in `hosts/shared/` and `modules/`
- **Home Manager**: User configs in `home/` directory
- **Overlays**: Package modifications in `overlays/`
- **Templates**: Development environments in `templates/`

## Error Handling
- Use `lib.mkIf` for conditional configurations
- Leverage `specialArgs` for passing inputs to modules
- Test configurations with `nixos-rebuild test` before switching