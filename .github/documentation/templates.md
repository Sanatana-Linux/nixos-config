# Project Templates

The `outputs.templates` configured by this repository's `flake.nix` can be used in the following way: 1. run `nix flake init -t myTemplateFlake#templateName` 2. run `git init` 3. replace placeholder names with the name of the project 4. run `git add .` to make nix aware of all required files 5. run `nix develop` to enter the development environment

## Available Templates

- bun
- c/c++
- clojure
- csharp
- cue
- default.nix
- dhall
- elixir
- elm
- empty
- gleam
- go
- hashi
- haskell
- haxe
- java
- jupyter
- kotlin
- latex
- lean4
- nickel
- nim
- nix
- node
- ocaml
- opa
- php
- platformio
- protobuf
- pulumi
- purescript
- python
- r
- ruby
- rust
- rust-toolchain
- scala
- shell
- swi-prolog
- swift
- vlang
- zig
