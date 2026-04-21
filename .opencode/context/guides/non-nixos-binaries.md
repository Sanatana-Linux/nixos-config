# Running Non-NixOS Binaries

Core concept: NixOS doesn't follow FHS, so downloaded binaries may fail to find libraries. Solutions include `nix-ld`, `buildFHSEnv`, `nix-alien`, and Docker.

Key Points:
- NixOS lacks `/lib`, `/usr/bin`, etc. — binaries expect these paths
- `nix-ld` (this repo uses it via `modules.programs.nix-ld`) — sets up a linker for unpatched binaries
- `buildFHSEnv` creates an FHS-compatible shell — use `fhs` command to enter
- `nix-alien` auto-creates FHS environments for specific binaries
- AppImage support via `appimage-run` (this repo enables it)
- Docker always works as a fallback

Example:
```nix
# FHS environment based on appimage base (includes X libs etc.)
(let base = pkgs.appimageTools.defaultFhsEnvArgs; in
 pkgs.buildFHSUserEnv (base // {
   name = "fhs";
   targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
   profile = "export FHS=1";    # for shell prompt detection
   runScript = "fish";           # your shell
   extraOutputsToInstall = ["dev"];
 }))
```

### Quick usage
```bash
$ wget https://example.com/binary.tar.gz && aunpack binary.tar.gz && cd binary-dir
$ ./bin/app            # fails: cannot execute, required file not found
$ fhs                  # drops into FHS shell
(fhs) $ ./bin/app      # works
```

Reference: [nixos-and-flakes.thiscute.world/best-practices/run-downloaded-binaries-on-nixos](https://nixos-and-flakes.thiscute.world/best-practices/run-downloaded-binaries-on-nixos)