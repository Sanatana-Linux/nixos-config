{
  description = "A Nix-flake-based Rust development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [rust-overlay.overlays.default self.overlays.default];
          };
        });
  in {
    overlays.default = final: prev: {
      rustToolchain = final.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
    };

    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          rustToolchain
          openssl
          pkg-config
          cargo-deny
          cargo-edit
          cargo-watch
          rust-analyzer
        ];

        env = {
          # Required by rust-analyzer
          RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
        };
      };
    });
  };
}
