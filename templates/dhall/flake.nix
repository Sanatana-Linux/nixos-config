{
  description = "A Nix-flake-based Dhall development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" ];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = let
        # Helper function for building dhall-* tools
        mkDhallTools = ls: builtins.map (tool: pkgs.haskellPackages."dhall-${tool}") ls;

        dhallTools = mkDhallTools [
          "bash"
          "docs"
          "json"
          "lsp-server"
          "nix"
          "nixpkgs"
          "openapi"
          "toml"
          "yaml"
        ];
      in
        pkgs.mkShell {
          packages = (with pkgs; [dhall]) ++ dhallTools;
        };
    });
  };
}
