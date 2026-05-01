<!-- Parent: ../../system/AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# plymouth/

## Purpose
Custom Plymouth boot splash theme ("Sanatana Linux") built as a Nix derivation inline. Displays a centered logo image with an animated progress bar on a dark background. Disables Stylix Plymouth theming to avoid conflicts.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Plymouth module — `modules.system.plymouth.enable` option, `disableStylelix` toggle, custom theme derivation, and boot.plymouth config |

## For AI Agents

### Working In This Directory
- The entire Plymouth theme (script, .plymouth config, logo) is generated inline in `default.nix` via `stdenv.mkDerivation` — no separate theme files need managing
- Logo image (`sanatana-linux-icon.png`) must exist in this directory as a source file
- The theme script uses Plymouth's script plugin with programmatic progress bar and password/message display
- `disableStylelix` defaults to true — enabling this module forces `stylix.targets.plymouth.enable = false` via `mkForce`
- Progress bar colors (0.42, 0.61, 0.91 = blue-ish) and background (0.07 dark gray) are hardcoded in the script
- After changes, rebuild is required — Plymouth themes are loaded at boot time, not at runtime

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->