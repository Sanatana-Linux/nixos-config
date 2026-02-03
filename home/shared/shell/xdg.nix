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
  gthumb = ["applications/org.gnome.gThumb.desktop"];
  neovim = ["nvim.desktop"]; # Neovim for text files

  associations = {
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "text/html" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;

    "audio/*" = vlc;
    "video/*" = vlc;
    "image/*" = gthumb;
    "image/svg+xml" = gthumb;

    "application/json" = browser;

    "x-scheme-handler/discord" = ["discord.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];

    # Text files
    "text/plain" = neovim;
    "text/x-script" = neovim;
    "application/x-shellscript" = neovim;
    "text/x-python" = neovim;
    "text/x-java" = neovim;
    "text/x-c" = neovim;
    "text/x-c++" = neovim;
    "text/x-markdown" = neovim;
    "text/markdown" = neovim;
    "application/toml" = neovim;
    "application/yaml" = neovim;
    "application/x-yaml" = neovim;
    "text/x-lua" = neovim;
    "text/x-rust" = neovim;
    "application/javascript" = neovim;
    "text/javascript" = neovim;

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

    # Ebook formats... Sorry but firefox just does it better!
    "application/epub+zip" = browser;
    "application/epub" = browser; # .epub
    "application/pdf" = browser;
    "application/x-pdf" = browser;
  };
in {
  home.packages = with pkgs; [
    xdg-utils
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    xdg-launch
    xdg-user-dirs
    xdg-user-dirs-gtk
    xdg-utils
    xdg-utils-cxx
    xdgmenumaker
  ];
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    portal = {
      enable = true;
      config.common.default = "*";
    xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
        xdg-desktop-portal-xapp
      ];
    };

    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
