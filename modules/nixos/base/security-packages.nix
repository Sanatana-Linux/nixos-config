{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.packages.security;
in {
  options.modules.base.packages.security = {
    enable = mkEnableOption "security-related packages";

    bitwarden = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Bitwarden password manager (desktop)";
      };
    };

    ghorg = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "GitHub organization cloning tool";
      };
    };

    kryptor = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "File encryption CLI tool";
      };
    };

    nmap = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Network discovery and security auditing";
      };
    };

    openssl = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "OpenSSL development headers";
      };
    };

    tor = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Tor anonymity network (CLI + browser)";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      []
      ++ optional cfg.bitwarden.enable bitwarden-desktop
      ++ optional cfg.ghorg.enable ghorg
      ++ optional cfg.kryptor.enable kryptor
      ++ optional cfg.nmap.enable nmap
      ++ optional cfg.openssl.enable openssl.dev
      ++ optional cfg.tor.enable tor
      ++ optional cfg.tor.enable tor-browser;
  };
}
