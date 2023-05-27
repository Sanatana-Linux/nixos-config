{
  pkgs,
  lib,
  config,
  ...
}: let
  # calls the packages specified in the directory and adds them to home.packages (cleaner then home.files imho)
  extract = import ./extract {inherit pkgs;};
  gita = import ./gita {inherit pkgs;};
  nux = import ./nux {inherit pkgs;};
  preview = import ./preview {inherit pkgs;};
  run = import ./run {inherit pkgs;};
  updoot = import ./updoot {inherit pkgs;};
  vfio = import ./vfio {inherit pkgs;};
in {
  home.packages = with pkgs; [extract gita nux preview run updoot vfio];
}
