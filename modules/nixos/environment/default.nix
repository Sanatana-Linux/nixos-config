{
  lib,
  pkgs,
  ...
}: {
  imports = [./variables.nix];

  # execute shebangs that assume hardcoded shell paths

  programs.zsh.enable = true;
  environment = with pkgs; {
    shells = [bash zsh];
    pathsToLink = ["/share/bash" "/share/zsh"];
  };
  users.defaultUserShell = pkgs.zsh;
}
