{
  lib,
  pkgs,
  ...
}: {
  imports = [./variables.nix];

  environment = with pkgs; {
    binsh = lib.getExe bash;
    shells = [zsh];
    pathsToLink = ["/share/zsh"];

    loginShellInit = ''
      ZSH_AUTOSUGGEST_USE_ASYNC="true"
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor regexp root line)
      ZSH_HIGHLIGHT_MAXLENGTH=512
      any-nix-shell zsh --info-right | source /dev/stdin
      eval $(ssh-agent)
      zsh
    '';
  };
}
