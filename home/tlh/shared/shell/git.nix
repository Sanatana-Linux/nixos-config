{
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.attrValues {
    inherit
      (pkgs)
      bfg-repo-cleaner
      colordiff
      gist
      git-filter-repo
      pre-commit
      subversion
      ;

    inherit
      (pkgs.gitAndTools)
      git-absorb
      gitui
      git-machete
      gh
      ;
  };

  programs.git = {
    enable = true;
    userName = "Thomas Leon Highbaugh";
    userEmail = "thighbaugh@zoho.com";
  };
}
