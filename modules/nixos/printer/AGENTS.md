<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-22 | Updated: 2026-04-22 -->

# printer/

## Purpose
Printer driver modules. Currently provides Brother laser printer support via CUPS with the `brlaser` driver, Avahi network discovery, and user group membership for printing/scanning.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports `brother.nix` via imports |
| `brother.nix` | Brother laser printer: CUPS setup, configurable driver list, Avahi mDNS discovery, user group assignment (lp, scanner) |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| *(none)* | — |

## For AI Agents

### Working In This Directory
- `drivers` option defaults to `[pkgs.brlaser]` but accepts any list of CUPS driver packages
- `enableAvahi` opens the firewall for mDNS printer discovery — set to `false` if the printer is USB-only
- The `user` option defaults to `"smg"` (Sara's host matangi) — override for other users
- Adding a new printer brand: create `<brand>.nix` with `options.modules.printer.<brand>.enable`, add to `default.nix` imports

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->