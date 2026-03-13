{pkgs, ...}: {
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
      nodejs
      pnpm
      zsh
    ];

    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";

    shellHook = ''
      if [[ $- == *i* ]]; then
        exec zsh
      fi
    '';
  };
}
