{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.security.packages;
in {
  options.modules.security.packages = {
    enable = mkEnableOption "security-related packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bitwarden-desktop
      ghorg
      nmap
      openssl.dev
      tor
      tor-browser
    ];
  };
}
