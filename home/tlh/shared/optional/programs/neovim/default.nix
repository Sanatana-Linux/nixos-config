{
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  # Sure its more elegant, but I can't work on the repo and commit my work, so its useless!
  #xdg.configFile."nvim".source = "${inputs.nvim-forge}";

  # Enable AwesomeWM Configuration
  home.activation.installNeoVimConfig = ''
    if [ ! -d "$HOME/.config/nvim" ]; then
     ${pkgs.git}/bin/git clone https://github.com/Thomashighbaugh/nvim-forge "$HOME/.config/nvim"
      chmod -R +w "$HOME/.config/nvim"
    fi
  '';
}
