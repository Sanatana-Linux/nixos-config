{
  config,
  pkgs,
  ...
}: let
  fhs = import ./fhs.nix {inherit pkgs;};
  gita = import ./gita.nix {inherit pkgs;};
  nixfetch = import ./nixfetch.nix {inherit pkgs;};
  om = import ./om.nix {inherit pkgs;};
  ns = pkgs.writeShellScriptBin "ns" (builtins.readFile ./nixpkgs.sh);
  panes = import ./panes.nix {inherit pkgs;};
  shrooms = import ./shrooms.nix {inherit pkgs;};
  mountbox = import ./mountbox.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [om mountbox fhs run shrooms gita ns nixfetch panes];
}
