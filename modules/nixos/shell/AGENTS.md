<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-22 | Updated: 2026-04-22 -->

# shell/

## Purpose
System shell environment configuration. Provides ZSH setup (completions, autosuggestions, syntax highlighting) and system environment variables (browser, Java AWT, OpenGL, ZSH async). The `defaultShell` option auto-selects bash or zsh based on the `zsh` boolean.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Shell enable option, ZSH config (completions, autosuggestions, syntax highlighting), and default shell selection |
| `variables.nix` | System environment variables: `BROWSER`, OpenGL/Java/ZSH optimizations, and `extraVariables` for custom env vars |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| *(none)* | — |

## For AI Agents

### Working In This Directory
- `default.nix` uses `mkIf cfg.zsh` to gate all ZSH-specific configuration
- `variables.nix` uses `optionalAttrs` to conditionally set env vars based on optimization toggles
- The `extraVariables` option (`attrsOf str`) allows hosts to inject arbitrary environment variables
- Note: `environment/` directory handles shell and pathsToLink at a lower level; this module handles ZSH program config and env vars

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->