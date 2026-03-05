{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.packages.network = {
    enable = mkEnableOption "Network utilities and tools";

    gitTools = mkEnableOption "Git-related network tools" // {default = true;};
    wirelessTools = mkEnableOption "Wireless network configuration tools" // {default = true;};
    downloadTools = mkEnableOption "Download and sync utilities" // {default = true;};
    compressionLibs = mkEnableOption "Network compression libraries" // {default = true;};
  };

  config = mkIf config.modules.packages.network.enable {
    environment.systemPackages = with pkgs;
      []
      # Git and GitHub tools
      ++ optionals config.modules.packages.network.gitTools [
        gh # GitHub CLI tool
        libgit2 # Portable C implementation of Git core methods
        libgit2-glib # GLib wrapper for libgit2
      ]
      # Wireless tools
      ++ optionals config.modules.packages.network.wirelessTools [
        iw # Wireless configuration utility
        wirelesstools # Wireless network configuration tools
      ]
      # Download and sync tools
      ++ optionals config.modules.packages.network.downloadTools [
        rclone # Command-line program to sync files to cloud storage
        yt-dlp # Feature-rich command-line audio/video downloader
      ]
      # Compression libraries
      ++ optionals config.modules.packages.network.compressionLibs [
        zlib # Compression library
      ];
  };
}
