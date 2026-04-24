<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-22 | Updated: 2026-04-22 -->

# desktop/

## Purpose
Home-manager desktop environment modules. Configures AwesomeWM symlink to the external git submodule, GTK theme/cursor/icon settings with forced overrides (Materia-dark-compact + Colloid-dark), Qt integration, and X11 resources with Monokai Pro Spectrum colors. The top-level `modules.desktop.enable` auto-enables GTK by default.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Aggregates awesome, gtk, and x11 sub-modules; auto-enables `modules.desktop.gtk` via `mkDefault` |
| `awesome.nix` | Symlinks `~/.config/awesome` to `/etc/nixos/external/awesome` via home-manager activation |
| `gtk.nix` | GTK2/3/4 theme config, cursor theme (phinger-cursors-light), Qt integration, dconf settings — uses `mkForce` to override Stylix |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `x11/` | X11 resources and theme configuration (see `x11/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- `gtk.nix` intentionally uses `mkForce` to **override Stylix** for theme/cursor/icon — this is by design, not a bug
- `awesome.nix` uses `home.activation` with `hm.dag.entryAfter` to create a symlink after writeBoundary — it removes existing dirs/symlinks first
- The `x11/` subdirectory has two modules: `xresources` (raw X resource config) and `shell.x` (structured X properties) — both set Monokai Pro colors
- Adding a new desktop module: create `<name>.nix` with `options.modules.desktop.<name>.enable`, add to `default.nix` imports

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->