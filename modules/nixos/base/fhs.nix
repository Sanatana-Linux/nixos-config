{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.fhs;
in {
  options.modules.base.fhs = {
    enable = mkEnableOption "FHS compatibility shell for running non-Nix binaries";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.callPackage ({
        buildFHSUserEnv,
        zlib,
      }:
        buildFHSUserEnv {
          name = "fhs-shell";
          targetPkgs = pkgs: [zlib];
          profile = ''
            export NIX_SHELL="fhs"
          '';
        }) {})
    ];
  };
}
