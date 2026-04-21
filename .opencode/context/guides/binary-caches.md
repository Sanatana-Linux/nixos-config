# Binary Cache Servers

Core concept: Add cache servers via `nix.settings.substituters` and `nix.settings.trusted-public-keys` to speed up builds. Use `extra-` prefix to merge with system-level config instead of overriding it.

Key Points:
- `substituters` — ordered list of cache URLs; `trusted-public-keys` — corresponding signing keys
- Nix requires signatures from `trusted-public-keys` (unless `require-sigs = false`)
- Set `nix.settings.trusted-users = ["tlh"]` to allow per-flake `nixConfig.substituters`
- `extra-substituters` appends to system config (doesn't override)
- 3 config levels: system (`nix.settings`), flake (`nixConfig`), CLI (`--option`)
- Later configs override earlier; use `extra-` prefix to merge instead
- Proxy for nix-daemon: create systemd override with `Environment="https_proxy=..."`
- Common caches: `cache.nixos.org`, `nix-community.cachix.org`, NVIDIA CUDA cache

Example:
```nix
nix.settings = {
  trusted-users = ["tlh"];
  substituters = [ "https://cache.nixos.org" ];
  extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
};
```

Reference: [nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers](https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers)