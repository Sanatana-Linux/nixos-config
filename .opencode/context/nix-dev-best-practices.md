# Nix Best Practices (nix.dev)

> Source: https://nix.dev/guides/best-practices | Official Nix documentation

## URLs — Always Quote

```nix
"https://example.com"  # correct
https://example.com    # deprecated (RFC 45)
```

## Avoid `rec { ... }`

Use `let ... in` instead to prevent `infinite recursion` bugs.

```nix
# BAD
rec { a = 1; b = a + 2; }

# GOOD
let a = 1; in { inherit a; b = a + 2; }

# Self-reference pattern
let argset = { a = 1; b = argset.a + 2; }; in argset
```

## Avoid `with` at Top Level

```nix
# BAD: with (import <nixpkgs> {}); ...

# GOOD
let pkgs = import <nixpkgs> {}; inherit (pkgs) curl jq; in ...

# Alternative to `with pkgs; [ curl jq ]`
buildInputs = builtins.attrValues { inherit (pkgs) curl jq; };
```

## Avoid `<...>` Lookup Paths

`<nixpkgs>` depends on `$NIX_PATH` (external state). Pin explicitly instead.

```nix
# On NixOS, set NIX_PATH centrally:
nix.nixPath = [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos" ];
```

## Reproducible Nixpkgs Import

```nix
import <nixpkgs> { config = {}; overlays = []; }
```

Explicit empty config/overlays ensures reproducibility (Nixpkgs defaults impurely read from filesystem).

## Nested Attribute Set Updates

`//` is shallow. Use `lib.recursiveUpdate` for deep merges.

```nix
# BAD: { a = { b = 1; }; } // { a = { c = 3; }; }  => { a = { c = 3; }; }
# GOOD
pkgs.lib.recursiveUpdate { a = { b = 1; }; } { a = { c = 3; }; }
# => { a = { b = 1; c = 3; }; }
```

## Reproducible Source Paths

`src = ./.;` embeds the parent directory name. Use `builtins.path` with a fixed `name`.

```nix
pkgs.stdenv.mkDerivation {
  name = "foo";
  src = builtins.path { path = ./.; name = "myproject"; };
}
```
