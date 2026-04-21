# Package Search & Install

Core concept: NixOS uses declarative package management. Imperative installs are temporary; permanent packages go in configuration files.

Key Points:
- `om search "<query>"` — search nixpkgs via CLI wrapper around nix-search-cli
- [search.nixos.org/packages](https://search.nixos.org/packages) — web search (set Channel to unstable)
- `nix-shell -p <pkg>` — temporary session-only install
- `nix-env -iA nixos.<pkg>` — imperative install (survives until garbage collection)
- Permanent installs go in `modules/nixos/packages/` or `home/` configs
- NUR (nur.nix-community.org) for community packages

Example:
```bash
om search "firefox"
nix-shell -p nodejs_22
```

Reference: [.documentation/searching-and-installing-packages.md](../../.documentation/searching-and-installing-packages.md)