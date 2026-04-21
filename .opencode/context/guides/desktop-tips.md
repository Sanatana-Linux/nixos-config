# NixOS Desktop Tips & Tricks

Core concept: Practical patterns for NixOS desktop management — channel selection, rollback strategy, package search, patching nixpkgs, and running foreign binaries. Distilled from community experience.

Key Points:
- **Use unstable channel** — "unstable" is a misnomer; it's a rolling release gated by tests. NixOS's generation system mitigates rolling-release risks. For single-user desktops, unstable gives current app versions without overlay complexity
- **Boot into working config, don't rollback** — Instead of `nixos-rebuild --rollback switch` from a broken system, boot into the desired generation from the bootloader and run `/run/current-system/bin/switch-to-configuration boot` to make it default
- **Prefer options over packages** — Larger tools (docker, emacs) have both a `package` and an `option`. The option enables systemd integration and system-level config. Always search options first
- **Avoid `nix-env` / `nix profile install`** — Imperative installs make state less reproducible. Use `nix shell nixpkgs#pkg` for one-offs; declare everything else in configuration
- **Cherry-pick unmerged PRs** — Use `pkgs.applyPatches` with `fetchpatch` to apply pending nixpkgs PRs. When the PR merges and reaches your channel, the patch fails to apply — signaling you to remove it
- **Data doesn't rollback** — Switching generations doesn't revert application data (e.g., database schemas). Back up data that may change between versions (Telegram, Signal, etc.)

Example:
```nix
# Cherry-pick an unmerged nixpkgs PR
let
  originPkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
  nixpkgs = originPkgs.applyPatches {
    name = "nixpkgs-patched";
    src = inputs.nixpkgs;
    patches = map originPkgs.fetchpatch [
      {
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/292148.diff";
        sha256 = "sha256-...";
      }
    ];
  };
  nixosSystem = import (nixpkgs + "/nixos/lib/eval-config.nix");
in { ... }
```

Reference: [discourse.nixos.org/t/tips-tricks-for-nixos-desktop/28488](https://discourse.nixos.org/t/tips-tricks-for-nixos-desktop/28488)