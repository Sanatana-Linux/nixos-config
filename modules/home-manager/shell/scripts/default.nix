{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.shell.scripts;
  om = import ./om.nix {inherit pkgs;};
  scripts = import ./scripts.nix {inherit pkgs;};
in {
  options.modules.shell.scripts = {
    enable = mkEnableOption "Enable custom shell scripts";
  };

  config = mkIf cfg.enable {
    home.packages = [om] ++ scripts;
  };
}
