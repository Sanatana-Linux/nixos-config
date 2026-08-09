# Nix `pkgs.system` Deprecation Rule

> Use `pkgs.stdenv.hostPlatform.system` instead of the deprecated `pkgs.system`.

## Rule

In Nix files, never reference the package-set attribute `pkgs.system`. It has been renamed to `pkgs.stdenv.hostPlatform.system` and is a hard evaluation error in current Nixpkgs.

### Bad (deprecated — fails evaluation)
```nix
package = inputs.sharabha-gtk.packages.${pkgs.system}.default;
```

### Good (current)
```nix
package = inputs.sharabha-gtk.packages.${pkgs.stdenv.hostPlatform.system}.default;
```

## Why

- Nixpkgs renamed `pkgs.system` to `pkgs.stdenv.hostPlatform.system`; the old name is now a hard error (`'system' has been renamed to 'stdenv.hostPlatform.system'`)
- `pkgs.stdenv.hostPlatform.system` is the canonical way to get the current build platform string (e.g. `x86_64-linux`) from a package set
- This commonly appears when indexing a flake input's package set by platform: `inputs.<name>.packages.${pkgs.stdenv.hostPlatform.system}.default`

## Do NOT confuse with

The NixOS option `nixpkgs.system` (e.g. `nixpkgs.system = lib.mkDefault "x86_64-linux";`) is **valid and unrelated** — it sets the system for the NixOS configuration and must not be changed. Only the package-set attribute `pkgs.system` is deprecated.
