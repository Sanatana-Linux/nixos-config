# CUDA Compatibility Compliation Error

- **Date:** 11-24-2025

**Error** During a recent upgrade, the CUDA packages failed building, which had also caused my nix version to fail to build a new nix version and a whole mess of other errors across numerous other packages. A week of debugging later, turns out the issue derived from `allowUnsupportedSystem = true;` being set in the user configuration part of host.

Apparently CUDA has cross architecture compatibility issues, and setting this flag causes the build system to attempt to build CUDA with support it does not actually have, leading to a cascade of build failures. Why was this not an issue prior but is now? Likely some recent change in the nixpkgs repository or the CUDA package itself that tightened compatibility checks.
