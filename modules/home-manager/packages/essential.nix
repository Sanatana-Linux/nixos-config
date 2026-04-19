{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.packages.essential;
in {
  options.modules.packages.essential = {
    enable = mkEnableOption "essential user packages";
  };

  config = mkIf cfg.enable {
    home.packages = lib.attrValues {
      inherit
        (pkgs)
        thunderbird-bin
        imagemagick
        keychain
        adwaita-icon-theme
        adwaita-icon-theme-legacy
        hicolor-icon-theme
        numix-icon-theme-circle # for honor theme
        pre-commit
        slurp
        xev
        nodejs
        pnpm
        fzf
        nps
        rofi
        ;
      pylsp = pkgs.python314.withPackages (p:
        with p; [
          flake8
          python-lsp-server
        ]);
    };
  };
}
