{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.packages;
in {
  options.modules.base.packages = {
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
      nixUtilities = mkEnableOption "Nix-specific utilities";
      systemCompilers = mkEnableOption "System compilers (gcc, clang)";
      webDevelopment = mkEnableOption "Web development tools";
      databases = mkEnableOption "Database tools";
      editors = mkEnableOption "Code editors and IDE tools";
      treeSitterGrammars = mkEnableOption "Tree-sitter grammar files";
      languageServers = mkEnableOption "Language server protocol implementations";
    };

    # ══════════════════════════════════════════════════════════════════════════

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

    # ══════════════════════════════════════════════════════════════════════════

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

    # ══════════════════════════════════════════════════════════════════════════

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
      document = mkOption {
        type = types.bool;
        default = true;
        description = "Document and PDF generation tools";
      };
    };

    # ══════════════════════════════════════════════════════════════════════════
    # X11
    # ══════════════════════════════════════════════════════════════════════════
    #
    # ══════════════════════════════════════════════════════════════════════════
    # WAYLAND
    # ══════════════════════════════════════════════════════════════════════════

    # ══════════════════════════════════════════════════════════════════════════
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
    # ════════════════════════════════════════════════════════════════════════
    # BROWSER CONFIG
    # ════════════════════════════════════════════════════════════════════════
    #
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
        ente-auth # 2FA Secrets

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
        python314Packages.fonttools # Font manipulation library
        python314Packages.compreffor # Font compression
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
        libapparmor # AppArmor security library
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
        modules.base.packages.development = {
          luaEcosystem = mkDefault false;
          rustEcosystem = mkDefault false;
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
            tectonic # Modern LaTeX/PDF typesetting engine

            # Diagrams & Documentation
            mermaid-cli # Mermaid diagram CLI (mmdc)

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
            shellcheck #  Shell script analysis tool
            shellharden # Corrective bash syntax highlighter
            shfmt # bash format tool
            prettier # Multi-language formatter
            yamlfmt # Extensible command line tool or library to format yaml files
            rust-analyzer # Rust language server
            shellcheck # Shell script linter
            shfmt # Shell formatter
            stylua # Lua formatter
            dotenv-linter # .env file linter
            diagnostic-languageserver # LSP for linters
            gopls # Go language server
            beautysh # Shell script beautifier
            dockerfmt # Dockerfile formatter
            xmlformat # XML formatter
            libxml2 # Provides xmllint
          ]
          # Version control
          ++ optionals cfg.development.versionControl [
            gh # GitHub CLI
            gist # Gist CLI
            bfg-repo-cleaner # Git history cleaner
            gource # Git history visualizer
            onefetch # Git repo summary
            lazygit # Terminal UI for git
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
            tree-sitter # Incremental parsing (includes CLI tools)
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
            tree-sitter-grammars.tree-sitter-latex # LaTeX grammar
            tree-sitter-grammars.tree-sitter-lua # Lua grammar
            tree-sitter-grammars.tree-sitter-make # Makefile grammar
            tree-sitter-grammars.tree-sitter-markdown # Markdown grammar
            tree-sitter-grammars.tree-sitter-nix # Nix grammar
            tree-sitter-grammars.tree-sitter-norg # Norg grammar
            tree-sitter-grammars.tree-sitter-python # Python grammar
            tree-sitter-grammars.tree-sitter-regex # Regex grammar
            tree-sitter-grammars.tree-sitter-ruby # Ruby grammar
            tree-sitter-grammars.tree-sitter-rust # Rust grammar
            tree-sitter-grammars.tree-sitter-scss # SCSS grammar
            tree-sitter-grammars.tree-sitter-svelte # Svelte grammar
            tree-sitter-grammars.tree-sitter-toml # TOML grammar
            tree-sitter-grammars.tree-sitter-tsx # TSX grammar
            tree-sitter-grammars.tree-sitter-typescript # TypeScript grammar
            tree-sitter-grammars.tree-sitter-typst # Typst grammar
            tree-sitter-grammars.tree-sitter-vim # Vim grammar
            tree-sitter-grammars.tree-sitter-vue # Vue grammar
            tree-sitter-grammars.tree-sitter-yaml # YAML grammar
            python312Packages.tree-sitter-language-pack # Python tree-sitter bindings
          ]
          # Language servers
          ++ optionals cfg.development.languageServers [
            typescript-language-server # TypeScript LSP
            astro-language-server # Astro LSP
            bash-language-server # Bash LSP
            vscode-css-languageserver # CSS/SCSS/Less LSP
            docker-language-server # Dockerfile LSP
            efm-langserver # General-purpose LSP for linters/formatters
            just-lsp # Justfile LSP
            tailwindcss-language-server # Tailwind CSS LSP
          ];
      }
    ]))

    # ════════════════════════════════════════════════════════════════════════
    # GUI CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.gui.enable (mkMerge [
      # Minimal preset
      (mkIf cfg.gui.minimal {
        modules.base.packages.gui = {
          messaging = mkDefault false;
          developmentTools = mkDefault false;
          extraPackages = mkDefault false;
        };
      })

      {
        environment.systemPackages = with pkgs;
          []
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
            calibre # Comprehensive e-book software with ebook-convert

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
          ];
      }

      # GUI Libraries
      (
        mkIf cfg.gui.libs.enable {
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

              libadwaita # Modern GNOME applications library
              adwaita-icon-theme # Essential icons for libadwaita
              hicolor-icon-theme # Icon theme fallback system
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
              python313Packages.pyqt5 # Qt5 Python bindings
              python313Packages.qt-material # Qt Material Design
              python313Packages.qstylizer # Qt CSS-like styling
              python313Packages.anyqt # Qt compatibility layer
              python313Packages.pyqtdarktheme # Dark theme for Qt apps
              python313Packages.qtpy # Qt abstraction layer
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
        }
      )
    ]))

    # ════════════════════════════════════════════════════════════════════════
    # SYSTEM CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.system.enable (mkMerge [
      # Minimal preset
      (mkIf cfg.system.minimal {
        modules.base.packages.system = {
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
            yq-go # YAML processor (used by secrets management)
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
            # afuse removed from nixpkgs (deprecated fuse2 dependency)
            avfs # Virtual filesystem
            xorriso # ISO/optical disk tool — replacement for removed fuseiso

            # Archive / Storage mounting
            fuse-archive # Archive mounting
            # fuse-7z-ng removed from nixpkgs (unmaintained, fuse2 dep) — fuse-archive covers this
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
          ]
          # Document and PDF generation
          ++ optionals cfg.system.document [
            wkhtmltopdf # HTML to PDF converter
            python313Packages.weasyprint # Python HTML/CSS to PDF
          ];
      }
    ]))
  ];
}
