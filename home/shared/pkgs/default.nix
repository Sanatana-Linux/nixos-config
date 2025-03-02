{
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.attrValues {
    inherit
      (pkgs)
      thunderbird-bin
      feh
      i3lock-color
      imagemagick
      keychain
      adwaita-icon-theme
      adwaita-icon-theme-legacy
      hicolor-icon-theme
      pre-commit
      slurp
      ;
    inherit
      (pkgs.xorg)
      xev
      ;
    pylsp = pkgs.python312.withPackages (p:
      with p; [
        flake8
        python-lsp-server
      ]);
  };
}
