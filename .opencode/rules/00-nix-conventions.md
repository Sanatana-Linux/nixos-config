# Nix Language Conventions

Auto-generated from codebase analysis for the **ShizNix** project.

## Code Organization

- NixOS modules live in `modules/nixos/<category>/<name>.nix`
- Home-manager modules live in `modules/home-manager/<category>/<name>.nix`
- Host configs live in `hosts/<host>/default.nix`
- Per-user configs live in `home/<user>/default.nix`
- Custom packages live in `pkgs/<name>.nix`
- Overlays live in `overlays/` (one file per overlay)
- Flake templates live in `templates/<name>/`

## Module Pattern (Mandatory)

```nix
{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.modules.<category>.<name>;
in {
  options.modules.<category>.<name> = {
    enable = mkEnableOption "Description";
  };

  config = mkIf cfg.enable {
    # implementation
  };
}
```

## Imports & References

- Use `inputs.<name>` to reference flake inputs (not `fetchTarball` or hardcoded URLs)
- Use `pkgs.<name>` for nixpkgs packages
- Use `lib.<function>` for standard library functions
- Use `modulesPath` for referencing nixpkgs module path: `"${modulesPath}/..."`

## Error Handling

- Prefer `lib.assertMsg` / `lib.assertOneOf` for option validation
- Use `builtins.abort` for fatal eval-time errors
- Wrap risky operations in `lib.throwIf` / `lib.warn`

## String Handling

- `types.str` (NOT deprecated `types.string`)
- Multi-line strings: `''...''` (double-single-quote)
- Escaping in multi-line: `''\${variable}'' ` (extra quote before interpolation)
- Indented strings: `''\n  indented\n'' ` — leading whitespace is stripped proportionally

## Lists & Sets

- Use `lib.mkIf <condition> [ ... ]` for conditional list elements
- Use `lib.optional <condition> <element>` for single optional items
- Use `lib.optionals <condition> <list>` for multiple optional items
- Merge attribute sets with `//` or `lib.recursiveUpdate`
- Use `lib.attrsets.mergeAttrsList` for merging many sets

## Nix Idioms

| Do This | Not This |
|---------|----------|
| `lib.mkIf cfg.enable { ... }` | `if cfg.enable then { ... } else {}` |
| `lib.mkDefault value` | `value` (in shared config) |
| `lib.mkForce value` | `value` (in host overrides) |
| `lib.optionalAttrs cond { ... }` | `if cond then { ... } else {}` |
| `let ... in` for local bindings | Nested `let ... in` |
| `with lib;` at module top | `with lib;` inside expressions |

## Formatting

The project uses **alejandra** (not nixfmt or nixpkgs-fmt):
```bash
alejandra .  # format all .nix files
```

Alejandra enforces:
- 2-space indentation
- No trailing semicolons after `}` in attribute sets
- Specific spacing around operators
- Multi-line `{ ... }` splitting rules

Use `alejandra --check .` in CI to validate formatting.