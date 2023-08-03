{
  lib,
  pkgs,
  ...
}: {
  imports = [./variables.nix];

  environment = with pkgs; {
    
    shells = [zsh];
    pathsToLink = ["/share/zsh"];
  };
}
