# Xe Iaso: Nix Flakes Series — Ingested 2026-05-17

## Source
Both URLs were blocked by Anubis anti-bot on `xeiaso.net`. Manually downloaded via browser.

- Part 1: **Nix Flakes: an Introduction** — https://xeiaso.net/blog/nix-flakes-1-2022-02-21/
- Part 2: **Nix Flakes: Packages and How to Use Them** — https://xeiaso.net/blog/nix-flakes-2-2022-02-27/

## Part 1: Introduction (2022-02-21, 2771 words)

### Key Points

**Why flakes matter:**
- Nix alone is "more akin to Dockerfiles" — helps build software but not run/operate it
- Flakes are "more akin to docker-compose" — compose packages written in Nix across machines
- Define a standard set of conventions for building, running, integrating, and deploying software

**Major benefits listed:**
1. Project templates built into Nix (`nix flake init -t`)
2. Standard way to say "this is a program you can run"
3. Consolidate dev environments into project config
4. Trivial external dependency management from git repos
5. Backwards compatibility with non-flake users (via flake-compat)
6. Private git repo support (`git+ssh://git@github.com/...`)
7. Embed NixOS modules alongside application code
8. Embed git hash of config repo into deployed machines

**Go project walkthrough:**
- Used `nix flake new -t templates#go-hello .`
- `inputs.nixpkgs.url = "nixpkgs/nixos-21.11"`
- `packages.default = pkgs.buildGoModule { ... }`
- `apps.default = { type = "app"; program = "..."; }` for `nix run`
- `devShells.default = pkgs.mkShell { buildInputs = [ go gopls gotools ]; }` for `nix develop`
- `nix flake update` to update inputs

**Input follows pattern:**
- `inputs.xess.inputs.nixpkgs.follows = "nixpkgs"` — prevents pulling in separate nixpkgs trees

**flake-compat for backwards compatibility:**
- `default.nix` and `shell.nix` that fetch and evaluate the flake for non-flake users
- Pattern: `(import (fetchTarball { url = "...flake-compat..."; sha256 = "..."; }) { src = ./.; }).defaultNix`

**Private repo inputs:** `git+ssh://git@github.com/user/repo?ref=main`

**Embedding config git hash:**
- `system.configurationRevision = self.rev` in NixOS config
- `nixos-version --json` shows `configurationRevision`
- Enables traceability: can link a running machine back to the exact config commit

## Part 2: Packages and How to Use Them (2022-02-27, 2903 words)

### Key Points

**What is a package?**
- "A bundle of files" — executables, resources, container images
- Built via **derivations** (the product of deriving something)
- Minimal example: `stdenv.mkDerivation { name = "hello"; src = ./.; installPhase = ''echo "Hello" > $out''; }`

**Builders as templates:**
- `pkgs.buildGoModule` — specialized for Go (vendorSha256, etc.)
- Naersk for Rust: `naersk-lib.buildPackage ./.` (auto-derives from Cargo.toml/Cargo.lock)
- "Think of builders as ONBUILD Dockerfile instructions, but not limited to Docker"
- Key difference: Nix builds are functions (inputs → outputs); Docker focuses on individual commands

**Docker images from Nix:**
- `pkgs.dockerTools.buildLayeredImage { name, tag, contents, config.Cmd, config.WorkingDir }`
- Each Nix package contributing to the image goes in its own Docker layer
- `docker load < result` to import
- Layer caching works efficiently: only changed layers update

**systemd Portable Services:**
- Like Docker containers but integrated into systemd (readiness signaling, logging pipeline, dependency graph)
- Built via `portableService` function (from overlay at time of writing — now in nixpkgs)
- Build: `pkgs.portableService { name, version, description, units = [ templated-service-file ]; }`
- Deploy: `portablectl attach`, `portablectl reattach` for updates
- Output is a `.raw` SquashFS image

**Key workflow:**
- Flakes make multi-package projects cleaner (before: separate docker.nix, portable.nix; after: all in one flake.nix)
- Before flakes: needed Niv for pinning, opt-in; after: explicit behavior is implicit
