{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.programs.vim;
in {
  options.tlh.programs.vim.enable = mkEnableOption "Setup neovim";

  # Clear all caches
  # rm -rf ~/.config/nvim/plugin/packer_compiled.lua ~/.cache/nvim/ ~/.local/share/nvim/site/
  imports = [
    ../nvchad
  ];

  config = mkIf cfg.enable {
    # xdg = {
    #   enable = true;
    #   configFile = {
    #     nvim_lua_config = {
    #       target = "nvim/lua/config";
    #       source = ./lua/config;
    #     };
    #   };
    # };

    programs.neovim.nvchad = {
      enable = true;
      extraLazyPlugins = with pkgs.vimPlugins; [
        csv-vim
        diffview-nvim
      ];
    };

    programs.neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;

      viAlias = true;
      vimAlias = true;
      withPython3 = true;

      extraPackages = with pkgs; [
        ansible-language-server
        nixpkgs-fmt
        tree-sitter
        yaml-language-server
        hologram
      ];

      plugins = with pkgs.vimPlugins;
        [
          ansible-vim
          mason-nvim
          mason-lspconfig-nvim
          vim-better-whitespace
          vim-nix
        ]
        ++ lib.optionals (config.programs.neovim.nvchad.enable) [
          (nvim-treesitter.withPlugins (plugins: with plugins; [nix yaml]))
        ];
    };
  };
}
