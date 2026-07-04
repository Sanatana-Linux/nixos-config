{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.packages;
in {
  imports = [
    ./archives.nix
    ./core.nix
    ./development.nix
    ./gui.nix
    ./system.nix
  ];

  options.modules.base.packages = {
    # ══════════════════════════════════════════════════════════════════════════
    # PYTHON
    # ══════════════════════════════════════════════════════════════════════════
    python = {
      enable = mkEnableOption "Python development environment";
      development = mkEnableOption "Python development tools";
      webDevelopment = mkEnableOption "Python web development packages";
      dataProcessing = mkEnableOption "Data processing libraries";
      systemIntegration = mkEnableOption "System integration packages";
      graphics = mkEnableOption "Graphics and GUI packages";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # SHELL
    # ══════════════════════════════════════════════════════════════════════════
    shell = {
      enable = mkEnableOption "Shell utilities";
    };
  };
}
