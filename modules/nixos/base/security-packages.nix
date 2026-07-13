{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.base.packages.security.enable = mkOption {
    type = types.bool;
    default = true;
    description = "Security-related packages (nmap, bitwarden, tor, etc.)";
  };

  config = mkIf config.modules.base.packages.security.enable {
    environment.systemPackages = with pkgs; [
      aircrack-ng # Wireless network security tool
      bitwarden-desktop # Password manager
      ghorg # GitHub organization cloning tool
      go-exploitdb # Exploit database search tool
      kryptor # File encryption CLI tool
      nmap # Network discovery and security auditing
      openssl.dev # OpenSSL development headers
      tor # Tor anonymity network
      tor-browser # Tor Browser
    ];
  };
}
