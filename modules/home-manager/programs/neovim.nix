{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.neovim;
in {
  options.modules.programs.neovim = {
    enable = mkEnableOption "Neovim text editor with comprehensive configuration";

    withNodeJs = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Node.js support for Neovim";
    };
    withPython3 = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Python support for Neovim";
    };

    withRuby = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Ruby support for Neovim";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra packages to include with Neovim";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/external/nvim;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withNodeJs = cfg.withNodeJs;
      withPython3 = cfg.withPython3;
      withRuby = cfg.withRuby;

      extraPackages = with pkgs;
        [
          # Core dependencies
          yarn
          fswatch
          cmake
          imagemagick

          # Tree-sitter dependencies
          tree-sitter
          tree-sitter-grammars.tree-sitter-astro
          tree-sitter-grammars.tree-sitter-awk
          tree-sitter-grammars.tree-sitter-bash
          tree-sitter-grammars.tree-sitter-cairo
          tree-sitter-grammars.tree-sitter-comment
          tree-sitter-grammars.tree-sitter-cmake
          tree-sitter-grammars.tree-sitter-cpp
          tree-sitter-grammars.tree-sitter-css
          tree-sitter-grammars.tree-sitter-csv
          tree-sitter-grammars.tree-sitter-cuda
          tree-sitter-grammars.tree-sitter-debian
          tree-sitter-grammars.tree-sitter-dart
          tree-sitter-grammars.tree-sitter-devicetree
          tree-sitter-grammars.tree-sitter-diff
          tree-sitter-grammars.tree-sitter-dot
          tree-sitter-grammars.tree-sitter-gitcommit
          tree-sitter-grammars.tree-sitter-git-config
          tree-sitter-grammars.tree-sitter-ghostty
          tree-sitter-grammars.tree-sitter-git-rebase
          tree-sitter-grammars.tree-sitter-gitattributes
          tree-sitter-grammars.tree-sitter-gitignore
          tree-sitter-grammars.tree-sitter-glsl
          tree-sitter-grammars.tree-sitter-go
          tree-sitter-grammars.tree-sitter-ini
          tree-sitter-grammars.tree-sitter-http
          tree-sitter-grammars.tree-sitter-html
          tree-sitter-grammars.tree-sitter-hosts
          tree-sitter-grammars.tree-sitter-json
          tree-sitter-grammars.tree-sitter-javascript
          tree-sitter-grammars.tree-sitter-jinja2
          tree-sitter-grammars.tree-sitter-java
          tree-sitter-grammars.tree-sitter-just
          tree-sitter-grammars.tree-sitter-kotlin
          tree-sitter-grammars.tree-sitter-latex
          tree-sitter-grammars.tree-sitter-ld
          tree-sitter-grammars.tree-sitter-llvm
          tree-sitter-grammars.tree-sitter-lua
          tree-sitter-grammars.tree-sitter-log
          tree-sitter-grammars.tree-sitter-mail
          tree-sitter-grammars.tree-sitter-make
          tree-sitter-grammars.tree-sitter-markdown
          tree-sitter-grammars.tree-sitter-mermaid
          tree-sitter-grammars.tree-sitter-markdown-inline
          tree-sitter-grammars.tree-sitter-nix
          tree-sitter-grammars.tree-sitter-nginx
          tree-sitter-grammars.tree-sitter-move
          tree-sitter-grammars.tree-sitter-org
          tree-sitter-grammars.tree-sitter-norg
          tree-sitter-grammars.tree-sitter-opencl
          tree-sitter-grammars.tree-sitter-org-nvim
          tree-sitter-grammars.tree-sitter-perl
          tree-sitter-grammars.tree-sitter-passwd
          tree-sitter-grammars.tree-sitter-php
          tree-sitter-grammars.tree-sitter-properties
          tree-sitter-grammars.tree-sitter-proto
          tree-sitter-grammars.tree-sitter-powershell
          tree-sitter-grammars.tree-sitter-pug
          tree-sitter-grammars.tree-sitter-purescript
          tree-sitter-grammars.tree-sitter-python
          tree-sitter-grammars.tree-sitter-ql
          tree-sitter-grammars.tree-sitter-ql-dbscheme
          tree-sitter-grammars.tree-sitter-qmljs
          tree-sitter-grammars.tree-sitter-query
          tree-sitter-grammars.tree-sitter-regex
          tree-sitter-grammars.tree-sitter-readline
          tree-sitter-grammars.tree-sitter-ruby
          tree-sitter-grammars.tree-sitter-rust
          tree-sitter-grammars.tree-sitter-scss
          tree-sitter-grammars.tree-sitter-svelte
          tree-sitter-grammars.tree-sitter-task
          tree-sitter-grammars.tree-sitter-toml
          tree-sitter-grammars.tree-sitter-tsx
          tree-sitter-grammars.tree-sitter-typescript
          tree-sitter-grammars.tree-sitter-typst
          tree-sitter-grammars.tree-sitter-vue
          tree-sitter-grammars.tree-sitter-vala
          tree-sitter-grammars.tree-sitter-vim
          tree-sitter-grammars.tree-sitter-yaml
          tree-sitter-grammars.tree-sitter-xml
          tree-sitter-grammars.tree-sitter-zig
          tree-sitter-grammars.tree-sitter-nim

          nodejs
          gcc
        ]
        ++ cfg.extraPackages;

      plugins = with pkgs.vimPlugins; [
        # Tree-sitter with comprehensive language support
        (nvim-treesitter.withPlugins (plugins:
          with plugins; [
            tree-sitter-c
            tree-sitter-go
            tree-sitter-vue
            tree-sitter-rust
            tree-sitter-vim
            tree-sitter-tsx
            tree-sitter-sql
            tree-sitter-rst
            tree-sitter-nix
            tree-sitter-lua
            tree-sitter-dot
            tree-sitter-css
            tree-sitter-cpp
            tree-sitter-yaml
            tree-sitter-toml
            tree-sitter-scss
            tree-sitter-ruby
            tree-sitter-regex
            tree-sitter-make
            tree-sitter-just
            tree-sitter-json
            tree-sitter-cuda
            tree-sitter-html
            tree-sitter-bash
            tree-sitter-python
            tree-sitter-graphql
            tree-sitter-markdown
            tree-sitter-typescript
            tree-sitter-javascript
            tree-sitter-dockerfile
          ]))
      ];
    };

    # Shell aliases for vi/vim/vimdiff
    programs.bash.shellAliases = mkIf config.programs.bash.enable {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };

    programs.zsh.shellAliases = mkIf config.programs.zsh.enable {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };

    programs.fish.shellAliases = mkIf config.programs.fish.enable {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };
  };
}
