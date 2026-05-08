<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# templates

## Purpose
42 dev environment flake templates exposed via `flake.nix` (`templates = import ./templates`). Each template directory contains a `flake.nix` providing a ready-made `nix develop` shell for that language/toolchain.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Template registry — attrset of `{ path, description }` entries consumed by `flake.nix` |

## Usage

```bash
nix flake init -t .#rust          # initialize from a template
nix develop -t .#python            # enter a template dev shell
nix flake show .#templates         # list all available templates
```

## Templates (42)

| Template | Description |
|----------|-------------|
| `bun` | Bun development environment |
| `c-cpp` | C/C++ development environment |
| `clojure` | Clojure development environment |
| `csharp` | C# development environment |
| `cue` | Cue development environment |
| `dhall` | Dhall development environment |
| `elixir` | Elixir development environment |
| `elm` | Elm development environment |
| `empty` | Empty dev template that you can customize at will |
| `gleam` | Gleam development environment |
| `go` | Go (Golang) development environment |
| `hashi` | HashiCorp DevOps tools development environment |
| `haxe` | Haxe development environment |
| `haskell` | Haskell development environment |
| `java` | Java development environment |
| `jupyter` | Jupyter development environment |
| `kotlin` | Kotlin development environment |
| `latex` | LaTeX development environment |
| `lean4` | Lean 4 development environment |
| `nickel` | Nickel development environment |
| `nim` | Nim development environment |
| `nix` | Nix development environment |
| `node` | Node.js development environment |
| `ocaml` | OCaml development environment |
| `opa` | Open Policy Agent development environment |
| `perl` | Perl development environment |
| `php` | PHP development environment |
| `platformio` | PlatformIO development environment |
| `protobuf` | Protobuf development environment |
| `pulumi` | Pulumi development environment |
| `purescript` | Purescript development environment |
| `python` | Python development environment |
| `r` | R development environment |
| `ruby` | Ruby development environment |
| `rust` | Rust development environment |
| `rust-toolchain` | Rust with version defined by rust-toolchain.toml |
| `scala` | Scala development environment |
| `shell` | Shell script development environment |
| `swi-prolog` | SWI-Prolog development environment |
| `swift` | Swift development environment |
| `vlang` | V development environment |
| `zig` | Zig development environment |

## For AI Agents

### Working In This Directory
- Each template is a self-contained `flake.nix` — do not add ad-hoc packages here
- To add a new template: create `<name>/flake.nix`, add entry to `default.nix`, then `git add` before building
- Templates are referenced by name via `.#<name>` (e.g., `nix flake init -t .#go`)
- The `empty` template is the starting point for custom environments

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->