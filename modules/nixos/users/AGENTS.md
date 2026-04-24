<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/nixos/users/

## Purpose
User account modules. Each file creates a system user and imports their home-manager configuration. **Critical**: these must only be imported on hosts that use them — never import all user modules via a shared `default.nix`.

## Key Files

| File | Description |
|------|-------------|
| `tlh.nix` | Primary user (tlh) — imports `home/tlh/default.nix` |
| `smg.nix` | Secondary user (smg) — imports `home/smg/default.nix` |
| `user.nix` | Generic user (user) — imports `home/user/default.nix`, for live ISO |

## For AI Agents

### Working In This Directory
- **Never** create a `default.nix` here that imports all users — this was the root cause of the home-manager stateVersion bug
- Each user module is imported directly by host configs (e.g., `../../modules/nixos/users/tlh.nix`)
- User modules set `home-manager.users.<name> = import cfg.homeManagerConfig` inside their `mkIf` block
- The `homeManagerConfig` option defaults to the correct `home/<name>/default.nix` path

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->