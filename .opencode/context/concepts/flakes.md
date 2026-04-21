# Flakes Introduction

Core concept: Flakes introduce `flake.nix` (dependency declaration, like `package.json`) and `flake.lock` (version locking, like `package-lock.json`) to Nix, improving reproducibility, composability, and usability. Still experimental but widely adopted (>50% of NixOS users).

Key Points:
- `flake.nix` defines inputs (dependencies) and outputs (build results)
- `flake.lock` pins dependency versions for reproducibility
- Flakes don't break Nix's original design — they're a wrapper
- Still experimental; breaking changes possible during stabilization
- New CLI (`nix-command`) is tightly coupled with Flakes feature

Old CLI → New CLI mappings:
- `nix-channel` → `inputs` in `flake.nix` + `nix registry`
- `nix-env` → `nix profile` (avoid both; use declarative config)
- `nix-shell` → `nix develop` / `nix shell` / `nix run`
- `nix-build` → `nix build`
- `nix-collect-garbage` → no replacement, still needed

Reference: [nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes)