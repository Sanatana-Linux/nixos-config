{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.fastfetch;
in {
  options.modules.programs.fastfetch = {
    enable = mkEnableOption "Fastfetch system information tool";
  };

  config = mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = "${config.home.homeDirectory}/.config/fastfetch/nix.png";

        display = {
          separator = " ";
          key = {
            width = 15;
          };
        };

        modules = [
          "kernel"
          "host"
          "uptime"
          "cpu"
          "gpu"
          "memory"
          "disk"
          "wm"
        ];
      };
    };

    # Copy custom Nix logo to user's fastfetch config directory
    home.file.".config/fastfetch/nix.png".source = ./fastfetch/nix.png;
  };
}
