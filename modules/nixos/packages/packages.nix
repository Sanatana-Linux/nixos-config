{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.packages;
in {
  options.modules.packages = {
    # ══════════════════════════════════════════════════════════════════════════
    # ARCHIVES
    # ══════════════════════════════════════════════════════════════════════════
    archives = {
      enable = mkEnableOption "Archive and compression utilities";
      basicFormats = mkEnableOption "Basic archive formats (tar, zip, cpio)";
      modernCompression = mkEnableOption "Modern compression tools (zstd, lz4, xz)";
      parallelTools = mkEnableOption "Parallel compression utilities";
      specializedFormats = mkEnableOption "Specialized formats (7z, rar, jar)";
      integrationLibs = mkEnableOption "Archive integration libraries";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # CORE
    # ══════════════════════════════════════════════════════════════════════════
    core = {
      enable = mkEnableOption "Core system utilities";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # DEVELOPMENT
    # ══════════════════════════════════════════════════════════════════════════
    development = {
      enable = mkEnableOption "Development tools and utilities";
      minimal = mkEnableOption "Minimal development tools for live/ISO environments";
      linters = mkEnableOption "Code linters and formatters";
      versionControl = mkEnableOption "Version control tools";
      buildTools = mkEnableOption "Build system tools";
      runtimeLanguages = mkEnableOption "Runtime language environments";
      luaEcosystem = mkEnableOption "Lua language ecosystem";
      rustEcosystem = mkEnableOption "Rust language ecosystem";
      androidDevelopment = mkEnableOption "Android development tools";
      nixUtilities = mkEnableOption "Nix-specific utilities";
      systemCompilers = mkEnableOption "System compilers (gcc, clang)";
      webDevelopment = mkEnableOption "Web development tools";
      databases = mkEnableOption "Database tools";
      editors = mkEnableOption "Code editors and IDE tools";
      treeSitterGrammars = mkEnableOption "Tree-sitter grammar files";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # FONTS
    # ══════════════════════════════════════════════════════════════════════════
    fonts = {
      enable = mkEnableOption "Font packages and fontconfig settings";
      nerdFonts = mkEnableOption "Nerd Font variants";
      iconFonts = mkEnableOption "Icon fonts for UI";
      systemFonts = mkEnableOption "System and display fonts";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # GUI
    # ══════════════════════════════════════════════════════════════════════════
    gui = {
      enable = mkEnableOption "GUI applications and utilities";
      minimal = mkEnableOption "Minimal GUI for live/ISO environments";
      applicationLauncher = mkEnableOption "Application launcher tools";
      mediaTools = mkEnableOption "Media management tools";
      developmentTools = mkEnableOption "GUI development tools";
      windowManagement = mkEnableOption "Window management utilities";
      messaging = mkEnableOption "Messaging applications";
      extraPackages = mkEnableOption "Extra GUI packages";

      libs = {
        enable = mkEnableOption "GUI libraries";
        coreGraphics = mkEnableOption "Core graphics libraries (cairo, pango)";
        gobjectSupport = mkEnableOption "GObject introspection support";
        desktopIntegration = mkEnableOption "Desktop integration libraries";
        xfceSupport = mkEnableOption "XFCE library support";
        audioTerminal = mkEnableOption "Audio and terminal libraries";
        pythonBindings = mkEnableOption "Python GUI bindings";
        rubyBindings = mkEnableOption "Ruby GUI bindings";
        fontSupport = mkEnableOption "Font support libraries";
      };
    };

    # ══════════════════════════════════════════════════════════════════════════
    # MULTIMEDIA
    # ══════════════════════════════════════════════════════════════════════════
    multimedia = {
      enable = mkEnableOption "Multimedia packages for audio, video, and image processing";
      minimal = mkEnableOption "Minimal multimedia for live/ISO environments";
      videoTools = mkEnableOption "Video processing and editing tools";
      imageTools = mkEnableOption "Image processing and editing tools";
      streamingTools = mkEnableOption "Streaming and recording tools";
      gstreamerPlugins = mkEnableOption "Complete GStreamer plugin ecosystem";
      creators = mkEnableOption "Content creation tools (gimp, inkscape)";
      stableVideoEditors = mkEnableOption "Stable video editors (olive, shotcut, openshot)";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # NETWORK
    # ══════════════════════════════════════════════════════════════════════════
    network = {
      enable = mkEnableOption "Network utilities";
      gitTools = mkEnableOption "Git network tools";
      wirelessTools = mkEnableOption "Wireless network tools";
      downloadTools = mkEnableOption "Download utilities";
      compressionLibs = mkEnableOption "Network compression libraries";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # PYTHON
    # ══════════════════════════════════════════════════════════════════════════
    python = {
      enable = mkEnableOption "Python development environment";
      development = mkEnableOption "Python development tools";
      webDevelopment = mkEnableOption "Python web development packages";
      dataProcessing = mkEnableOption "Data processing libraries";
      systemIntegration = mkEnableOption "System integration packages";
      graphics = mkEnableOption "Graphics and GUI packages";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # SHELL
    # ══════════════════════════════════════════════════════════════════════════
    shell = {
      enable = mkEnableOption "Shell utilities and plugins";
      modernTools = mkEnableOption "Modern shell tools (bat, eza, fd)";
      systemUtils = mkEnableOption "System utility commands";
      fileManagement = mkEnableOption "File management tools";
      downloadTools = mkEnableOption "Download utilities";
      zshPlugins = mkEnableOption "ZSH plugins and enhancements";
      inputSupport = mkEnableOption "Input device support";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # SYSTEM
    # ══════════════════════════════════════════════════════════════════════════
    system = {
      enable = mkEnableOption "System utilities";
      minimal = mkEnableOption "Minimal system utilities for live/ISO";
      filesystem = mkEnableOption "Filesystem utilities";
      hardware = mkEnableOption "Hardware monitoring tools";
      network = mkEnableOption "Network system utilities";
      performance = mkEnableOption "Performance monitoring tools";
      desktop = mkEnableOption "Desktop integration utilities";
      multimedia = mkEnableOption "System multimedia tools";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # X11
    # ══════════════════════════════════════════════════════════════════════════
    x11 = {
      enable = mkEnableOption "X11 display server utilities and tools";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # WAYLAND
    # ══════════════════════════════════════════════════════════════════════════
    wayland = {
      enable = mkEnableOption "Wayland display server utilities and tools";
    };
  };

  config = mkMerge [
    # ════════════════════════════════════════════════════════════════════════
    # ARCHIVES CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.archives.enable {
      environment.systemPackages = with pkgs;
      # Basic archive formats
        optionals cfg.archives.basicFormats [
          gnutar # GNU tar - standard archive utility
          zip # PKZIP archive format
          minizip-ng # Zip library (ng version)
          unzip # PKZIP extraction
          cpio # Copy-in/copy-out archive format
        ]
        # Modern compression tools
        ++ optionals cfg.archives.modernCompression [
          zstd # Zstandard compression - fast with good ratio
          lz4 # Extremely fast compression
          xz # LZMA/XZ compression - high ratio
          zlib-ng # Modern zlib replacement
        ]
        # Parallel compression utilities
        ++ optionals cfg.archives.parallelTools [
          crabz # Parallel gzip/zstd
          pigz # Parallel gzip
          pixz # Parallel xz with indexing
          plzip # Parallel lzip
          pxz # Parallel xz
        ]
        # Specialized formats
        ++ optionals cfg.archives.specializedFormats [
          _7zz # 7-Zip console version
          p7zip-rar # 7-Zip with RAR support
          p7zip # 7-Zip utilities
          rar # RAR archiver
          fastjar # Fast Java archive tool
          mozlz4a # Mozilla LZ4 archive tool
          lrzip # Long-range ZIP - for large files
        ]
        # Integration libraries
        ++ optionals cfg.archives.integrationLibs [
          advancecomp # Recompression tools
          archivemount # Mount archives as filesystems
          gnome-autoar # GNOME archive library
          libarchive # Multi-format archive library
          ouch # Painless archive extraction
        ];
    })

    # ════════════════════════════════════════════════════════════════════════
    # CORE CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.core.enable {
      environment.systemPackages = with pkgs; [
        OVMFFull # Full UEFI firmware for VMs
        age # Modern encryption tool
        agenix-cli # Age-encrypted secrets CLI
        cbfmt # Clipboard formatter
        ccls # C/C++ language server
        commons-compress # Apache compression library
        coreutils-full # GNU core utilities (full)
        dmg2img # Convert DMG to IMG
        dnsutils # DNS diagnostic tools (dig, nslookup)
        espeak-ng # Text-to-speech synthesizer
        fcft # Font loading library
        ffmpeg-full # Complete multimedia framework
        font-alias # X11 font alias files
        font-util # X11 font utilities
        fontconfig # Font configuration library
        fontforge-gtk # Font editor (GTK version)
        fontforge-fonttools # Python font manipulation
        gnome-themes-extra # Additional GNOME themes
        libglibutil # GLib utilities
        networkmanager # Network connection manager
        ngrok # Tunnel localhost to public URL
        nmap # Network security scanner
        papirus-folders # Papirus icon folder colors
        poppler_gi # PDF rendering library (GObject)
        pulseaudio # Sound server
        python312Packages.fonttools # Font manipulation library
        python312Packages.compreffor # Font compression
        service-wrapper # systemd service wrapper
        sops # Secrets management
        sox # Sound eXchange audio tool
        ssh-to-age # Convert SSH keys to age
        sssd # System Security Services Daemon
        tealdeer # tldr pages in Rust
        uutils-coreutils # Rust coreutils reimplementation
        webfontkitgenerator # Web font kit generator
      ];
    })

    # ════════════════════════════════════════════════════════════════════════
    # DEVELOPMENT CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.development.enable (mkMerge [
      # Minimal preset for ISO
      (mkIf cfg.development.minimal {
        modules.packages.development = {
          luaEcosystem = mkDefault false;
          rustEcosystem = mkDefault false;
          androidDevelopment = mkDefault false;
          systemCompilers = mkDefault false;
          databases = mkDefault false;
          treeSitterGrammars = mkDefault false;
        };
      })

      {
        environment.systemPackages = with pkgs;
        # Core essentials (always included)
          [
            jq # JSON processor
            neovim # Hyperextensible Vim-based editor
            any-nix-shell # Nix shell indicator
            cached-nix-shell # Faster nix-shell
            direnv # Directory-specific environments
            getopt # Command-line option parser
            glib # GLib utilities
            glow # Markdown renderer
            grex # Regex generator
            imlib2Full # Image loading library
            inetutils # Network utilities (telnet, ftp)
            libffi # Foreign function interface
            libimobiledevice # iOS device communication
            nix-init # Generate Nix packages from URLs
            nix-tree # Nix store browser
            nvd # Nix version diff
            poetry # Python dependency manager
            rmlint # Duplicate file finder
            squashfs-tools-ng # SquashFS utilities
            squashfuse # Mount SquashFS
            surfraw # Shell web search
            lynx # Text web browser
            feather # Lightweight note-taking
            bc # Arbitrary precision calculator
            cmake # Cross-platform build system
            gettext # Internationalization tools
          ]
          # Linters
          ++ optionals cfg.development.linters [
            actionlint # GitHub Actions linter
            commitlint-rs # Commit message linter
            deadnix # Dead code detector for Nix
            eslint_d # ESLint daemon
            hlint # Haskell linter
            nixpkgs-fmt # Nix formatter
            prettier # Multi-language formatter
            rust-analyzer # Rust language server
            shellcheck # Shell script linter
            shfmt # Shell formatter
            stylua # Lua formatter
            dotenv-linter # .env file linter
            diagnostic-languageserver # LSP for linters
            gopls # Go language server
            beautysh # Shell script beautifier
          ]
          # Version control
          ++ optionals cfg.development.versionControl [
            bfg-repo-cleaner # Git history cleaner
            gh # GitHub CLI
            gist # Gist CLI

            gource # Git history visualizer
            onefetch # Git repo summary
          ]
          # Build tools
          ++ optionals cfg.development.buildTools [
            gnumake # Make build tool
            just # Command runner (make alternative)
            meson # Fast build system
            pkg-config # Library compiler flags
            protobuf # Protocol buffers
            automake # GNU automake
            binutils # Binary utilities
          ]
          # Runtime languages
          ++ optionals cfg.development.runtimeLanguages [
            bun # JavaScript runtime
            cargo # Rust package manager
            go # Go programming language
            gopls # Go language server
            lua # Lua scripting language
            nodejs # Node.js JavaScript runtime
            openjdk # Java development kit
            pnpm # Fast npm alternative
            ruby # Ruby programming language
            typescript # TypeScript compiler
          ]
          # Lua ecosystem
          ++ optionals cfg.development.luaEcosystem [
            lua51Packages.lua # Lua 5.1
            lua52Packages.lua # Lua 5.2
            luajit # LuaJIT - fast Lua
            luajitPackages.luacheck # Lua linter
            luajitPackages.luarocks # Lua package manager
            luajitPackages.luasocket # Lua networking
            luarocks # Lua package manager
          ]
          # Rust ecosystem
          ++ optionals cfg.development.rustEcosystem [
            rustc # Rust compiler
            rustlings # Rust learning exercises
            rustscan # Fast Rust scanner
            rustup # Rust toolchain manager
            rustywind # Tailwind class sorter
          ]
          # Android development
          ++ optionals cfg.development.androidDevelopment [
            abootimg # Android boot image tool
            android-tools # ADB and fastboot
            apkeep # APK downloader
            apksigner # APK signing tool
            apktool # APK reverse engineering
            bundletool # Android App Bundle tool
            dex2jar # DEX to Java converter
            simg2img # Sparse image converter
          ]
          # Nix utilities
          ++ optionals cfg.development.nixUtilities [
            manix # Nix documentation searcher
            nix-index # Nix package file index
            nixos-generators # NixOS image generators
          ]
          # System compilers
          ++ optionals cfg.development.systemCompilers [
            patchelf # ELF patching tool
          ]
          # Web development
          ++ optionals cfg.development.webDevelopment [
            node2nix # Node to Nix converter
            nodenv # Node version manager
            sass # CSS preprocessor
            yarn # Node package manager
            gibo # Gitignore boilerplates
          ]
          # Databases
          ++ optionals cfg.development.databases [
            sqlite # SQLite database
            sqlite-utils # SQLite utilities
            usql # Universal SQL CLI
            sqlitebrowser # SQLite GUI browser
          ]
          # Editors
          ++ optionals cfg.development.editors [
            lldb # LLVM debugger
            opencode # AI coding assistant
            pandoc # Document converter
          ]
          # Tree-sitter grammars
          ++ optionals cfg.development.treeSitterGrammars [
            tree-sitter # Incremental parsing
            tree-sitter-grammars.tree-sitter-bash # Bash grammar
            tree-sitter-grammars.tree-sitter-c # C grammar
            tree-sitter-grammars.tree-sitter-comment # Comment grammar
            tree-sitter-grammars.tree-sitter-cpp # C++ grammar
            tree-sitter-grammars.tree-sitter-css # CSS grammar
            tree-sitter-grammars.tree-sitter-dockerfile # Dockerfile grammar
            tree-sitter-grammars.tree-sitter-go # Go grammar
            tree-sitter-grammars.tree-sitter-gomod # Go mod grammar
            tree-sitter-grammars.tree-sitter-html # HTML grammar
            tree-sitter-grammars.tree-sitter-javascript # JavaScript grammar
            tree-sitter-grammars.tree-sitter-jsdoc # JSDoc grammar
            tree-sitter-grammars.tree-sitter-json # JSON grammar
            tree-sitter-grammars.tree-sitter-json5 # JSON5 grammar
            tree-sitter-grammars.tree-sitter-lua # Lua grammar
            tree-sitter-grammars.tree-sitter-make # Makefile grammar
            tree-sitter-grammars.tree-sitter-markdown # Markdown grammar
            tree-sitter-grammars.tree-sitter-nix # Nix grammar
            tree-sitter-grammars.tree-sitter-python # Python grammar
            tree-sitter-grammars.tree-sitter-regex # Regex grammar
            tree-sitter-grammars.tree-sitter-ruby # Ruby grammar
            tree-sitter-grammars.tree-sitter-rust # Rust grammar
            tree-sitter-grammars.tree-sitter-scss # SCSS grammar
            tree-sitter-grammars.tree-sitter-toml # TOML grammar
            tree-sitter-grammars.tree-sitter-tsx # TSX grammar
            tree-sitter-grammars.tree-sitter-typescript # TypeScript grammar
            tree-sitter-grammars.tree-sitter-vim # Vim grammar
            tree-sitter-grammars.tree-sitter-yaml # YAML grammar
          ];
      }
    ]))

    # ════════════════════════════════════════════════════════════════════════
    # FONTS CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.fonts.enable {
      fonts = {
        packages = with pkgs;
        # Nerd Fonts - patched with icons
          optionals cfg.fonts.nerdFonts [
            nerd-fonts.agave # Agave Nerd Font
            nerd-fonts.d2coding # D2Coding Nerd Font
            nerd-fonts.envy-code-r # Envy Code R Nerd Font
            nerd-fonts.proggy-clean-tt # Proggy Clean Nerd Font
            nerd-fonts.ubuntu # Ubuntu Nerd Font
            nerd-fonts.ubuntu-mono # Ubuntu Mono Nerd Font
            nerd-fonts.ubuntu-sans # Ubuntu Sans Nerd Font
            nerd-fonts.noto # Noto Nerd Font
          ]
          # Icon Fonts
          ++ optionals cfg.fonts.iconFonts [
            nerd-fonts.symbols-only # Nerd Font symbols
            icomoon-feather # Feather icons font
            emacs-all-the-icons-fonts # Emacs icon fonts
            font-awesome_4 # Font Awesome 4
            font-awesome_5 # Font Awesome 5
            font-awesome_6 # Font Awesome 6
            material-design-icons # Google Material Icons
            material-symbols # Material Symbols
            siji # Minimal icon font
          ]
          # System Fonts
          ++ optionals cfg.fonts.systemFonts [
            corefonts # Microsoft core fonts
            get-google-fonts # Google Fonts installer
            jost # Jost font family
            nerd-font-patcher # Font patching tool
            norwester-font # Norwester display font
            pixel-code # Pixel Code font
            terminus_font # Terminus bitmap font
            vista-fonts # Windows Vista fonts
          ];

        # Font configuration - CRITICAL for fonts to work
        fontconfig = {
          enable = true;
          cache32Bit = true;
          antialias = true;
          useEmbeddedBitmaps = true;
          hinting = {
            enable = true;
            autohint = true;
            style = "slight";
          };
          subpixel = {
            lcdfilter = "default";
          };
        };
      };
    })

    # ════════════════════════════════════════════════════════════════════════
    # GUI CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.gui.enable (mkMerge [
      # Minimal preset
      (mkIf cfg.gui.minimal {
        modules.packages.gui = {
          messaging = mkDefault false;
          developmentTools = mkDefault false;
          extraPackages = mkDefault false;
        };
      })

      {
        environment.systemPackages = with pkgs;
        # Core GUI utilities
          [
            bleachbit # System cleaner
            file-roller # Archive manager
            gcolor3 # Color picker
            gnome-characters # Character map
            gnome-disk-utility # Disk manager
            gnome-font-viewer # Font preview
            gnome-themes-extra # GNOME themes
            ncurses # Terminal library
            gparted # Partition editor
            hunspell # Spell checker
            hunspellDicts.en-us # English dictionary
            kdePackages.breeze-icons # KDE Breeze icons
            kdePackages.qt6ct # Qt6 configuration
            kdePackages.qtbase # Qt6 base
            libappindicator-gtk3 # System tray support
            libnotify # Desktop notifications
            mimetic # MIME library
            networkmanagerapplet # Network applet
            pastel # Color manipulation
            pavucontrol # Audio volume control
            themechanger # Theme switcher
            xdg-desktop-portal # Desktop portal
          ]
          # Application launcher
          ++ optionals cfg.gui.applicationLauncher [
            rofi # Window switcher/launcher
            rofi-rbw # Bitwarden Rofi integration
            xdg-launch # XDG application launcher
            xdgmenumaker # Generate XDG menus
          ]
          # Media tools
          ++ optionals cfg.gui.mediaTools [
            transmission_4-gtk # BitTorrent client
            ocrmypdf # OCR for PDFs
            poppler-utils # PDF utilities
            sioyek # PDF viewer with Vim keys
            ebook_tools # Calibre ebook utiities without calibre
            lue # Terminal ebook reader application using EdgeTTS
            mupdf # PDF viewer
            pdftk # PDF toolkit
          ]
          # Development tools
          ++ optionals cfg.gui.developmentTools [
            appimage-run # Run AppImages
            vscode-fhs # VS Code (FHS)
            ventoy-full # Bootable USB creator
          ]
          # Window management
          ++ optionals cfg.gui.windowManagement [
            maim # Screenshot utility
            picom # Compositor
            wmctrl # Window manager control
          ]
          # Messaging
          ++ optionals cfg.gui.messaging [
            telegram-desktop # Telegram client
            element-desktop # Matrix client
            vesktop # Discord client
          ];
      }

      # GUI Libraries
      (mkIf cfg.gui.libs.enable {
        environment.systemPackages = with pkgs;
        # Core graphics
          optionals cfg.gui.libs.coreGraphics [
            cairo # 2D graphics library
            cairomm # Cairo C++ bindings
            pango # Text rendering
            pangomm # Pango C++ bindings
            gdk-pixbuf # Image loading
            gdk-pixbuf-xlib # Xlib support
          ]
          # GObject support
          ++ optionals cfg.gui.libs.gobjectSupport [
            gobject-introspection # GObject introspection
            gobject-introspection-unwrapped # Unwrapped version
            libgee # GObject collection library
            libpeas # GObject plugin library
            libpeas2 # libpeas v2
          ]
          # Desktop integration
          ++ optionals cfg.gui.libs.desktopIntegration [
            dbus-broker # D-Bus message broker
            dconf # GNOME configuration
            gsettings-desktop-schemas # GNOME schemas
            gnome.nixos-gsettings-overrides # GNOME overrides
            libnotify # Notifications library
            polkit_gnome # Polkit agent
            menu-cache # Menu caching
            garcon # XFCE menu library
            pantheon.granite # Elementary library
          ]
          # XFCE support
          ++ optionals cfg.gui.libs.xfceSupport [
            libxfce4ui # XFCE UI library
            libxfce4util # XFCE utilities
            xfce4-exo # XFCE extensions
            xfconf # XFCE configuration
          ]
          # Audio and terminal
          ++ optionals cfg.gui.libs.audioTerminal [
            libcanberra-gtk3 # Sound theme library
            portaudio # Audio I/O
            vte-gtk4 # Terminal emulator library
          ]
          # Python bindings
          ++ optionals cfg.gui.libs.pythonBindings [
            python313Packages.pycairo # Cairo Python bindings
            python313Packages.pygobject3 # GObject Python bindings
            python313Packages.pyqt6 # Qt6 Python bindings
            python313Packages.pyqt6-charts # Qt Charts
            python313Packages.pyqt6-webengine # Qt WebEngine
          ]
          # Ruby bindings
          ++ optionals cfg.gui.libs.rubyBindings [
            rubyPackages.cairo # Cairo Ruby bindings
            rubyPackages.gdk_pixbuf2 # GdkPixbuf Ruby
            rubyPackages.gobject-introspection # GObject Ruby
          ]
          # Font support
          ++ optionals cfg.gui.libs.fontSupport [
            terminus_font # Terminus font
          ];
      })
    ]))

    # ════════════════════════════════════════════════════════════════════════
    # MULTIMEDIA CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.multimedia.enable (mkMerge [
      # Minimal preset
      (mkIf cfg.multimedia.minimal {
        modules.packages.multimedia = {
          streamingTools = mkDefault false;
          gstreamerPlugins = mkDefault false;
          creators = mkDefault false;
          stableVideoEditors = mkDefault false;
        };
      })

      {
        environment.systemPackages = with pkgs;
        # Core multimedia
          [
            ffmpeg-full # Complete multimedia framework
            vlc # Media player
          ]
          # Video tools
          ++ optionals cfg.multimedia.videoTools [
            libaom # AV1 codec library
            cheese # Webcam application
            dav1d # AV1 decoder
            frei0r # Video plugins
            fswebcam # Webcam capture
            gnome-video-effects # Video effects
            ladspa-sdk # Audio plugins
            libtheora # Theora codec
            libvpl # Intel Video Processing
            libwebcam # Webcam library

            lv2 # Audio plugin standard
            mjpegtools # MJPEG tools
            mp4v2 # MP4 utilities
            ocamlPackages.frei0r # Frei0r OCaml
            oggvideotools # Ogg video tools
            peek # GIF recorder
            swh # LADSPA plugins
            svt-av1 # AV1 encoder
            yt-dlp # YouTube downloader
            xvidcore # XviD codec
          ]
          # Image tools
          ++ optionals cfg.multimedia.imageTools [
            ascii-image-converter # Image to ASCII
            autotrace # Bitmap to vector
            cairosvg # SVG converter
            gthumb # Image viewer
            curtail # Image compressor
            exiftool # Metadata editor
            feh # Image viewer
            figlet # ASCII art generator
            gdk-pixbuf # Image loading
            gegl # Generic graphics library
            giflib # GIF library
            gifsicle # GIF manipulation
            gmic # Image processing
            graphicsmagick # Image processing
            image_optim # Image optimization
            imagemagick # Image manipulation
            imlib2Full # Imlib2 (full)
            imgcat # Image in terminal
            jpeginfo # JPEG information
            jpegoptim # JPEG optimizer
            libavif # AVIF library
            libexif # EXIF library
            libheif # HEIF library
            libjxl # JPEG XL library
            libjpeg # JPEG library
            libpng # PNG library
            librsvg # SVG library
            libspng # PNG library
            libwebp # WebP library
            lsix # Image thumbnails in terminal
            metapixel # Photomosaics
            mozjpeg # Mozilla JPEG encoder
            svgo # SVG optimizer
            optipng # PNG optimizer
            oxipng # PNG optimizer (Rust)
            perlPackages.ImageMagick # ImageMagick Perl
            perlPackages.PerlMagick # PerlMagick
            pngcrush # PNG optimizer
            pngquant # PNG quantization
            pngtoico # PNG to ICO
            pngtools # PNG utilities
            potrace # Bitmap to vector
            python313Packages.colorthief # Color extraction
            python313Packages.pyfiglet # Figlet Python
            python313Packages.pystache # Mustache Python
            python313Packages.svgwrite # SVG Python
            resvg # SVG renderer
            scour # SVG optimizer
            svgcleaner # SVG cleaner
            t1utils # Type 1 font tools
            termcolor # Terminal colors
            toilet # ASCII art
            uni # Unicode utility
            upscayl # AI image upscaler
            emote # Emoji picker
          ]
          # Streaming tools
          ++ optionals cfg.multimedia.streamingTools [
            giph # GIF recorder
            megapixels # Camera app
            pipewire # Multimedia framework
            traverso # Audio recorder
            webp-pixbuf-loader # WebP thumbnails
          ]
          # GStreamer plugins
          ++ optionals cfg.multimedia.gstreamerPlugins [
            gst_all_1.gst-editing-services # GStreamer editing
            gst_all_1.gst-libav # GStreamer libav
            gst_all_1.gst-plugins-bad # GStreamer bad plugins
            gst_all_1.gst-plugins-base # GStreamer base plugins
            gst_all_1.gst-plugins-good # GStreamer good plugins
            gst_all_1.gst-plugins-rs # GStreamer Rust plugins
            gst_all_1.gst-plugins-ugly # GStreamer ugly plugins
            gst_all_1.gst-vaapi # GStreamer VA-API
            gst_all_1.gstreamer # GStreamer core
          ]
          # Content creators (gimp, inkscape only)
          ++ optionals cfg.multimedia.creators [
            gimp3-with-plugins # GNU Image Manipulation
            gimp3Plugins.gmic # GIMP GMIC plugin
            inkscape-with-extensions # Vector graphics editor
          ]
          # Stable video editors
          ++ optionals cfg.multimedia.stableVideoEditors [
            pkgs.stable.olive-editor # Video editor
            pkgs.stable.shotcut # Video editor
            pkgs.stable.openshot-qt # Video editor
            vid-stab # Video stabilization
            vidmerger # Video merging
            vvenc # VVC encoder
            x264 # H.264 encoder
            x265 # H.265/HEVC encoder
            losslesscut-bin # Lossless video cutting
          ];
      }
    ]))

    # ════════════════════════════════════════════════════════════════════════
    # NETWORK CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.network.enable {
      environment.systemPackages = with pkgs;
      # Git tools
        optionals cfg.network.gitTools [
          gh # GitHub CLI
          libgit2 # Git library
          libgit2-glib # Git GLib bindings
          git-extras # Git utilities
          git-lfs # Git Large File Storage
          git # Distributed version control
          libgit2 # Git library
          libgit2-glib # Git GLib bindings
        ]
        # Wireless tools
        ++ optionals cfg.network.wirelessTools [
          iw # Wireless configuration
          wirelesstools # Wireless extensions
        ]
        # Download tools
        ++ optionals cfg.network.downloadTools [
          rclone # Cloud storage sync
          yt-dlp # YouTube downloader
        ]
        # Compression libraries
        ++ optionals cfg.network.compressionLibs [
          zlib # Compression library
        ];
    })

    # ════════════════════════════════════════════════════════════════════════
    # PYTHON CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.python.enable {
      environment.systemPackages = with pkgs;
      # Core Python
        [
          python313 # Python 3.13 interpreter
        ]
        # Development tools
        ++ optionals cfg.python.development [
          python313Packages.flake8 # Python linter
          python313Packages.pylint # Python linter
          python313Packages.pip-tools # Pip requirements
          python313Packages.pipx # Run Python apps
          python313Packages.setuptoolsBuildHook # Build hook
          python313Packages.meson-python # Meson Python
        ]
        # Web development
        ++ optionals cfg.python.webDevelopment [
          python313Packages.beautifulsoup4 # Web scraping
          python313Packages.websockets # WebSocket library
          python313Packages.python-dotenv # Environment variables
        ]
        # Data processing
        ++ optionals cfg.python.dataProcessing [
          python313Packages.pydantic # Data validation
          python313Packages.pydantic-core # Pydantic core
          python313Packages.levenshtein # String similarity
          python313Packages.pylatexenc # LaTeX encoding
        ]
        # System integration
        ++ optionals cfg.python.systemIntegration [
          python313Packages.gitpython # Git Python
          python313Packages.gitdb # Git database
          python313Packages.youtube-transcript-api # YouTube transcripts
          python313Packages.playsound # Play audio
        ]
        # Graphics
        ++ optionals cfg.python.graphics [
          python313Packages.pycairo # Cairo Python
          python313Packages.pygobject3 # GObject Python
          python313Packages.pylatex # LaTeX Python
        ]
        # External Python tools
        ++ [
          black # Python formatter
          ruff # Fast Python linter
          pylint # Python linter
          pipenv # Python environment
          streamlit # Web app framework
          virtualenv # Python environments
          virtualenv-clone # Clone environments
          gobject-introspection # GObject introspection
        ];
    })

    # ════════════════════════════════════════════════════════════════════════
    # SHELL CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.shell.enable {
      environment.systemPackages = with pkgs;
      # Core shell utilities
        [
          bash-completion # Bash completions
          curl # URL transfer
        ]
        # Modern tools
        ++ optionals cfg.shell.modernTools [
          bat # Cat with syntax highlighting
          btop # System monitor
          eza # Modern ls replacement
          fd # Modern find
          fzf # Fuzzy finder
          fzy # Fast fuzzy finder
          silver-searcher # Code search (ag)
        ]
        # System utilities
        ++ optionals cfg.shell.systemUtils [
          beep # System beep
          boxes # ASCII boxes
          clipster # Clipboard manager
          jdupes # Duplicate finder
          killall # Kill processes by name
          trash-cli # CLI trash can
        ]
        # File management
        ++ optionals cfg.shell.fileManagement [
          tree # Directory tree
          walk # Directory navigator
        ]
        # Download tools
        ++ optionals cfg.shell.downloadTools [
          aria2 # Download utility
          rclone # Cloud storage sync
        ]
        # ZSH plugins
        ++ optionals cfg.shell.zshPlugins [
          pure-prompt # Minimal ZSH prompt
          zsh-autocomplete # ZSH autocomplete
          zsh-edit # ZSH editing
          zsh-navigation-tools # ZSH navigation
          zsh-you-should-use # ZSH alias reminder
        ]
        # Input support
        ++ optionals cfg.shell.inputSupport [
          libdbusmenu # DBus menu
          libdbusmenu-gtk3 # GTK DBus menu
          libinput # Input device library
        ];
    })

    # ════════════════════════════════════════════════════════════════════════
    # SYSTEM CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.system.enable (mkMerge [
      # Minimal preset
      (mkIf cfg.system.minimal {
        modules.packages.system = {
          hardware = mkDefault false;
        };
      })

      {
        environment.systemPackages = with pkgs;
        # Essential system utilities (always included)
          [
            acpi # Battery information
            automake # GNU automake
            binutils # Binary utilities
            comma # Run commands from nixpkgs
            cowsay # Speaking cow
            fd # Modern find
            file # File type identification
            gh # GitHub CLI
            iw # Wireless configuration
            jq # JSON processor
            moreutils # More Unix utilities
            fastfetch # System info
            parallel # Run jobs in parallel
            pciutils # PCI utilities
            ripgrep-all # ripgrep with everything
            usbmuxd # USB multiplexer
            usbutils # USB utilities
            util-linux # Linux utilities
            wget # Web downloader
            whois # WHOIS client
            wirelesstools # Wireless tools
            yad # Dialogs
            zip # PKZIP archive
            brotli # Compression algorithm
          ]
          # Filesystem utilities
          ++ optionals cfg.system.filesystem [
            afuse # Auto-mounting FUSE
            apfs-fuse # APFS filesystem
            avfs # Virtual filesystem
            dosfstools # FAT filesystem
            fuse # FUSE filesystem
            fuse3 # FUSE v3
            fuseiso # ISO mounting
            fuse-ext2 # ext2/3/4 FUSE
            fuse-7z-ng # 7z FUSE
            fuse-archive # Archive mounting
            libcloudproviders # Cloud integration
            ext4fuse # ext4 FUSE
            exfatprogs # exFAT utilities
            ntfs3g # NTFS driver
            ntfsprogs # NTFS utilities
            xorriso # ISO creation
          ]
          # Hardware monitoring
          ++ optionals cfg.system.hardware [
            brightnessctl # Backlight control
            ddcui # Display control GUI
            ddcutil # Display control CLI
            efibootmgr # EFI boot manager
            intel-graphics-compiler # Intel GPU compiler
            lm_sensors # Hardware sensors
            lshw # Hardware lister
            intel-media-driver # Intel media driver
            smartmontools # Disk health
            sysfsutils # sysfs utilities
            testdisk # Data recovery
          ]
          # Performance monitoring
          ++ optionals cfg.system.performance [
            htop # Process monitor
            nmon # System monitor
            procps # Process utilities
            ps_mem # Memory usage
            sysprof # System profiler
            sysstat # System statistics
            sysz # systemctl fzf
          ]
          # Desktop utilities
          ++ optionals cfg.system.desktop [
            dbus-broker # D-Bus broker
            dconf # GNOME config
            gnome-keyring # Keyring daemon
            polkit_gnome # Polkit agent
            shared-mime-info # MIME database
            tumbler # Thumbnailer
            xdg-desktop-portal-gtk # GTK portal
            xdg-user-dirs # User directories
            xdg-utils # XDG utilities
          ]
          # Multimedia system tools
          ++ optionals cfg.system.multimedia [
            cdrtools # CD recording
            curtail # Image compressor
            ghostscript # PostScript interpreter
            lame # MP3 encoder
            portaudio # Audio I/O
          ];
      }
    ]))

    # ════════════════════════════════════════════════════════════════════════
    # X11 CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.x11.enable {
      environment.systemPackages = with pkgs; [
        xbacklight # Display backlight control
        xclip # X11 clipboard
        xdotool # X11 automation
        xev # X event viewer
        xfontsel # X font selector
        xhost # X access control
        xinit # X server initializer
        xkill # Kill X clients
        xprop # X window properties
        xscreensaver # Screen saver
        xsecurelock # Screen locker
        xss-lock # Lock screen on suspend
        xsuspender # Suspend X clients
        xwininfo # X window info
        xrdb # X resource database
      ];
    })

    # ════════════════════════════════════════════════════════════════════════
    # WAYLAND CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.wayland.enable {
      environment.systemPackages = with pkgs; [
        brightnessctl # Backlight control
        cliphist # Clipboard history
        fuzzel # Application launcher
        grim # Screenshot tool
        hyprpicker # Color picker
        libinput # Input device library
        libinput-gestures # Touchpad gestures
        slurp # Screen region selector
        swaybg # Wallpaper utility
        swayidle # Idle manager
        swaylock # Screen locker
        waybar # Status bar
        waypipe # Wayland proxy
        wdisplays # Display configurator
        wev # Wayland event viewer
        wlr-randr # Output management
        wofi # Application launcher
        wtype # Wayland keyboard input
        xdg-desktop-portal-wlr # wlroots portal
        wl-clipboard # Wayland clipboard
        wl-mirror # Output mirror
        wlogout # Logout menu
      ];
    })
  ];
}
