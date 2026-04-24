<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-22 | Updated: 2026-04-22 -->

# power/

## Purpose
Power management modules for laptop systems. Configures TLP or power-profiles-daemon (mutually exclusive), thermald, acpid, upower, and powertop. Exposes options for CPU boost thresholds, battery charge thresholds, and scaling governors.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports `laptop.nix` via imports |
| `laptop.nix` | Full laptop power management: TLP vs power-profiles-daemon toggle, CPU boost/governor settings, battery charge thresholds, upower critical action config |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| *(none)* | — |

## For AI Agents

### Working In This Directory
- TLP and power-profiles-daemon are **mutually exclusive** — `powerProfilesDaemon` option toggles between them
- `START_CHARGE_THRESH_BAT0` / `STOP_CHARGE_THRESH_BAT0` control battery health (defaults: 40%/80%)
- `upower` is configured to hibernate at 4% battery with percentage-based policy
- Only enable `modules.power.laptop.enable = true` on hosts that are laptops (bagalamukhi, matangi)

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->