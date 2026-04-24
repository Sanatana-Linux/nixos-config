<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/nixos/performance/

## Purpose
System performance tuning — CPU scheduler, memory management, OOM handling, and undervolting for thermal/performance balance.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports performance submodules |
| `cachy.nix` | CachyOS BORE scheduler kernel patch for better desktop responsiveness |
| `oomd.nix` | Out-of-memory daemon configuration |
| `undervolt.nix` | Intel CPU undervolting (via kernel patch in hardware/intel.nix) |
| `zram.nix` | ZRAM compressed swap for memory efficiency |

## For AI Agents

### Working In This Directory
- Cachy scheduler and undervolt apply kernel patches — changes require `nixos-rebuild switch` and reboot
- ZRAM config affects swap behavior; test with `zramctl` after rebuild
- OOMD replaces traditional OOM killer for better desktop responsiveness under memory pressure

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->