{ pkgs, lib, ... }: {
  home.username = "tlh";
  home.homeDirectory = "/home/tlh";
  home.stateVersion = "24.11";

  programs.zsh.enable = true;
  programs.zsh.shellAliases = {
    ll = "ls -lh";
    la = "ls -lah";
    ls = "ls --color=auto";
  };

  programs.git.enable = true;
  programs.git.settings.user.name = "Thomas Leon Highbaugh";
  programs.git.settings.user.email = "tlh@example.com";

  home.file.".config/zsh/.zshrc".text = ''
    export EDITOR=nvim
    export PAGER=less
  '';
}
