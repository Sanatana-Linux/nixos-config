# Overlays & Overriding

Core concept: Overlays globally modify packages in `pkgs` (unlike `.override` which creates a new derivation). Overriding customizes individual package build parameters. Both are key for package customization in NixOS.

Key Points:
- `pkgs.foo.override { param = value; }` — creates new derivation with overridden parameters
- `pkgs.foo.overrideAttrs (final: prev: { doCheck = false; })` — override derivation attributes
- Overlays: `nixpkgs.overlays = [(final: prev: { ... })]` — globally modify `pkgs`
- Overlay format: `final: prev: { steam = prev.steam.override { ... }; }`
- Flakes require overlays in config (no `~/.config/nixpkgs/overlays/`)
- Global overlays may invalidate caches → use separate nixpkgs instances for scoped overlays
- `pkgs.callPackage` auto-injects dependencies from `pkgs`; explicit args in second param override

Example:
```nix
# Override
pkgs.fcitx5-rime.override { rimeDataPkgs = [ ./custom-rime ]; }
# Overlay
nixpkgs.overlays = [(final: prev: {
  google-chrome = prev.google-chrome.override {
    commandLineArgs = "--proxy-server='https=127.0.0.1:3128'";
  };
})];
```

Reference: [nixos-and-flakes.thiscute.world/nixpkgs/overlays](https://nixos-and-flakes.thiscute.world/nixpkgs/overlays), [overriding](https://nixos-and-flakes.thiscute.world/nixpkgs/overriding)