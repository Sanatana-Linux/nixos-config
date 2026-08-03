# No Auto-Rebuild Rule

> 🚨 CRITICAL: Never run `nixos-rebuild` or trigger system builds unless explicitly and specifically instructed to do so by the user.

## Rules
1. **Manual-Only Rebuilds**: AI agents are strictly forbidden from executing `nixos-rebuild`, `nixos-rebuild switch`, `nixos-rebuild test`, or `nixos-rebuild boot` proactively.
2. **User Intent Required**: System rebuilding is an invasive, time-consuming operation. Only the user has the authority to trigger a system rebuild.
3. **Configuration Only**: Agents should only write/edit Nix configuration files, modules, and options when requested, leaving evaluation and building entirely to the user.
