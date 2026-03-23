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
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withNodeJs = cfg.withNodeJs;
      withRuby = cfg.withRuby;

      extraPackages = with pkgs;
        [
          # Core dependencies
          pynvim
          yarn
          fswatch
          cmake
          imagemagick

          # Tree-sitter dependencies
          tree-sitter
          nodejs
          gcc
        ]
        ++ cfg.extraPackages;

      # Lua packages
      extraLuaPackages = with pkgs.luaPackages; [
        magick
      ];

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
