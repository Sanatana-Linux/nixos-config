# callPackage Pattern

Core concept: `pkgs.callPackage` parameterizes derivation construction. It auto-injects matching params from `pkgs` while allowing explicit overrides via second argument. Makes dependencies explicit and derivations reusable.

Key Points:
- `pkgs.callPackage ./pkg.nix {}` — auto-injects all function params matching `pkgs` attributes
- `pkgs.callPackage ./pkg.nix { src = customSrc; }` — override specific params
- Function params become explicit dependency declarations
- All dependencies can be replaced without modifying the original `.nix` file
- Always use `callPackage` for custom package definitions

Example:
```nix
# pkgs/kernel.nix
{ lib, stdenv, linuxManualConfig, src, boardName, ... }:
  linuxManualConfig { inherit src lib stdenv; ... };
# Usage
boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./pkgs/kernel {
  src = kernel-src;
  boardName = "licheepi4a";
});
```

Reference: [nixos-and-flakes.thiscute.world/nixpkgs/callpackage](https://nixos-and-flakes.thiscute.world/nixpkgs/callpackage)