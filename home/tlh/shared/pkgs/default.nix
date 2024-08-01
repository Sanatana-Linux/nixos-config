{
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.attrValues {
    inherit
      (pkgs)
      bfg-repo-cleaner
      gist
      git
      git-backup-go
      git-extras
      git-filter-repo
      git-repo-updater
      git-revise
      git-trim
      gitleaks
      gnome-keyring
      grex
      kbfs
      keybase
      keybase-gui
      keychain
      libgnome-keyring
      pre-commit
      ;
    inherit
      (pkgs.gitAndTools)
      gh
      git-absorb
      git-machete
      gitui
      ;
    inherit
      (pkgs.luaPackages)
      lua
      ;

    pylsp = pkgs.python311.withPackages (p:
      with p; [
        flake8
        python-lsp-server
      ]);
  };
}
