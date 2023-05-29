{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./variables.nix
  ];

  environment = with pkgs; {
    binsh = lib.getExe bash;
    shells = [zsh];
    pathsToLink = ["/share/zsh"];

    loginShellInit = ''
      eval $(ssh-agent)
    '';
  };
}
