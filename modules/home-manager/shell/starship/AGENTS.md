<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# starship/

## Purpose
Starship prompt configuration as a home-manager module. Defines a minimal two-line prompt with git integration, custom Om symbol for prompt characters, and condensed language symbols for programming language detection.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Starship module — `modules.shell.starship.enable` option with zsh integration toggle and full prompt settings |

## For AI Agents

### Working In This Directory
- Prompt config is defined inline in `programs.starship.settings` — no external config files
- Language symbols use abbreviated text (e.g., `go`, `rs`, `py`) instead of Nerd Font icons for a cleaner look
- `enableZshIntegration` defaults to true but can be disabled via option
- `STARSHIP_CACHE` is set to XDG cache directory
- Two-line prompt: top line shows status info (directory, git, etc.), bottom line shows the 🕉 prompt character for input
- `$line_break` is included in the format string to separate status from input
- Git metrics (added/deleted lines) are enabled — keep disabled = false

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->