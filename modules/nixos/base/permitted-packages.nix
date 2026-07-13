{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.permittedPackages;
in {
  options.modules.base.permittedPackages = {
    enable = mkEnableOption "Configure permitted insecure packages";

    packages = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of additional insecure packages to permit";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages =
        [
          "pnpm-10.29.2"
          "ventoy-1.1.12"
          "electron-39.8.10"
        ]
        ++ cfg.packages;
    };
  };
}
