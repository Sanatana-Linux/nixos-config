{pkgs ? (import ./nixpkgs.nix) {}}: {
  default = pkgs.mkShell {
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = recursive-nix auto-allocate-uids ca-derivations  nix-command flakes";
    nativeBuildInputs = with pkgs; [nix home-manager git vim neovim silver-searcher];
  };
}
