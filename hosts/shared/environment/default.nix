{
  lib,
  pkgs,
  ...
}: {
  imports = [./variables.nix];
  programs.zsh.enable = true;
  environment = with pkgs; {
    shells = [bash zsh];
    pathsToLink = ["/share/bash" "/share/zsh"];
  };
  users.defaultUserShell = pkgs.zsh;
}
