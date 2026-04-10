{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.shell.scripts;
  gita = import ./gita.nix {inherit pkgs;};
  nixfetch = import ./nixfetch.nix {inherit pkgs;};
  om = import ./om.nix {inherit pkgs;};
  ns = pkgs.writeShellScriptBin "ns" (builtins.readFile ./nixpkgs.sh);
  icon-viewer = import ./icon-viewer.nix {inherit pkgs;};
  panes = import ./panes.nix {inherit pkgs;};
  shrooms = import ./shrooms.nix {inherit pkgs;};
  mountbox = import ./mountbox.nix {inherit pkgs;};
  iso-open = import ./iso-open.nix {inherit pkgs;};
in {
  options.modules.shell.scripts = {
    enable = mkEnableOption "Enable custom shell scripts";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [om mountbox run shrooms icon-viewer gita ns nixfetch panes nps iso-open];
  };
}
