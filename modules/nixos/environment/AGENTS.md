<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-22 | Updated: 2026-04-22 -->

# environment/

## Purpose
System-wide environment configuration. Sets the default user shell to ZSH, enables ZSH as a system program, and configures `pathsToLink` for bash, zsh, applications, and XDG desktop portal data. Unlike most modules in this repo, this module does **not** use the enable-by-option pattern — it is always active when imported.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Sets `programs.zsh.enable`, `environment.shells`, `environment.pathsToLink`, `users.defaultUserShell` |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| *(none)* | — |

## For AI Agents

### Working In This Directory
- This module has no `options` block — it is unconditional when imported
- Do not add an enable option here unless explicitly requested; it serves as base env setup
- `pathsToLink` entries are required for shell completions and XDG integration to work correctly

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->