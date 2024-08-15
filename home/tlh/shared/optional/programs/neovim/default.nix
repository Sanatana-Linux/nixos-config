{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  home.activation.installNeoVimConfig = ''
    if [ ! -d "$HOME/.config/nvim" ]; then
     ${pkgs.git}/bin/git clone https://github.com/Thomashighbaugh/nvim-forge "$HOME/.config/nvim"
      chmod -R +w "$HOME/.config/nvim"
    fi
  '';
}
