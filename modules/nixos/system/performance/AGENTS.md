<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-06-09 -->

# modules/nixos/system/performance/

## Purpose
System performance tuning — CPU scheduler, memory management, OOM handling, and undervolting for thermal/performance balance.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports performance submodules |
| `cachy.nix` | CachyOS BORE scheduler kernel patch for better desktop responsiveness |
| `oomd.nix` | Out-of-memory daemon configuration |
| `undervolt.nix` | Intel CPU undervolting with P-State power limits (65W PL1 / 100W PL2 for laptop thermals) |
| `zram.nix` | ZRAM compressed swap for memory efficiency |

## For AI Agents

### Working In This Directory
- Cachy scheduler and undervolt apply kernel patches — changes require `nixos-rebuild switch` and reboot
- ZRAM config affects swap behavior; test with `zramctl` after rebuild
- OOMD replaces traditional OOM killer for better desktop responsiveness under memory pressure

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->