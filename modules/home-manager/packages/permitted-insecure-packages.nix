{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.packages.permitted-insecure-packages;
in {
  options.modules.packages.permitted-insecure-packages = {
    enable = mkEnableOption "permitted insecure packages";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = [
      "pnpm-10.29.2"
      "ventoy-1.1.12"
      "electron-39.8.10"
    ];
  };
}
