{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.packages.home;
in {
  options.modules.packages.home = {
    enable = mkEnableOption "Additional home packages for desktop and development";
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
        ;
      inherit
        (pkgs)
        xev
        ;
      pylsp = pkgs.python312.withPackages (p:
        with p; [
          flake8
          python-lsp-server
        ]);
    };
  };
}
