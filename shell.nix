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
      # Initialize submodules on entry rather than nagging about them.
      # `git submodule status` prefixes each entry by state: ' ' = initialized at
      # the recorded commit, '+' = initialized at a different commit (normal while
      # working, not a problem), '-' = not initialized, 'U' = merge conflict. Only
      # the last two are worth acting on — testing for "anything but a space" also
      # caught '+' and then reported it as "not initialized".
      if [ -f .gitmodules ] && git submodule status 2>/dev/null | grep -qE '^(-|U)'; then
        git submodule update --init --recursive >/dev/null 2>&1 ||
          echo "⚠️  Git submodules not initialized. Run: git submodule update --init"
      fi

      if [[ $- == *i* ]]; then
        exec zsh
      fi
    '';
  };
}
