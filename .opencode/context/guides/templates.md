# Project Templates

Core concept: Flake templates in `templates/` directory provide per-project development shells for 50+ languages, avoiding system-wide toolchain conflicts (especially Rust, Node).

Key Points:
- Use: `nix flake init -t /etc/nixos/#templateName` → `git init` → `nix develop`
- Templates available for: bun, c/c++, clojure, go, haskell, java, node, python, rust, zig, and 40+ more
- Isolates toolchain dependencies per-project
- Defined in `outputs.templates` in flake.nix

Example:
```bash
nix flake init -t /etc/nixos/#rust
git init && git add . && nix develop
```

Reference: [.documentation/using-repository-templates.md](../../.documentation/using-repository-templates.md)