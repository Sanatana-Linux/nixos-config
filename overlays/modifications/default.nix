# Aggregator for per-package modifications overlays.
# Each sub-module exports `{ modifications = final: prev: { <name> = ...; }; }`.
# Sub-modules are combined here so `modifications` stays a single overlay.
# Helpers (signModulePackage) are inlined into their consumer modules.
{inputs, ...}: let
  mods = [
    (import ./linuxPackages_xanmod_latest.nix {inherit inputs;})
    (import ./linuxPackages_latest.nix {inherit inputs;})
    (import ./python312Packages.nix {inherit inputs;})
    (import ./typescript-language-server.nix {inherit inputs;})
    (import ./mcp-nixos.nix {inherit inputs;})
    (import ./what-size.nix {inherit inputs;})
    (import ./opencv4.nix {inherit inputs;})
    (import ./peakperf.nix {inherit inputs;})
    (import ./ffmpeg-full.nix {inherit inputs;})
    (import ./lenovo-legion.nix {inherit inputs;})
    (import ./sillytavern.nix {inherit inputs;})
  ];
in {
  modifications = final: prev: let
    lib = prev.lib;
    # Flatten each sub-module's { <name> = ...; } into name/value pairs, then merge.
    merged = builtins.listToAttrs (builtins.concatMap (m: lib.attrsToList (m.modifications final prev)) mods);
  in
    merged;
}
