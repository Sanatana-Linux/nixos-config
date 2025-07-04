{pkgs ? (import ./nixpkgs.nix) {}}: {
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      nix
      git
      home-manager
      figlet
      lolcat
      nixVersions.latest
      alejandra
      neovim
      silver-searcher
    ];

    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = recursive-nix ca-derivations  nix-command flakes";
    # TODO Add shell hook and MOTD message
  };
}
