{pkgs ? (import ./nixpkgs.nix) {}}: {
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      git
      home-manager
      figlet
      lolcat
      nixVersions.git
      alejandra
      neovim
      silver-searcher
    ];

    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = recursive-nix ca-derivations  nix-command flakes";
    nativeBuildInputs = with pkgs; [nixVersions.git libcs50 gcc alejandra home-manager git neovim silver-searcher];
  };
}
