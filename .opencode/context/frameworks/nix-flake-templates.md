---
title: "Nix Flake Templates"
type: reference
tags: [templates, flakes, development, environments]
created: 2026-07-15
updated: 2026-07-15
sources: [.documentation/using-repository-templates.md]
status: active
---

# Nix Flake Templates

The repository includes 42 pre-made flake templates in `templates/` for setting up development environments for various languages and tools.

## Usage

```bash
# Initialize a project with a template
nix flake init -t /etc/nixos/#templateName

# Initialize git
git init

# Edit placeholder names to match your project
# (templates use placeholders for project-specific values)

# Make nix aware of the new files
git add .

# Enter the development environment
nix develop
```

## Available Templates

`bun`, `c/c++`, `clojure`, `csharp`, `cue`, `default.nix`, `dhall`, `elixir`, `elm`, `empty`, `gleam`, `go`, `hashi`, `haskell`, `haxe`, `java`, `jupyter`, `kotlin`, `latex`, `lean4`, `nickel`, `nim`, `nix`, `node`, `ocaml`, `opa`, `php`, `platformio`, `protobuf`, `pulumi`, `purescript`, `python`, `r`, `ruby`, `rust`, `rust-toolchain`, `scala`, `shell`, `swi-prolog`, `swift`, `vlang`, `zig`

## Why Templates?

- **Streamlined setup** — per-project dependencies without system-wide pollution, avoiding NixOS-specific surprises (especially with Rust and Node toolchains)
- **Consistency** — every project gets the same environment structure with easy per-project overrides
- **Reproducible** — environments are repeatable regardless of when you return to a project
