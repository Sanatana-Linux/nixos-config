# Project Templates

## Introduction

This configuration is packaged with pre-made flake templates, which are located in the `templates/` directory in the project's root and available via the flake interface at `outputs.templates`.

**Pre-made nix flake templates for various programming languages offer several benefits when integrated into your NixOS configuration:** - **Streamlined Project Setup:** With pre-made templates, I can quickly initialize new projects with the correct language-specific dependencies and build systems already configured on a **per-project** basis. This saves time and reduces manual setup errors or other NixOS surprises that might arise from attempting to keep that build environment as part of a system or user wide configuration that with some languages and toolchains on Nix (**cough** Rust **cough**) can be extremely frustrating. - **Consistency Across Projects:** Using templates ensures that all projects follow a consistent structure and environment. If an individual project requires something specific to it, I can easily modify the flake accordingly and do not have to adjust the system wide configuration or fight with node version managers to do so. This consistency and flexibility makes it easier to switch between projects and collaborate with others who likely don't do things exactly like I do and may use tools NixOS would frustrate my efforts to cooperate with them using. - **Easy Dependency Management:** Nix handles development and toolchain dependencies in a predictable way with the potential to override built in, ensuring that each project uses the exact version of its dependencies required for building and testing. Templates help maintain this predictability across my projects. - **Reproducible Environments:** With templates, you can easily recreate the development environment for any project at any time. This is particularly useful when onboarding with unfamiliar languages and toolchains, or particularly if I have forgotten exactly the steps needed to set up some development environment due to having worked with other techstacks in the time between a particular instance and the last time I worked with that techstack.

## Getting Started

The `outputs.templates` configured by this repository's `flake.nix` can be used in the following way: 1. run `nix flake init -t /etc/nixos/#templateName` 2. run `git init` 3. replace placeholder names with the name of the project 4. run `git add .` to make nix aware of all required files 5. run `nix develop` to enter the development environment

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
