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
      "nodejs-20.20.2"
      "nodejs-slim-20.20.2"
      "ventoy-1.1.12"
    ];
  };
}
