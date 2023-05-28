{
  pkgs,
  lib,
  config,
  ...
}: let
  # calls the packages specified in the directory and adds them to home.packages (cleaner then home.files imho)
  
  gita = import ./gita.nix {inherit pkgs;};
  nux = import ./nux.nix {inherit pkgs;};
  preview = import ./preview.nix {inherit pkgs;};
  run = import ./run.nix {inherit pkgs;};
  updoot = import ./updoot.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [ gita nux preview run updoot];
}
