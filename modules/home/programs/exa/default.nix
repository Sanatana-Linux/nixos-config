{ config, ... }:

{
  programs.exa = {
    enable = true;
    # controlled in zsh for now  
    enableAliases = true;
  };
}
