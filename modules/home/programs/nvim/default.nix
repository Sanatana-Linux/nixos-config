{
  pkgs,
  nvim-forge,
}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim".source = "${nvim-forge}";
}
