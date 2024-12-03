{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  browser = ["firefox.desktop"];
  fileRoller = ["file-roller.desktop"]; # Define file-roller application
  zathura = ["org.pwmt.zathura.desktop"]; # Define zathura application
  vlc = ["vlc.desktop"]; # VLC application
  imv = ["imv-dir.desktop"];

  associations = {
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "text/html" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/chrome" = ["google-chrome.desktop"];
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;

    "audio/*" = vlc;
    "video/*" = vlc;
    "image/*" = imv;

    "application/json" = browser;

    "x-scheme-handler/discord" = ["discord.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];

    # Archive Files
    "application/x-7z-compressed" = fileRoller;
    "application/x-ar" = fileRoller;
    "application/x-bzip" = fileRoller;
    "application/x-bzip2" = fileRoller;
    "application/gzip" = fileRoller;
    "application/x-lzip" = fileRoller;
    "application/x-lzma" = fileRoller;
    "application/x-lzma-compressed-tar" = fileRoller;
    "application/x-rar" = fileRoller;
    "application/x-rar-compressed" = fileRoller;
    "application/x-tar" = fileRoller;
    "application/x-tarz" = fileRoller;
    "application/x-xz" = fileRoller;
    "application/zip" = fileRoller;
    "application/x-zip-compressed" = fileRoller;

    # Ebook formats
    "application/epub+zip" = zathura;
    "application/x-cbz" = zathura; # Comic book archive
    "application/pdf" = zathura;
    "application/x-cbr" = zathura; # Comic book archive
    "application/x-pdf" = zathura; # Although you already have a PDF rule, using zathura here is consistent.
    "application/djvu" = zathura;
    "application/fb2" = zathura;
    "application/mobipocket-ebook" = zathura; # .mobi
  };
in {
  home.packages = [pkgs.xdg-utils];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
