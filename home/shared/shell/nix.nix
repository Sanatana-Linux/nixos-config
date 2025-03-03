{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      alejandra
      any-nix-shell
      cached-nix-shell
      deadnix
      nix-index
      statix
      nix-bash-completions
      nix-direnv
      nix-binary-cache
      nix-bundle
      nix-direnv-flakes
      nix-health
      nix-janitor
      nix-plugins
      nix-prefetch
      nix-prefetch-scripts
      nix-search-cli
      nix-template
      nix-zsh-completions
    ];

    sessionVariables = with pkgs; {
      DIRENV_LOG_FORMAT = "";
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };
  };

  programs = {
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
