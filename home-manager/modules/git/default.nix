{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.programs.git;
in {
  options.tlh.programs.git.enable = mkEnableOption "enable git";

  config = mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        # Gitignore ist long so import that
        lfs.enable = true;
        extraConfig = {pull.rebase = false;};
        userEmail = "thighbaugh@zoho.com";
        userName = "Thomas Highbaugh";
      };
    };
    home.packages = [pkgs.pre-commit];
  };
}
