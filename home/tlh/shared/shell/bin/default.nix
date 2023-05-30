{
  config,
  pkgs,
  ...
}: let
  extract = import ./extract.nix {inherit pkgs;};
  gita = import ./gita.nix {inherit pkgs;};
  nixfetch = import ./nixfetch.nix {inherit pkgs;};
  nux = import ./nux.nix {inherit pkgs;};
  panes = import ./panes.nix {inherit pkgs;};
  updoot = import ./updoot.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [extract nux run gita nixfetch updoot panes];
}
