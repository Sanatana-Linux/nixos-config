{
  description = "A Nix-flake-based Clojure development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    javaVersion = 23; # Change this value to update the whole stack

    supportedSystems = ["x86_64-linux" "aarch64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [self.overlays.default];
          };
        });
  in {
    overlays.default = final: prev: let
      jdk = prev."jdk${toString javaVersion}";
    in {
      boot = prev.boot.override {inherit jdk;};
      clojure = prev.clojure.override {inherit jdk;};
      leiningen = prev.leiningen.override {inherit jdk;};
    };

    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [boot clojure leiningen];
      };
    });
  };
}
