{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  # Import the aichat configuration and roles at top level
  imports = [
    ./aichat/config.nix
    ./aichat/roles.nix
  ];

  options.modules.programs.aichat = {
    enable = mkEnableOption "aichat AI assistant with multiple provider support and specialized roles";
  };

  config = mkIf config.modules.programs.aichat.enable {
    home.packages = with pkgs; [
      aichat
    ];
  };
}
