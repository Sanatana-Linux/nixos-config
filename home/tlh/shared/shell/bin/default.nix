{
  pkgs,
  lib,
  config,
  ...
}: let
  # calls the packages specified in the directory and adds them to home.packages (cleaner then home.files imho)
  extract = import ./extract.nix {inherit pkgs;};
  gita = import ./gita.nix {inherit pkgs;};
  nux = import ./nux.nix {inherit pkgs;};
  preview = import ./preview.nix {inherit pkgs;};
  run = import ./run.nix {inherit pkgs;};
  updoot = import ./updoot.nix {inherit pkgs;};
  vfio = import ./vfio.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [extract gita nux preview run updoot vfio];
}
