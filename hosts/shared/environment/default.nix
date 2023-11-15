{
  lib,
  pkgs,
  ...
}: {
  imports = [./variables.nix];

  environment = with pkgs; {
    shells = [bash zsh];
    pathsToLink = ["/share/bash" "/share/zsh"];
  };
   users.defaultUserShell = pkgs.zsh;
}
