---
name: nixos-debug
description: Debug NixOS build and evaluation failures. Use when nixos-rebuild fails, nix flake check errors, or module evaluation produces tracebacks. Covers common error patterns, trace analysis, and targeted fix strategies for the ShizNix configuration.
tags: [nix, nixos, debug, error, troubleshooting]
---

# NixOS Debug Skill

Diagnose and fix NixOS build and evaluation failures in the ShizNix configuration.

## When to Use

- `nixos-rebuild` fails with evaluation errors
- `nix flake check` reports errors
- Module options conflict or are undefined
- Build fails with derivation errors
- Infinite recursion in evaluation
- Missing packages or broken dependencies

## Common Error Patterns

### 1. "attribute '...' is not defined" or "undefined variable"

**Cause**: A module option or variable is referenced but not declared or imported.

**Fix**:
1. Check if the module is imported in the category's `default.nix`
2. Check if the option path matches the declaration (e.g., `config.modules.system.boot` vs `config.modules.boot`)
3. Check if the host imports the module in its `default.nix`
4. Run `nix-instantiate --eval --expr 'let pkgs = import <nixpkgs> {}; in ...'` to test

### 2. "infinite recursion encountered"

**Cause**: An option references itself, directly or indirectly.

**Fix**:
1. Look for circular `mkIf` dependencies
2. Check that `config` references don't form a loop
3. Use `lib.mkOverride` or `lib.mkDefault` to break cycles
4. Common pattern: `config.modules.X.Y.enable` referencing `config.modules.X.Y.someOption` that depends on the same module

### 3. "cannot find attribute" in flake check

**Cause**: A new file wasn't `git add`ed before building.

**Fix**: `git add <new-file>` then rebuild. Nix flakes only see tracked files.

### 4. Build failure: "error: builder for ... failed"

**Cause**: A package derivation failed to build (compilation error, missing dependency, etc.).

**Fix**:
1. Check the full build log: `nix log <derivation-path>`
2. For package overrides in `overlays/`, check the patch or override logic
3. For custom packages in `pkgs/`, check the derivation

### 5. "option `modules.X.Y.enable' is used but not defined"

**Cause**: A module references an option that doesn't exist.

**Fix**:
1. Check the option declaration path in the module file
2. Ensure the module is imported before it's used
3. Check for typos in the option path

### 6. "attribute '...' at ... does not have attribute '...'"

**Cause**: A nested option path is wrong.

**Fix**: Check the full option path. Common mistake: `config.modules.system.boot` when the module declares `options.modules.boot`.

## Diagnostic Commands

```bash
# Show full trace
nixos-rebuild build --flake .#bhairavi --show-trace

# Check just evaluation (no build)
nix-instantiate --eval -E '(import ./flake.nix).outputs'

# List all options in a module
nix eval --file ./modules/nixos/system/boot.nix --json

# Check a specific option value
nix eval nixos#modules.system.boot.enable

# View build log for a failed derivation
nix log /nix/store/<hash>-<name>.drv

# Dry build to check without switching
nixos-rebuild dry-build --flake .#bhairavi
```

## Workflow

1. **Reproduce** the error with `--show-trace`
2. **Read** the trace from bottom to top (the actual error is usually at the bottom)
3. **Identify** the error pattern from the list above
4. **Fix** the root cause (not the symptom)
5. **Verify** with `nixos-rebuild build --flake .#bhairavi`
6. **Format** with `alejandra` after fixing
