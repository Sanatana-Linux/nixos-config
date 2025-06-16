{
  config,
  pkgs,
  ...
}: let
  extract = import ./extract.nix {inherit pkgs;};
  gita = import ./gita.nix {inherit pkgs;};
  nixfetch = import ./nixfetch.nix {inherit pkgs;};
  nix-search-tv-integration = import ./nix-search-tv-integration.nix {inherit pkgs;};
  notes = import ./notes.nix {inherit pkgs;};
  om = import ./om.nix {inherit pkgs;};
  panes = import ./panes.nix {inherit pkgs;};
  screenlocked = import ./screenlocked.nix {inherit pkgs;};
  shrooms = import ./shrooms.nix {inherit pkgs;};
  updoot = import ./updoot.nix {inherit pkgs;};
  mountbox = import ./mountbox.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [extract om mountbox notes screenlocked run shrooms gita nix-search-tv-integration nixfetch updoot panes];
}
