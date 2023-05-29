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
  updoot = import ./updoot.nix {inherit pkgs;};
  extract = import ./extract.nix {inherit pkgs;};
  panes = import ./panes.nix {inherit pkgs;};
  fetch = import ./nixfetch.nix {inherit pkgs;};

in {
  home.packages = with pkgs; [ gita nux preview updoot extract panes fetch ];
}
