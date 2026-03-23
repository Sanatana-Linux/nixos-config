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
    pathsToLink = [
      "/share/bash"
      "/share/zsh"
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];
  };
  users.defaultUserShell = pkgs.zsh;
}
