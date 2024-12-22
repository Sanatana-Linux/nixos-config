{
  config,
  pkgs,
  ...
}: let
  extract = import ./extract.nix {inherit pkgs;};
  gita = import ./gita.nix {inherit pkgs;};
  nixfetch = import ./nixfetch.nix {inherit pkgs;};
  notes = import ./notes.nix {inherit pkgs;};
  nux = import ./nux.nix {inherit pkgs;};
  panes = import ./panes.nix {inherit pkgs;};
  shrooms = import ./shrooms.nix {inherit pkgs;};
  updoot = import ./updoot.nix {inherit pkgs;};
  mountbox = import ./mountbox.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [extract nux mountbox notes run shrooms gita nixfetch updoot panes];
}
