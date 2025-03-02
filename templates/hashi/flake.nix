{
  description = "A Nix-flake-based development environment for Terraform, Packer, and Nomad";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          packer
          terraform
          tflint
          nomad
          vault
          nomad-autoscaler
          nomad-pack
          levant
          damon
          terragrunt
        ];
      };
    });
  };
}
