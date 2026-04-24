<!-- Parent: ../.opencode/AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/

## Purpose
Shared NixOS and home-manager modules using the **enable-by-option** pattern. Every module declares an `options.modules.<category>.<name>.enable` option and guards its config with `mkIf cfg.enable`. Hosts opt-in by setting `modules.<category>.<name>.enable = true`.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `nixos/` | NixOS system modules (hardware, desktop, security, etc.) |
| `home-manager/` | Home-manager user modules (programs, shell, desktop, etc.) |

## For AI Agents

### Working In This Directory
- **Never** import user modules via a shared `default.nix` — each host imports only the users it needs
- Each module directory has a `default.nix` that re-exports all sibling `.nix` files via `imports`
- Module option paths follow `modules.<category>.<name>` matching directory structure
- Config variable: `cfg = config.modules.<category>.<name>;`
- Use `mkEnableOption` for enable flags, `mkOption` with types for config values

### Common Patterns
- Enable-by-option: `options.modules.X.Y.enable = mkEnableOption; config = mkIf cfg.enable { ... };`
- Conditional package lists: `packages = optionals cfg.<sub>.enable [ pkg1 pkg2 ];`
- `ifTheyExist` helper for conditional group membership

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->