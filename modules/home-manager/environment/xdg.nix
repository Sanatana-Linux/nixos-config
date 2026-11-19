{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.core.xdg;

  browser = ["firefox.desktop"];
  archiveExtractor = ["file-roller.desktop"]; # Define file-roller application
  documentViewer = ["org.gnome.Papers.desktop"]; # GNOME's document viewer (PDF, DjVu, TIFF, comics)
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

    # Documents. Papers is GNOME's document viewer: it covers PDF (including
    # the gz/bz/xz-compressed variants), DjVu, TIFF, Illustrator and the comic
    # book archives. Its desktop file declares exactly this set, so these are
    # the formats it will actually open.
    "application/pdf" = documentViewer;
    "application/x-pdf" = documentViewer;
    "application/x-ext-pdf" = documentViewer;
    "application/x-bzpdf" = documentViewer;
    "application/x-gzpdf" = documentViewer;
    "application/x-xzpdf" = documentViewer;

    "image/vnd.djvu" = documentViewer;
    "image/vnd.djvu+multipage" = documentViewer;
    "application/x-ext-djvu" = documentViewer;
    "application/x-ext-djv" = documentViewer;

    "image/tiff" = documentViewer;
    "application/illustrator" = documentViewer;

    "application/vnd.comicbook+zip" = documentViewer;
    "application/vnd.comicbook-rar" = documentViewer;
    "application/x-cbz" = documentViewer;
    "application/x-cbr" = documentViewer;
    "application/x-cb7" = documentViewer;
    "application/x-cbt" = documentViewer;
    "application/x-ext-cbz" = documentViewer;
    "application/x-ext-cbr" = documentViewer;
    "application/x-ext-cb7" = documentViewer;
    "application/x-ext-cbt" = documentViewer;

    # EPUB/MOBI are deliberately absent: Papers has no EPUB backend, and the
    # config installs no other reader, so those files open via an explicit
    # "Open With" instead of a default that would fail.
  };
in {
  options.modules.core.xdg = {
    enable = mkEnableOption "Enable XDG user directories and associations";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      loupe
      papers
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

    # Ensure application environment variables are set for all applications
    home.sessionVariables = {
      TERMINAL = "kitty";
      BROWSER = "firefox";
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
      FILE_MANAGER = "thunar";
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
        "preferred/WebBrowser" = "firefox-nightly";

        # File manager (Thunar itself)
        "preferred/FileManager" = "thunar";

        # Mail reader
        "preferred/MailReader" = "firefox-nightly"; # Use browser for web mail

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

        # Document viewer
        "preferred/DocumentViewer" = "org.gnome.Papers";
      };

      # Additional XFCE mime associations for better integration
      "mimeapps" = {
        # Web browser associations
        "default/text/html" = "firefox-nightly.desktop";
        "default/application/xhtml+xml" = "firefox-nightly.desktop";
        "default/x-scheme-handler/http" = "firefox-nightly.desktop";
        "default/x-scheme-handler/https" = "firefox-nightly.desktop";
        "default/x-scheme-handler/ftp" = "firefox-nightly.desktop";

        # Terminal
        "default/x-scheme-handler/terminal" = "kitty.desktop";

        # Text files
        "default/text/plain" = "nvim.desktop";
        "default/application/x-shellscript" = "nvim.desktop";
        "default/text/x-python" = "nvim.desktop";
        "default/text/x-c" = "nvim.desktop";
        "default/text/x-c++" = "nvim.desktop";
        "default/text/markdown" = "nvim.desktop";
        "default/application/json" = "firefox-nightly.desktop";

        # Media files
        "default/video/*" = "vlc.desktop";
        "default/audio/*" = "vlc.desktop";
        "default/image/*" = "org.gnome.Loupe.desktop";

        # Documents
        "default/application/pdf" = "org.gnome.Papers.desktop";
        "default/application/x-pdf" = "org.gnome.Papers.desktop";
        "default/image/vnd.djvu" = "org.gnome.Papers.desktop";
        "default/image/tiff" = "org.gnome.Papers.desktop";
        "default/application/vnd.comicbook+zip" = "org.gnome.Papers.desktop";
        "default/application/x-cbz" = "org.gnome.Papers.desktop";
        "default/application/x-cbr" = "org.gnome.Papers.desktop";

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
        ];
      };

      mimeApps = {
        enable = true;
        associations.added = associations;
        defaultApplications = associations;
      };

      # Desktop entry overrides for optimal libadwaita app behavior.
      # No entry is needed for the document viewer: Papers ships its own
      # org.gnome.Papers.desktop with the right MimeType list, and being
      # libadwaita it follows the color-scheme Stylix already sets. Overriding
      # it would only shadow the packaged Exec and MIME declarations.
      desktopEntries = {};
    };
  };
}
