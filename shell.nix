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
      ripgrep # Code search (rg) — replacement for silver-searcher
      nodejs
      pnpm
      zsh
    ];

    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";

    shellHook = ''
      # Check that git submodules are initialized
      if [ -f .gitmodules ]; then
        if ! git submodule status 2>/dev/null | grep -q '^[^ ]'; then
          echo "⚠️  Git submodules not initialized. Run: git submodule update --init"
        fi
      fi

      if [[ $- == *i* ]]; then
        exec zsh
      fi
    '';
  };
}
