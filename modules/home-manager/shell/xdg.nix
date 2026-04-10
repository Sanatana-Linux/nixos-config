{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell.xdg;

  browser = ["firefox.desktop"];
  archiveExtractor = ["file-roller.desktop"]; # Define file-roller application
  pdfViewer = ["foliate.desktop"]; # Define pdfViewer application
  videoPlayer = ["vlc.desktop"]; # VLC application
  imageViewer = ["org.gnome.Loupe.desktop"];
  neovim = ["nvim.desktop"]; # Neovim for text files
  terminal = ["kitty.desktop"]; # Kitty terminal

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

    "audio/*" = videoPlayer;
    "video/*" = videoPlayer;
    "image/*" = imageViewer;
    "image/svg+xml" = imageViewer;
    "application/json" = browser;

    "x-scheme-handler/discord" = ["discord.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];

    # Terminal
    "x-scheme-handler/terminal" = terminal;

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
    "application/x-7z-compressed" = archiveExtractor;
    "application/x-ar" = archiveExtractor;
    "application/x-bzip" = archiveExtractor;
    "application/x-bzip2" = archiveExtractor;
    "application/gzip" = archiveExtractor;
    "application/x-lzip" = archiveExtractor;
    "application/x-lzma" = archiveExtractor;
    "application/x-lzma-compressed-tar" = archiveExtractor;
    "application/x-rar" = archiveExtractor;
    "application/x-rar-compressed" = archiveExtractor;
    "application/x-tar" = archiveExtractor;
    "application/x-tarz" = archiveExtractor;
    "application/x-xz" = archiveExtractor;
    "application/zip" = archiveExtractor;
    "application/x-zip-compressed" = archiveExtractor;

    # Ebook formats... Sorry but firefox just does it better!
    "application/epub+zip" = pdfViewer;
    "application/epub" = pdfViewer; # .epub
    "application/pdf" = pdfViewer;
    "application/x-pdf" = pdfViewer;
    "application/mobi" = pdfViewer;
  };
in {
  options.modules.shell.xdg = {
    enable = mkEnableOption "Enable XDG user directories and associations";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      loupe
      foliate
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
    
    # Ensure terminal environment variable is set for all applications
    home.sessionVariables = {
      TERMINAL = "kitty";
    };
    
    # XFCE configuration for preferred applications (needed for Thunar integration)
    xfconf.settings = {
      "xfce4-session" = {
        "general/TerminalEmulator" = "kitty";
      };
      "exo" = {
        # Terminal applications
        "preferred/TerminalEmulator" = "kitty";
        
        # Web browser
        "preferred/WebBrowser" = "firefox";
        
        # File manager (Thunar itself)
        "preferred/FileManager" = "thunar";
        
        # Mail reader
        "preferred/MailReader" = "firefox"; # Use browser for web mail
        
        # Text editor
        "preferred/TextEditor" = "nvim";
        
        # Image viewer
        "preferred/ImageViewer" = "org.gnome.Loupe";
        
        # Video player
        "preferred/VideoPlayer" = "vlc";
        
        # Music player
        "preferred/MusicPlayer" = "vlc";
        
        # Archive manager
        "preferred/ArchiveManager" = "file-roller";
        
        # PDF viewer
        "preferred/DocumentViewer" = "foliate";
      };
      
      # Additional XFCE mime associations for better integration
      "mimeapps" = {
        # Web browser associations
        "default/text/html" = "firefox.desktop";
        "default/application/xhtml+xml" = "firefox.desktop";
        "default/x-scheme-handler/http" = "firefox.desktop";
        "default/x-scheme-handler/https" = "firefox.desktop";
        "default/x-scheme-handler/ftp" = "firefox.desktop";
        
        # Terminal
        "default/x-scheme-handler/terminal" = "kitty.desktop";
        
        # Text files
        "default/text/plain" = "nvim.desktop";
        "default/application/x-shellscript" = "nvim.desktop";
        "default/text/x-python" = "nvim.desktop";
        "default/text/x-c" = "nvim.desktop";
        "default/text/x-c++" = "nvim.desktop";
        "default/text/markdown" = "nvim.desktop";
        "default/application/json" = "firefox.desktop";
        
        # Media files
        "default/video/*" = "vlc.desktop";
        "default/audio/*" = "vlc.desktop";
        "default/image/*" = "org.gnome.Loupe.desktop";
        
        # Documents
        "default/application/pdf" = "foliate.desktop";
        "default/application/epub+zip" = "foliate.desktop";
        
        # Archives
        "default/application/zip" = "file-roller.desktop";
        "default/application/x-tar" = "file-roller.desktop";
        "default/application/x-rar" = "file-roller.desktop";
        "default/application/x-7z-compressed" = "file-roller.desktop";
      };
    };
    
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = true;
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
  };
}
