# Flake Inputs

Core concept: The `inputs` section in `flake.nix` declares all dependencies. Supports GitHub repos, Git URLs, local paths, SSH, archives, and more. Use `follows` to align dependency versions and `flake = false` for non-flake sources.

Key Points:
- GitHub: `nixpkgs.url = "github:owner/repo/branch"`
- Git URL: `url = "git+https://host/user/path?ref=branch"`
- SSH: `url = "git+ssh://git@github.com/user/repo.git?shallow=1"`
- Local: `url = "path:/path/to/repo"` or `url = "git+file:///path?shallow=1"`
- PR reference: `url = "github:NixOS/nixpkgs/pull/349351/head"`
- Lock to commit: add `?rev=xxxx` to URL
- Non-flake: `bar = { url = "..."; flake = false; }` — reference as `"${inputs.bar}/path"`
- Align deps: `inputs.nixpkgs.follows = "nixpkgs"` prevents version mismatches
- Subdirectory: `?dir=shu` parameter
- LFS support: `?lfs=1` (Nix 2.27+)

Reference: [nixos-and-flakes.thiscute.world/other-usage-of-flakes/inputs](https://nixos-and-flakes.thiscute.world/other-usage-of-flakes/inputs)