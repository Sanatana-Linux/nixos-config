<!-- Parent: ../.opencode/AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# home/

## Purpose
Per-user home-manager configurations. Each user gets a `default.nix` imported by their respective NixOS user module (`modules/nixos/users/<name>.nix`). These files set `home.homeDirectory`, `home.username`, `home.stateVersion`, and import shared home-manager modules.

## Key Files

| File | Description |
|------|-------------|
| `tlh/default.nix` | tlh's home-manager config (primary user) |
| `smg/default.nix` | smg's home-manager config |
| `user/default.nix` | Generic user home-manager config (for live ISO) |

## For AI Agents

### Working In This Directory
- `home.stateVersion` is **required** in every user's config — omission causes evaluation errors
- User configs are imported via `home-manager.users.<name> = import cfg.homeManagerConfig` in the corresponding `modules/nixos/users/<name>.nix`
- Only import shared home-manager modules that the user actually needs
- Never reference a user's home-manager config from a host where that user is not imported

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->