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
  };

  config = mkMerge [
    # ════════════════════════════════════════════════════════════════════════
    # ARCHIVES CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.archives.enable {
      environment.systemPackages = with pkgs;
      # Basic archive formats
        optionals cfg.archives.basicFormats [
          gnutar
          zip
          unzip
          cpio
        ]
        # Modern compression tools
        ++ optionals cfg.archives.modernCompression [
          zstd
          lz4
          xz
          zlib-ng
        ]
        # Parallel compression utilities
        ++ optionals cfg.archives.parallelTools [
          crabz
          pigz
          pixz
          plzip
          pxz
        ]
        # Specialized formats
        ++ optionals cfg.archives.specializedFormats [
          _7zz
          p7zip-rar
          p7zip
          rar
          fastjar
          mozlz4a
          lrzip
        ]
        # Integration libraries
        ++ optionals cfg.archives.integrationLibs [
          advancecomp
          archivemount
          dtrx
          gnome-autoar
          libarchive
          ouch
        ];
    })

    # ════════════════════════════════════════════════════════════════════════
    # CORE CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.core.enable {
      environment.systemPackages = with pkgs; [
        OVMFFull
        age
        agenix-cli
        cbfmt
        ccls
        commons-compress
        coreutils-full
        dmg2img
        dnsutils
        espeak-ng
        fcft
        ffmpeg-full
        font-alias
        font-util
        fontconfig
        fontforge-gtk
        fontforge-fonttools
        gnome-themes-extra
        komika-fonts
        libglibutil
        minizip-ng
        networkmanager
        ngrok
        nmap
        papirus-folders
        poppler_gi
        pulseaudio
        python312Packages.fonttools
        python312Packages.compreffor
        service-wrapper
        sops
        sox
        ssh-to-age
        sssd
        tealdeer
        uutils-coreutils
        webfontkitgenerator
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
            git
            jq
            neovim
            # Additional core utilities
            any-nix-shell
            boxes
            brotli
            cached-nix-shell
            direnv
            fuse3
            getopt
            glib
            glow
            grex
            imlib2Full
            inetutils
            libffi
            libimobiledevice
            nix-init
            nix-tree
            nvd
            poetry
            rmlint
            squashfs-tools-ng
            squashfuse
            surfraw
            tokei
            fswatch
            lynx
            feather
            bc
            cmake
            gettext
          ]
          # Linters
          ++ optionals cfg.development.linters [
            actionlint
            commitlint-rs
            deadnix
            eslint_d
            hlint
            nixpkgs-fmt
            prettier
            rust-analyzer
            shellcheck
            shfmt
            stylua
            dotenv-linter
            diagnostic-languageserver
            beautysh
          ]
          # Version control
          ++ optionals cfg.development.versionControl [
            bfg-repo-cleaner
            gh
            gist
            git-extras
            git-lfs
            gource
            onefetch
            libgit2
            libgit2-glib
          ]
          # Build tools
          ++ optionals cfg.development.buildTools [
            gnumake
            just
            meson
            pkg-config
            protobuf
            automake
            binutils
          ]
          # Runtime languages
          ++ optionals cfg.development.runtimeLanguages [
            bun
            cargo
            go
            gopls
            lua
            nodejs
            openjdk
            pnpm
            ruby
            typescript
          ]
          # Lua ecosystem
          ++ optionals cfg.development.luaEcosystem [
            lua51Packages.lua
            lua52Packages.lua
            lua53Packages.lua
            lua54Packages.lua
            luajit
            luajitPackages.luacheck
            luajitPackages.luarocks
            luajitPackages.luasocket
            luarocks
          ]
          # Rust ecosystem
          ++ optionals cfg.development.rustEcosystem [
            rustc
            rustlings
            rustscan
            rustup
            rustywind
          ]
          # Android development
          ++ optionals cfg.development.androidDevelopment [
            abootimg
            android-tools
            apkeep
            apksigner
            apktool
            bundletool
            dex2jar
            simg2img
          ]
          # Nix utilities
          ++ optionals cfg.development.nixUtilities [
            manix
            nix-index
            nixos-generators
          ]
          # System compilers
          ++ optionals cfg.development.systemCompilers [
            clang
            gcc-unwrapped
            patchelf
          ]
          # Web development
          ++ optionals cfg.development.webDevelopment [
            cloudflare-cli
            cloudflared
            node2nix
            nodenv
            sass
            yarn
            yarn-berry
            gi-docgen
            gibo
          ]
          # Databases
          ++ optionals cfg.development.databases [
            sqlite
            sqlite-utils
            usql
            sqlitebrowser
          ]
          # Editors
          ++ optionals cfg.development.editors [
            lldb
            opencode
            pandoc
          ]
          # Tree-sitter grammars
          ++ optionals cfg.development.treeSitterGrammars [
            tree-sitter
            tree-sitter-grammars.tree-sitter-bash
            tree-sitter-grammars.tree-sitter-c
            tree-sitter-grammars.tree-sitter-cmake
            tree-sitter-grammars.tree-sitter-comment
            tree-sitter-grammars.tree-sitter-cpp
            tree-sitter-grammars.tree-sitter-css
            tree-sitter-grammars.tree-sitter-dockerfile
            tree-sitter-grammars.tree-sitter-fish
            tree-sitter-grammars.tree-sitter-go
            tree-sitter-grammars.tree-sitter-gomod
            tree-sitter-grammars.tree-sitter-html
            tree-sitter-grammars.tree-sitter-java
            tree-sitter-grammars.tree-sitter-javascript
            tree-sitter-grammars.tree-sitter-jsdoc
            tree-sitter-grammars.tree-sitter-json
            tree-sitter-grammars.tree-sitter-json5
            tree-sitter-grammars.tree-sitter-lua
            tree-sitter-grammars.tree-sitter-make
            tree-sitter-grammars.tree-sitter-markdown
            tree-sitter-grammars.tree-sitter-nix
            tree-sitter-grammars.tree-sitter-python
            tree-sitter-grammars.tree-sitter-regex
            tree-sitter-grammars.tree-sitter-ruby
            tree-sitter-grammars.tree-sitter-rust
            tree-sitter-grammars.tree-sitter-scss
            tree-sitter-grammars.tree-sitter-toml
            tree-sitter-grammars.tree-sitter-tsx
            tree-sitter-grammars.tree-sitter-typescript
            tree-sitter-grammars.tree-sitter-vim
            tree-sitter-grammars.tree-sitter-yaml
          ];
      }
    ]))

    # ════════════════════════════════════════════════════════════════════════
    # FONTS CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.fonts.enable {
      fonts = {
        packages = with pkgs;
        # Nerd Fonts
          optionals cfg.fonts.nerdFonts [
            nerd-fonts.agave
            nerd-fonts.d2coding
            nerd-fonts.proggy-clean-tt
            nerd-fonts.ubuntu
            nerd-fonts.ubuntu-mono
            nerd-fonts.ubuntu-sans
            nerd-fonts.noto
          ]
          # Icon Fonts
          ++ optionals cfg.fonts.iconFonts [
            icomoon-feather
            emacs-all-the-icons-fonts
            font-awesome_4
            font-awesome_5
            font-awesome_6
            material-design-icons
            material-symbols
            siji
          ]
          # System Fonts
          ++ optionals cfg.fonts.systemFonts [
            annapurna-sil
            corefonts
            jost
            kanit-font
            mplus-outline-fonts.githubRelease
            norwester-font
            pixel-code
            terminus_font
            vista-fonts
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
          defaultFonts = {
            serif = ["Agave Nerd Font"];
            sansSerif = ["Ubuntu Nerd Font"];
            monospace = ["UbuntuMono Nerd Font"];
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
            bleachbit
            file-roller
            fontpreview
            gcolor3
            gnome-characters
            gnome-disk-utility
            gnome-font-viewer
            gnome-themes-extra
            gparted
            gthumb
            hunspell
            hunspellDicts.en-us
            kdePackages.breeze-icons
            kdePackages.qt6ct
            kdePackages.qtbase
            libappindicator-gtk3
            libnotify
            mimetic
            mupdf
            networkmanagerapplet
            pastel
            pavucontrol
            poppler-utils
            themechanger
            xarchiver
            xclip
            xdg-desktop-portal
            xdotool
            xfontsel
            xscreensaver
          ]
          # Application launcher
          ++ optionals cfg.gui.applicationLauncher [
            rofi
            rofi-rbw
            xdg-launch
            xdgmenumaker
          ]
          # Media tools
          ++ optionals cfg.gui.mediaTools [
            transmission_4-gtk
            ocrmypdf
            pdftk
          ]
          # Development tools
          ++ optionals cfg.gui.developmentTools [
            appimage-run
            vscode-fhs
            ventoy-full
          ]
          # Window management
          ++ optionals cfg.gui.windowManagement [
            maim
            picom
            wmctrl
          ]
          # Messaging
          ++ optionals cfg.gui.messaging [
            telegram-desktop
            element-desktop
            vesktop
          ];
      }

      # GUI Libraries
      (mkIf cfg.gui.libs.enable {
        environment.systemPackages = with pkgs;
        # Core graphics
          optionals cfg.gui.libs.coreGraphics [
            cairo
            cairomm
            pango
            pangomm
            gdk-pixbuf
            gdk-pixbuf-xlib
          ]
          # GObject support
          ++ optionals cfg.gui.libs.gobjectSupport [
            gobject-introspection
            gobject-introspection-unwrapped
            libgee
            libpeas
            libpeas2
          ]
          # Desktop integration
          ++ optionals cfg.gui.libs.desktopIntegration [
            dbus-broker
            dconf
            gsettings-desktop-schemas
            gnome.nixos-gsettings-overrides
            libnotify
            polkit_gnome
            menu-cache
            garcon
            pantheon.granite
          ]
          # XFCE support
          ++ optionals cfg.gui.libs.xfceSupport [
            libxfce4ui
            libxfce4util
            xfce4-exo
            xfconf
          ]
          # Audio and terminal
          ++ optionals cfg.gui.libs.audioTerminal [
            libcanberra-gtk3
            portaudio
            vte-gtk4
          ]
          # Python bindings
          ++ optionals cfg.gui.libs.pythonBindings [
            python312Packages.pycairo
            python312Packages.pygobject3
            python312Packages.pyqt6
            python312Packages.pyqt6-charts
            python312Packages.pyqt6-webengine
          ]
          # Ruby bindings
          ++ optionals cfg.gui.libs.rubyBindings [
            rubyPackages.cairo
            rubyPackages.gdk_pixbuf2
            rubyPackages.gobject-introspection
          ]
          # Font support
          ++ optionals cfg.gui.libs.fontSupport [
            terminus_font
            xrdb
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
            ffmpeg-full
            vlc
          ]
          # Video tools
          ++ optionals cfg.multimedia.videoTools [
            cheese
            ffcast
            flowblade
            frei0r
            fswebcam
            gallery-dl
            losslesscut-bin
            mjpegtools
            mp4v2
            oggvideotools
            peek
            spotdl
            vid-stab
            vidmerger
            vvenc
            yt-dlp
            xvidcore
            libtheora
            libvpl
            libwebcam
            lv2
          ]
          # Image tools
          ++ optionals cfg.multimedia.imageTools [
            ascii-image-converter
            autotrace
            babl
            cairosvg
            colorz
            curtail
            exiftool
            feh
            figlet
            gdk-pixbuf
            gegl
            geticons
            giflib
            gifsicle
            giph
            gmic
            gnome-obfuscate
            gradia
            graphicsmagick
            image-roll
            image_optim
            imagemagick
            imlib2
            imlib2Full
            img-cat
            imgcat
            imgpatchtools
            jp2a
            jpeginfo
            jpegoptim
            libexif
            libjpeg
            libpng
            librsvg
            libspng
            libwebp
            lsix
            meme-image-generator
            metapixel
            mozjpeg
            svgo
            optipng
            oxipng
            perlPackages.ImageMagick
            perlPackages.PerlMagick
            pngcrush
            pngquant
            pngtoico
            pngtools
            potrace
            python312Packages.colorthief
            python312Packages.pyfiglet
            python312Packages.pystache
            python312Packages.svgwrite
            redoflacs
            resvg
            satty
            scour
            smile
            svgcleaner
            t1utils
            termcolor
            toilet
            uni
            upscayl
            ncurses
            xcolor
            emote
          ]
          # Streaming tools
          ++ optionals cfg.multimedia.streamingTools [
            menyoki
            megapixels
            pipewire
            switcheroo
            traverso
            webp-pixbuf-loader
          ]
          # GStreamer plugins
          ++ optionals cfg.multimedia.gstreamerPlugins [
            gst_all_1.gst-editing-services
            gst_all_1.gst-libav
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-rs
            gst_all_1.gst-plugins-ugly
            gst_all_1.gst-vaapi
            gst_all_1.gstreamer
          ]
          # Content creators (gimp, inkscape only)
          ++ optionals cfg.multimedia.creators [
            gimp3-with-plugins
            gimp3Plugins.gmic
            inkscape-with-extensions
          ]
          # Stable video editors
          ++ optionals cfg.multimedia.stableVideoEditors [
            pkgs.stable.olive-editor
            pkgs.stable.shotcut
            pkgs.stable.openshot-qt
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
          gh
          libgit2
          libgit2-glib
        ]
        # Wireless tools
        ++ optionals cfg.network.wirelessTools [
          iw
          wirelesstools
        ]
        # Download tools
        ++ optionals cfg.network.downloadTools [
          rclone
          yt-dlp
        ]
        # Compression libraries
        ++ optionals cfg.network.compressionLibs [
          zlib
        ];
    })

    # ════════════════════════════════════════════════════════════════════════
    # PYTHON CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.python.enable {
      environment.systemPackages = with pkgs;
      # Core Python
        [
          python312
        ]
        # Development tools
        ++ optionals cfg.python.development [
          python312Packages.flake8
          python312Packages.pylint
          python312Packages.pip-tools
          python312Packages.pipx
          python312Packages.setuptoolsBuildHook
          python312Packages.meson-python
        ]
        # Web development
        ++ optionals cfg.python.webDevelopment [
          python312Packages.beautifulsoup4
          python312Packages.websockets
          python312Packages.python-dotenv
        ]
        # Data processing
        ++ optionals cfg.python.dataProcessing [
          python312Packages.pydantic
          python312Packages.pydantic-core
          python312Packages.levenshtein
          python312Packages.pylatexenc
        ]
        # System integration
        ++ optionals cfg.python.systemIntegration [
          python312Packages.gitpython
          python312Packages.gitdb
          python312Packages.youtube-transcript-api
          python312Packages.playsound
        ]
        # Graphics
        ++ optionals cfg.python.graphics [
          python312Packages.pycairo
          python312Packages.pygobject3
          python312Packages.pylatex
        ]
        # External Python tools
        ++ [
          black
          ruff
          pylint
          pipenv
          streamlit
          virtualenv
          virtualenv-clone
          gobject-introspection
        ];
    })

    # ════════════════════════════════════════════════════════════════════════
    # SHELL CONFIG
    # ════════════════════════════════════════════════════════════════════════
    (mkIf cfg.shell.enable {
      environment.systemPackages = with pkgs;
      # Core shell utilities
        [
          bash-completion
          curl
        ]
        # Modern tools
        ++ optionals cfg.shell.modernTools [
          bat
          btop
          eza
          fd
          fzf
          fzy
          silver-searcher
        ]
        # System utilities
        ++ optionals cfg.shell.systemUtils [
          beep
          clipster
          jdupes
          killall
          trash-cli
        ]
        # File management
        ++ optionals cfg.shell.fileManagement [
          deer
          ranger
          tree
          walk
        ]
        # Download tools
        ++ optionals cfg.shell.downloadTools [
          aria2
          rclone
          speedtest-cli
        ]
        # ZSH plugins
        ++ optionals cfg.shell.zshPlugins [
          pure-prompt
          zsh-autocomplete
          zsh-edit
          zsh-navigation-tools
          zsh-you-should-use
        ]
        # Input support
        ++ optionals cfg.shell.inputSupport [
          libdbusmenu
          libdbusmenu-gtk3
          libinput
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
            acpi
            automake
            binutils
            comma
            fd
            file
            gh
            iw
            jq
            moreutils
            fastfetch
            parallel
            pciutils
            ripgrep-all
            usbmuxd
            usbutils
            util-linux
            wget
            whois
            wirelesstools
            yad
            zip
          ]
          # Filesystem utilities
          ++ optionals cfg.system.filesystem [
            afuse
            avfs
            dosfstools
            exfatprogs
            ntfs3g
            ntfsprogs
            testdisk
            xorriso
          ]
          # Hardware monitoring
          ++ optionals cfg.system.hardware [
            brightnessctl
            ddcui
            ddcutil
            efibootmgr
            intel-graphics-compiler
            lm_sensors
            lshw
            intel-media-driver
            smartmontools
            sysfsutils
          ]
          # Performance monitoring
          ++ optionals cfg.system.performance [
            htop
            nmon
            procps
            ps_mem
            sysprof
            sysstat
            systeroid
            sysz
          ]
          # Desktop utilities
          ++ optionals cfg.system.desktop [
            dbus-broker
            dconf
            gnome-keyring
            polkit_gnome
            shared-mime-info
            tumbler
            xdg-desktop-portal-gtk
            xdg-user-dirs
            xdg-utils
            xbacklight
            xev
            xhost
            xinit
            xkill
            xprop
            xwininfo
            xsecurelock
            xss-lock
            xsuspender
          ]
          # Multimedia system tools
          ++ optionals cfg.system.multimedia [
            cdrtools
            curtail
            ghostscript
            lame
            portaudio
          ];
      }
    ]))
  ];
}
