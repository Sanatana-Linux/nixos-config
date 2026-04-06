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
      browsers = mkEnableOption "Web browsers";

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
          cpio # Copy-in/copy-out archive format
          zip # PKZIP archive format
          unzip # PKZIP extraction
          minizip-ng # Zip library (ng version)
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
          p7zip # 7-Zip utilities
          p7zip-rar # 7-Zip with RAR support
          rar # RAR archiver
          lrzip # Long-range ZIP - for large files
          fastjar # Fast Java archive tool
          mozlz4a # Mozilla LZ4 archive tool
        ]
        # Integration libraries
        ++ optionals cfg.archives.integrationLibs [
          libarchive # Multi-format archive library
          archivemount # Mount archives as filesystems
          gnome-autoar # GNOME archive library
          advancecomp # Recompression tools
          ouch # Painless archive extraction
        ];
    })

    # ════════════════════════════════════════════════════════════════════════
    # CORE CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.core.enable {
      environment.systemPackages = with pkgs; [
        # System & Performance
        coreutils-full # GNU core utilities (full)
        uutils-coreutils # Rust coreutils reimplementation
        OVMFFull # Full UEFI firmware for VMs
        service-wrapper # systemd service wrapper
        sssd # System Security Services Daemon

        # Secrets & Encryption
        age # Modern encryption tool
        agenix-cli # Age-encrypted secrets CLI
        sops # Secrets management
        ssh-to-age # Convert SSH keys to age

        # Network Utilities
        networkmanager # Network connection manager
        dnsutils # DNS diagnostic tools (dig, nslookup)
        nmap # Network security scanner
        ngrok # Tunnel localhost to public URL

        # Font & Text Infrastructure
        fontconfig # Font configuration library
        font-util # X11 font utilities
        font-alias # X11 font alias files
        fcft # Font loading library
        fontforge-gtk # Font editor (GTK version)
        fontforge-fonttools # Python font manipulation
        python312Packages.fonttools # Font manipulation library
        python312Packages.compreffor # Font compression
        webfontkitgenerator # Web font kit generator

        # Multimedia & Sound
        # ffmpeg-full # Complete multimedia framework
        poppler_gi # PDF rendering library (GObject)
        sox # Sound eXchange audio tool
        espeak-ng # Text-to-speech synthesizer
        pulseaudio # Sound server

        # Appearance & Themes
        gnome-themes-extra # Additional GNOME themes
        papirus-folders # Papirus icon folder colors

        # Misc Utilities
        opencode
        tealdeer # tldr pages in Rust
        dmg2img # Convert DMG to IMG
        cbfmt # Clipboard formatter
        ccls # C/C++ language server
        commons-compress # Apache compression library
        libglibutil # GLib utilities
        sillytavern
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
            # Editor
            neovim # Hyperextensible Vim-based editor

            # Nix Tools
            any-nix-shell # Nix shell indicator
            cached-nix-shell # Faster nix-shell
            nix-init # Generate Nix packages from URLs
            nix-tree # Nix store browser
            nvd # Nix version diff

            # Data & Documentation
            jq # JSON processor
            glow # Markdown renderer
            grex # Regex generator
            bc # Arbitrary precision calculator
            pandoc # Document converter

            # Environment & Build Systems
            direnv # Directory-specific environments
            poetry # Python dependency manager
            getopt # Command-line option parser
            cmake # Cross-platform build system
            gettext # Internationalization tools
            glib # GLib utilities
            libffi # Foreign function interface

            # System & Hardware Dev
            libimobiledevice # iOS device communication
            imlib2Full # Image loading library
            rmlint # Duplicate file finder
            squashfs-tools-ng # SquashFS utilities
            squashfuse # Mount SquashFS

            # Browsing & Search
            surfraw # Shell web search
            lynx # Text web browser
            feather # Lightweight note-taking
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
            gh # GitHub CLI
            gist # Gist CLI
            bfg-repo-cleaner # Git history cleaner
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
          ++ optionals cfg.development.luaEcosystem [
            lua51Packages.lua # Lua 5.1
            lua51Packages.luarocks # Lua package manager for Lua 5.1
            lua51Packages.lgi # Lua GObject introspection (GTK binding)
            lua52Packages.lua # Lua 5.2
            luajit # LuaJIT - fast Lua
            luajitPackages.luacheck # Lua linter
            luajitPackages.luarocks # Lua package manager for LuaJIT
            luajitPackages.luasocket # Lua networking
            luajitPackages.lgi # Lua GObject introspection (GTK binding)
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
            # node2nix # Removed - no longer maintained in nixpkgs
            nodenv # Node version manager
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
            python313Packages.tree-sitter-language-pack # Python tree-sitter bindings
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
            font-awesome_7 # Font Awesome 7

            material-design-icons # Google Material Icons
            material-symbols # Material Symbols
            siji # Minimal icon font
          ]
          # System Fonts
          ++ optionals cfg.fonts.systemFonts [
            corefonts # Microsoft core fonts
            vista-fonts # Windows Vista fonts
            get-google-fonts # Google Fonts installer
            jost # Jost font family
            norwester-font # Norwester display font
            pixel-code # Pixel Code font
            terminus_font # Terminus bitmap font
            nerd-font-patcher # Font patching tool
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
            # System Management
            gnome-disk-utility # Disk manager
            gparted # Partition editor
            bleachbit # System cleaner
            file-roller # Archive manager
            gnome-font-viewer
            # Desktop Integration
            libnotify # Desktop notifications
            xdg-desktop-portal # Desktop portal
            networkmanagerapplet # Network applet
            libappindicator-gtk3 # System tray support
            ncurses # Terminal library

            # Configuration & Appearance
            kdePackages.qt6ct # Qt6 configuration
            kdePackages.qtbase # Qt6 base
            kdePackages.breeze-icons # KDE Breeze icons
            gnome-themes-extra # GNOME themes
            themechanger # Theme switcher
            pastel # Color manipulation
            gcolor3 # Color picker

            # Utilities
            hunspell # Spell checker
            hunspellDicts.en-us # English dictionary
            mimetic # MIME library
            pavucontrol # Audio volume control
          ]
          # Application launcher
          ++ optionals cfg.gui.applicationLauncher [
            xdg-launch # XDG application launcher
            xdgmenumaker # Generate XDG menus
          ]
          # Media tools
          ++ optionals cfg.gui.mediaTools [
            # Document tools
            sioyek # PDF viewer with Vim keys
            mupdf # PDF viewer
            poppler-utils # PDF utilities
            pdftk # PDF toolkit
            ebook_tools # Calibre ebook utiities without calibre
            lue # Terminal ebook reader application using EdgeTTS

            # Other
            transmission_4-gtk # BitTorrent client
          ]
          # Development tools
          ++ optionals cfg.gui.developmentTools [
            appimage-run # Run AppImages
            ventoy-full # Bootable USB creator
          ]
          # Window management
          ++ optionals cfg.gui.windowManagement [
            picom # Compositor
            maim # Screenshot utility
            wmctrl # Window manager control
          ]
          # Messaging
          ++ optionals cfg.gui.messaging [
            telegram-desktop # Telegram client
          ]
          # Browsers
          ++ optionals cfg.gui.browsers [
            tor-browser # Tor Browser
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
            libnotify # Notifications library
            polkit_gnome # Polkit agent
            menu-cache # Menu caching
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
            # Codecs & Decoders
            libaom # AV1 codec library
            dav1d # AV1 decoder
            libtheora # Theora codec
            libvpl # Intel Video Processing

            # Webcam tools
            cheese # Webcam application
            fswebcam # Webcam capture
            libwebcam # Webcam library

            # Plugins & Effects
            # frei0r # Video plugins
            #           ocamlPackages.frei0r # Frei0r OCaml
            #           gnome-video-effects # Video effects
            ladspa-sdk # Audio plugins
            lv2 # Audio plugin standard
            swh # LADSPA plugins
            mjpegtools # MJPEG tools

            # Utilities
            mp4v2 # MP4 utilities
            oggvideotools # Ogg video tools
            peek # GIF recorder
            yt-dlp # YouTube downloader
            svt-av1 # AV1 encoder
          ]
          # Image tools
          ++ optionals cfg.multimedia.imageTools [
            # Image Processing & Manipulation
            imagemagick # Image manipulation
            graphicsmagick # Image processing
            image_optim # Image optimization
            gegl # Generic graphics library
            #   gmic # Image processing
            cairosvg # SVG converter
            svgo # SVG optimizer
            svgcleaner # SVG cleaner
            optipng # PNG optimizer
            oxipng # PNG optimizer (Rust)
            pngcrush # PNG optimizer
            pngquant # PNG quantization
            jpegoptim # JPEG optimizer
            jpeginfo # JPEG information

            # Viewers & Metadata
            gthumb # Image viewer
            exiftool # Metadata editor
            libexif # EXIF library

            # Formats & Codec Libs
            libpng # PNG library
            libjpeg # JPEG library
            mozjpeg # Mozilla JPEG encoder
            libwebp # WebP library
            libjxl # JPEG XL library
            libavif # AVIF library
            libheif # HEIF library
            librsvg # SVG library
            giflib # GIF library
            gifsicle # GIF manipulation
            resvg # SVG renderer
            pngtools # PNG utilities
            pngtoico # PNG to ICO
            libspng # PNG library
            t1utils # Type 1 font tools

            # Terminal & ASCII Graphics
            imgcat # Image in terminal
            lsix # Image thumbnails in terminal
            ascii-image-converter # Image to ASCII
            cfonts # Modern Text to ASCII Banners
            uni # Unicode utility
            termcolor # Terminal colors
            python313Packages.pyfiglet # Figlet Python

            # Specialty
            autotrace # Bitmap to vector
            potrace # Bitmap to vector
            metapixel # Photomosaics
            emote # Emoji picker
            gdk-pixbuf # Image loading
            perlPackages.ImageMagick # ImageMagick Perl
            perlPackages.PerlMagick # PerlMagick
            python313Packages.colorthief # Color extraction
            python313Packages.pystache # Mustache Python
            python313Packages.svgwrite # SVG Python
          ]
          # Streaming tools
          ++ optionals cfg.multimedia.streamingTools [
            pipewire # Multimedia framework
            traverso # Audio recorder
            giph # GIF recorder
            webp-pixbuf-loader # WebP thumbnails
          ]
          # GStreamer plugins
          ++ optionals cfg.multimedia.gstreamerPlugins [
            gst_all_1.gstreamer # GStreamer core
            gst_all_1.gst-plugins-base # GStreamer base plugins
            gst_all_1.gst-plugins-good # GStreamer good plugins
            gst_all_1.gst-plugins-bad # GStreamer bad plugins
            gst_all_1.gst-plugins-ugly # GStreamer ugly plugins
            gst_all_1.gst-plugins-rs # GStreamer Rust plugins
            gst_all_1.gst-libav # GStreamer libav
            gst_all_1.gst-vaapi # GStreamer VA-API
            gst_all_1.gst-editing-services # GStreamer editing
          ]
          # Content creators
          ++ optionals cfg.multimedia.creators [
            gimp3-with-plugins # GNU Image Manipulation
            # gimp3Plugins.gmic # GIMP GMIC plugin
            inkscape-with-extensions # Vector graphics editor
          ]
          # Stable video editors
          ++ optionals cfg.multimedia.stableVideoEditors [
            pkgs.stable.olive-editor # Video editor
            pkgs.stable.shotcut # Video editor
            pkgs.stable.openshot-qt # Video editor
            losslesscut-bin # Lossless video cutting
            vid-stab # Video stabilization
            vidmerger # Video merging
            vvenc # VVC encoder
            x264 # H.264 encoder
            x265 # H.265/HEVC encoder
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
          git # Distributed version control
          git-extras # Git utilities
          git-lfs # Git Large File Storage
          gh # GitHub CLI
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
          transmission_4 # BitTorrent daemon
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
          pipenv # Python environment
          virtualenv # Python environments
          virtualenv-clone # Clone environments
          streamlit # Web app framework
          gobject-introspection # GObject introspection
        ]
        # Development tools
        ++ optionals cfg.python.development [
          python313Packages.flake8 # Python linter
          python313Packages.pylint # Python linter
          python313Packages.pip-tools # Pip requirements
          python313Packages.pipx # Run Python apps
          python313Packages.setuptoolsBuildHook # Build hook
          python313Packages.meson-python # Meson Python
          black # Python formatter
          ruff # Fast Python linter
          pylint # Python linter
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
          eza # Modern ls replacement
          fd # Modern find
          fzf # Fuzzy finder
          fzy # Fast fuzzy finder
          silver-searcher # Code search (ag)
          btop # System monitor
        ]
        # System utilities
        ++ optionals cfg.shell.systemUtils [
          killall # Kill processes by name
          trash-cli # CLI trash can
          jdupes # Duplicate finder
          clipster # Clipboard manager
          boxes # ASCII boxes
          beep # System beep
        ]
        # File management
        ++ optionals cfg.shell.fileManagement [
          tree # Directory tree
        ]
        # Download tools
        ++ optionals cfg.shell.downloadTools [
          aria2 # Download utility
          rclone # Cloud storage sync
        ]
        # ZSH plugins
        ++ optionals cfg.shell.zshPlugins [
          zsh-autocomplete # ZSH autocomplete
          zsh-edit # ZSH editing
          zsh-navigation-tools # ZSH navigation
          zsh-you-should-use # ZSH alias reminder
        ]
        # Input support
        ++ optionals cfg.shell.inputSupport [
          libinput # Input device library
          libdbusmenu # DBus menu
          libdbusmenu-gtk3 # GTK DBus menu
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
            # Linux Standard utils
            util-linux # Linux utilities
            coreutils-full # Core utilities
            file # File type identification
            wget # Web downloader
            jq # JSON processor
            moreutils # More Unix utilities
            parallel # Run jobs in parallel

            # Help & Metadata
            comma # Run commands from nixpkgs
            gh # GitHub CLI
            fastfetch # System info

            # Misc
            acpi # Battery information
            automake # GNU automake
            binutils # Binary utilities
            fd # Modern find
            ripgrep-all # ripgrep with everything
            yad # Dialogs
            brotli # Compression algorithm
            zip # PKZIP archive
          ]
          # Filesystem utilities
          ++ optionals cfg.system.filesystem [
            # Base FUSE drivers
            fuse # FUSE filesystem
            fuse3 # FUSE v3
            afuse # Auto-mounting FUSE
            avfs # Virtual filesystem
            fuseiso # ISO mounting

            # Archive / Storage mounting
            fuse-archive # Archive mounting
            fuse-7z-ng # 7z FUSE
            exfatprogs # exFAT utilities
            ntfs3g # NTFS driver
            ntfsprogs # NTFS utilities
            dosfstools # FAT filesystem

            # Linux/Mac specific
            apfs-fuse # APFS filesystem
            ext4fuse # ext4 FUSE
            fuse-ext2 # ext2/3/4 FUSE

            # Integration
            libcloudproviders # Cloud integration
            xorriso # ISO creation
          ]
          # Hardware monitoring
          ++ optionals cfg.system.hardware [
            # Listing & Recovery
            lshw # Hardware lister
            pciutils # PCI utilities
            usbutils # USB utilities
            usbmuxd # USB multiplexer
            testdisk # Data recovery

            # Display & Brightness
            brightnessctl # Backlight control
            ddcutil # Display control CLI
            ddcui # Display control GUI

            # Monitoring
            lm_sensors # Hardware sensors
            smartmontools # Disk health
            efibootmgr # EFI boot manager
            sysfsutils # sysfs utilities

            # GPU / Media
            intel-graphics-compiler # Intel GPU compiler
            intel-media-driver # Intel media driver

            # Network
            iw # Wireless configuration
            wirelesstools # Wireless tools
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
            xdg-utils # XDG utilities
            xdg-user-dirs # User directories
            xdg-desktop-portal-gtk # GTK portal
            gnome-keyring # Keyring daemon
            polkit_gnome # Polkit agent
            shared-mime-info # MIME database
            tumbler # Thumbnailer
          ]
          # Multimedia system tools
          ++ optionals cfg.system.multimedia [
            cdrtools # CD recording
            ghostscript # PostScript interpreter
            lame # MP3 encoder
            portaudio # Audio I/O
            curtail # Image compressor
          ];
      }
    ]))

    # ════════════════════════════════════════════════════════════════════════
    # X11 CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.x11.enable {
      environment.systemPackages = with pkgs; [
        # Session & Locks
        xinit # X server initializer
        xrdb # X resource database
        xhost # X access control
        xscreensaver # Screen saver
        xsecurelock # Screen locker
        xss-lock # Lock screen on suspend
        xsuspender # Suspend X clients

        # Window & Info
        xprop # X window properties
        xwininfo # X window info
        xev # X event viewer
        xfontsel # X font selector
        xrandr # X Resize, Rotate and Reflect extension
        arandr # GUI for xrandr

        # Input & Interaction
        xclip # X11 clipboard
        xdotool # X11 automation
        xbacklight # Display backlight control
        xkill # Kill X clients
      ];
    })

    # ════════════════════════════════════════════════════════════════════════
    # WAYLAND CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.wayland.enable {
      environment.systemPackages = with pkgs; [
        # Compositor Support & Management
        wlr-randr # Output management
        wdisplays # Display configurator
        waypipe # Wayland proxy
        xdg-desktop-portal-wlr # wlroots portal
        wl-mirror # Output mirror
        wlroots # libraries that dwl is based ob

        # Bars & Launchers
        waybar # Status bar
        wofi # Application launcher
        fuzzel # Application launcher
        wlogout # Logout menu

        # Graphics & Screenshots
        grim # Screenshot tool
        slurp # Screen region selector
        hyprpicker # Color picker

        # System & Clipboard
        wl-clipboard # Wayland clipboard
        cliphist # Clipboard history
        brightnessctl # Backlight control
        swaybg # Wallpaper utility
        swayidle # Idle manager
        swaylock # Screen locker

        # Input & Input Events
        libinput # Input device library
        libinput-gestures # Touchpad gestures
        wtype # Wayland keyboard input
        wev # Wayland event viewer
      ];
    })
  ];
}
