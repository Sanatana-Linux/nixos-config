{
  pkgs,
  config,
  inputs,
  ...
}: {
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    extraPackages = with pkgs; [
      jq
      tree-sitter
      nodePackages_latest.nodejs
      # nodePackages_latest.neovim
      tree-sitter-grammars.tree-sitter-c
      tree-sitter-grammars.tree-sitter-ql
      tree-sitter-grammars.tree-sitter-go
      tree-sitter-grammars.tree-sitter-vue
      tree-sitter-grammars.tree-sitter-rust
      tree-sitter-grammars.tree-sitter-vim
      tree-sitter-grammars.tree-sitter-tsx
      tree-sitter-grammars.tree-sitter-sql
      tree-sitter-grammars.tree-sitter-rst
      tree-sitter-grammars.tree-sitter-nix
      tree-sitter-grammars.tree-sitter-lua
      tree-sitter-grammars.tree-sitter-dot
      tree-sitter-grammars.tree-sitter-css
      tree-sitter-grammars.tree-sitter-cpp
      tree-sitter-grammars.tree-sitter-yaml
      tree-sitter-grammars.tree-sitter-toml
      tree-sitter-grammars.tree-sitter-scss
      tree-sitter-grammars.tree-sitter-ruby
      tree-sitter-grammars.tree-sitter-regex
      tree-sitter-grammars.tree-sitter-make
      tree-sitter-grammars.tree-sitter-just
      tree-sitter-grammars.tree-sitter-json
      tree-sitter-grammars.tree-sitter-cuda
      tree-sitter-grammars.tree-sitter-html
      tree-sitter-grammars.tree-sitter-bash
      tree-sitter-grammars.tree-sitter-python
      tree-sitter-grammars.tree-sitter-graphql
      tree-sitter-grammars.tree-sitter-markdown
      tree-sitter-grammars.tree-sitter-typescript
      tree-sitter-grammars.tree-sitter-javascript
      tree-sitter-grammars.tree-sitter-dockerfile

      yarn

      # Faster filewatch
      fswatch

      # Build some extensions
      gcc
      cmake
    ];

    extraLuaPackages = ps:
      with ps; [
        # for image support
        magick
      ];

    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;


    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    # package = pkgs.neovim-unwrapped;
  };

  home.activation.installNeoVimConfig = ''
    if [ ! -d "$HOME/.config/nvim" ]; then
     ${pkgs.git}/bin/git clone https://github.com/Thomashighbaugh/nvim-forge "$HOME/.config/nvim"
      chmod -R +w "$HOME/.config/nvim"
    fi
  '';
}
