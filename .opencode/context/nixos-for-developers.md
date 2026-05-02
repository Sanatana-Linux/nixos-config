# NixOS: For Developers

> Source: https://myme.no/posts/2020-01-26-nixos-for-development.html | Martin Myrseth | 2020-01-26

Comprehensive guide on using NixOS for software development across languages (Haskell, Python, JavaScript/TypeScript).

## Core Philosophy

Nix is primarily a **source distribution and build tool**, not just a binary package manager. Binary caching is a consequence of content-addressable deterministic builds. Every dependency is just another Nix expression — Nix builds the entire dependency tree on demand if not cached.

## Development Workflow

### nix-shell

```bash
nix-shell -p python3 -p nodejs-10_x  # ad-hoc
nix-shell                             # loads shell.nix or default.nix
```

### direnv + nix-direnv

Automatic environment activation when `cd`ing into project directories. Uses `.envrc` with `use_nix`.

```bash
echo 'use_nix' > .envrc
direnv allow
```

**nix-direnv** provides significant performance boost over stock `direnv` by caching nix-shell evaluation and symlinking to gcroots (prevents garbage collection).

### lorri (alternative)

Background daemon that builds environments as expressions change, keeps them in gcroots.

### Emacs Workflow

- **Problem**: Single Emacs process with global `exec-path` can't switch environments per project
- **Solution**: Use `nix-direnv` (cached, fast) + one Emacs instance per project, or `emacs-direnv` plugin
- Tip: Prefer launching Emacs from within `nix-shell` per project for reliable tool resolution

## Pinning nixpkgs

Always pin nixpkgs to a specific commit for reproducibility:

```nix
fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/19.09.tar.gz";
  sha256 = "0mhqhq21y5vrr1f30qd2bvydv4bbbslvyzclhw0kdxmkgg3z4c92";
}
```

## Language-Specific Patterns

### Haskell

```nix
# default.nix — uses haskellPackages.mkDerivation
haskellPackages.mkDerivation {
  pname = "nixon"; version = "0.1.0.0";
  src = gitignoreSourcePure [ ./.gitignore ] ./.;
  executableHaskellDepends = with haskellPackages; [ aeson base turtle ];
  executableSystemDepends = with pkgs; [ fzf rofi ];
}

# shell.nix — development shell with tools
haskellPackages.shellFor {
  packages = _: [ drv ];
  buildInputs = with pkgs; [ cabal2nix cabal-install hlint ];
}
```

**Nix replaces stack** (not cabal). Use `callCabal2nix` for simple projects, `haskellPackages.shellFor` for dev shells.

### Python

```nix
mkShell {
  buildInputs = [
    (python36.withPackages (ps: with ps; [ pip virtualenv requests ]))
    libjpeg.dev openssl.dev zlib.dev  # system deps for wheels
  ];
  shellHook = ''
    export SOURCE_DATE_EPOCH="$(date +%s)"  # for wheels
    if [ -d ./venv ]; then source ./venv/bin/activate; fi
  '';
}
```

- Override `buildPythonPackage` for pinned dependency versions
- Use `fetchPypi` for packages not in nixpkgs
- `nixpkgs` breaks FHS — hardcoded paths in `setup.py` (e.g. Pillow) need special handling

### JavaScript / TypeScript

Keep it simple: use Nix to provide `node`, `npm`, `yarn`, then invoke them directly.

```nix
buildInputs = with pkgs; [ nodejs-10_x yarn nodePackages.javascript-typescript-langserver ];
```

Generators: `node2nix`, `yarn2nix`, `npm2nix` (abandoned).

## Ad-hoc Environments

### Shebang scripts

```bash
#! /usr/bin/env nix-shell
#! nix-shell -p "haskellPackages.ghcWithPackages (ps: with ps; [turtle])"
#! nix-shell -i runghc
```

### Pre-defined overlay environments

```nix
# ~/.config/nixpkgs/overlays.nix
self: super: {
  nodeEnv = with self; buildEnv {
    name = "env-node";
    paths = [ nodejs-10_x nodePackages_10_x.javascript-typescript-langserver yarn ];
  };
}

# Usage: nix-shell -p nodeEnv
```

### Monorepo (Haskell)

Use `cabal.project` listing sub-packages, then `callCabal2nix` with `shellFor` for development.

## Key Takeaways

- **Discoverability is hard** — nixpkgs has different idioms per language ecosystem; finding the right utility function is a major pain point
- **Documentation gap** — many helpers exist in nixpkgs but are poorly documented
- **Nix + language tools**: Nix provides the deterministic toolchain; project-level package managers (pip, npm, cabal) still operate within the environment
- **Generators** bridge the gap: `node2nix`, `cabal2nix`, `setup.nix` automate Nix expression generation from package manifests
