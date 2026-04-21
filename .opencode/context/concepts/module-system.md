# Module System

Core concept: Activate-by-enable-option pattern — importing a module does nothing until its `.enable` option is set true. This allows all modules to be imported everywhere while only active ones contribute config.

Key Points:
- `mkEnableOption` creates a boolean option defaulted to false
- `mkIf cfg.enable` guards all config so inactive modules are no-ops
- Modules can activate/deactivate other modules (cross-module composition)
- Two modules conflicting over a third's state raises clear errors
- All options are machine-discoverable even when disabled (enables `nix flake check`, docs generation)
- `mkMerge` combines multiple conditional attribute sets within one module

Example:
```nix
options.modules.<category>.<name>.enable = mkEnableOption "description";
config = mkIf cfg.enable { ... };
```

Reference: [.documentation/Nix_Modules_Explained_Coherently.md](../../.documentation/Nix_Modules_Explained_Coherently.md)