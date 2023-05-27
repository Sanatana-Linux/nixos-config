{
  pkgs,
  inputs,
  outputs,
  lib,
}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim".source = "${inputs.nvim-forge}";
}
