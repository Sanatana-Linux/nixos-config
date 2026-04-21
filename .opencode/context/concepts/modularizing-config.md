# Modularizing NixOS Configuration

Core concept: Split monolithic `configuration.nix` and `home.nix` into multiple Nix modules using `imports`. Modules are auto-merged (lists concatenate, attrs merge deeply). Use `mkDefault`/`mkForce` for priority and `mkBefore`/`mkAfter` for list ordering.

Key Points:
- `imports = [ ./module1.nix ./module2.nix ]` merges all config from listed modules
- Importing a directory path executes its `default.nix`
- Lists merge (concatenate), attribute sets merge deeply
- `mkDefault` (priority 1000) < direct assignment (100) < `mkForce` (50) — lower number = higher priority
- `mkBefore` (priority 500) inserts before default (1000); `mkAfter` (1500) inserts after
- Same priority for same option → error (use `mkBefore`/`mkAfter` for lists/strings)
- Use `mkDefault` in base modules, override in host-specific modules

Example:
```nix
# Base module
nixpkgs.config.allowUnfree = lib.mkDefault false;
# Host module (overrides base)
nixpkgs.config.allowUnfree = lib.mkForce true;
```

Reference: [nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration)