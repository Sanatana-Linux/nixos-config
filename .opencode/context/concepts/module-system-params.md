# Nixpkgs Module System & specialArgs

Core concept: Nixpkgs module system provides 5 auto-injected parameters: `lib`, `config`, `options`, `pkgs`, `modulesPath`. Pass custom parameters to submodules via `specialArgs` (preferred) or `_module.args`.

Key Points:
- Auto-injected params: `lib`, `config`, `options`, `pkgs`, `modulesPath` (NixOS only)
- `specialArgs`: set in `nixpkgs.lib.nixosSystem`, available in `imports` — no infinite recursion
- `_module.args`: set inside any module, more flexible but evaluated after imports → infinite recursion if used in `imports`
- `specialArgs = { inherit inputs; }` passes flake inputs to all submodules
- Install packages from other flakes: `inputs.helix.packages."${pkgs.stdenv.hostPlatform.system}".helix`

Example:
```nix
nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  modules = [ ./configuration.nix ];
};
# Then in configuration.nix:
{ config, pkgs, inputs, ... }: {
  environment.systemPackages = [ inputs.helix.packages.x86_64-linux.helix ];
};
```

Reference: [nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system)