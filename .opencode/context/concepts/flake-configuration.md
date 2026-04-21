# Flake Configuration (flake.nix)

Core concept: `flake.nix` has two main sections: `inputs` (dependencies) and `outputs` (a function taking inputs, returning build results like `nixosConfigurations`). The `self` parameter in outputs refers to the current flake's source tree and outputs.

Key Points:
- `inputs` defines all dependencies; they're passed as args to `outputs`
- `outputs` is a function: `outputs = { self, nixpkgs, ... }@inputs: { ... }`
- `nixpkgs.lib.nixosSystem` creates a NixOS configuration from a `modules` list
- `specialArgs` passes extra parameters to all submodules (e.g., `inputs`)
- `nixos-rebuild switch --flake .#hostname` targets a specific config
- Can reference remote flakes: `--flake github:owner/repo#hostname`

Example:
```nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
```

Reference: [nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained)