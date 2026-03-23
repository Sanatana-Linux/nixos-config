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
        feh
        i3lock-color
        imagemagick
        keychain
        kotatogram-desktop
        adwaita-icon-theme
        adwaita-icon-theme-legacy
        hicolor-icon-theme
        pre-commit
        slurp
        xev
        nodejs
        pnpm
        fzf
        nps
        ;
      pylsp = pkgs.python312.withPackages (p:
        with p; [
          flake8
          python-lsp-server
        ]);
    };
  };
}
