{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.packages.devtools = {
    enable = mkEnableOption "Development tools and programming utilities";

    linters = mkEnableOption "Code linters and formatters" // {default = true;};
    versionControl = mkEnableOption "Version control tools and utilities" // {default = true;};
    buildTools = mkEnableOption "Build systems and compilation tools" // {default = true;};
    runtimeLanguages = mkEnableOption "Programming language runtimes" // {default = true;};
    luaEcosystem = mkEnableOption "Complete Lua development ecosystem" // {default = false;};
    rustEcosystem = mkEnableOption "Complete Rust development ecosystem" // {default = false;};
    androidDevelopment = mkEnableOption "Android/APK development and analysis tools" // {default = false;};
    nixUtilities = mkEnableOption "Nix development and exploration utilities" // {default = true;};
    systemCompilers = mkEnableOption "System compilers and low-level tools" // {default = false;};
    webDevelopment = mkEnableOption "Web development tools" // {default = true;};
    databases = mkEnableOption "Database tools and utilities" // {default = true;};
    editors = mkEnableOption "Text editors and IDEs" // {default = true;};
    treeSitterGrammars = mkEnableOption "Tree-sitter language grammars" // {default = true;};
    minimal = mkEnableOption "Minimal devtools for live/ISO environments";
  };

  config = mkMerge [
    # Minimal preset: disable heavy toolchains, keep essentials
    (mkIf config.modules.packages.devtools.minimal {
      modules.packages.devtools = {
        linters = mkDefault false;
        buildTools = mkDefault false;
        runtimeLanguages = mkDefault false;
        webDevelopment = mkDefault false;
        databases = mkDefault false;
        treeSitterGrammars = mkDefault false;
      };
    })

    (mkIf config.modules.packages.devtools.enable {
      environment.systemPackages = with pkgs;
        []
        # Core development tools
        ++ [
          git
          jq
          neovim
        ]
        # Linters and formatters
        ++ optionals config.modules.packages.devtools.linters [
          actionlint
          commitlint-rs
          deadnix
          diagnostic-languageserver
          dotenv-linter
          eslint_d
          gitleaks
          hlint
          leptosfmt
          luaformatter
          nixpkgs-fmt
          prettier
          rubyfmt
          rust-analyzer
          rustfmt
          shellcheck
          shellharden
          shfmt
          stylua
          tailwindcss-language-server
          usort
          vscode-langservers-extracted
          yamllint
        ]
        # Version control tools
        ++ optionals config.modules.packages.devtools.versionControl [
          bfg-repo-cleaner
          gh
          gist
          git-absorb
          git-backup-go
          git-extras
          git-filter-repo
          git-ignore
          git-lfs
          git-machete
          git-repo-updater
          git-revise
          git-trim
          gource
          onefetch
        ]
        # Build tools and compilation
        ++ optionals config.modules.packages.devtools.buildTools [
          bc
          cmake
          gnumake
          just
          meson
          meson-tools
          pkg-config
          protobuf
          protobufc
          wkhtmltopdf
          libx11
          xorg_sys_opengl
        ]
        # Programming language runtimes
        ++ optionals config.modules.packages.devtools.runtimeLanguages [
          bun
          cargo
          go
          gopls
          lua
          lua-language-server
          nodejs
          nodePackages_latest.nodejs
          openjdk
          pnpm
          python312Packages.pynvim
          ruby
          typescript
        ]
        # Lua ecosystem
        ++ optionals config.modules.packages.devtools.luaEcosystem [
          lua51Packages.lua
          lua51Packages.luarocks
          lua51Packages.luarocks-nix
          lua5_1
          lua5_2
          lua5_2_compat
          lua5_3_compat
          lua5_4_compat
          luabind
          luajitPackages.inspect
          luajitPackages.ldbus
          luajitPackages.ldoc
          luajitPackages.lgi
          luajitPackages.lua
          luajitPackages.lua-messagepack
          luajitPackages.lua-protobuf
          luajitPackages.luarocks
          luajitPackages.luarocks-nix
          luajitPackages.luasocket
          luajitPackages.std-_debug
          luajitPackages.std-normalize
          luajitPackages.stdlib
          luajitPackages.vicious
          luajitPackages.wrapLua
        ]
        # Rust ecosystem
        ++ optionals config.modules.packages.devtools.rustEcosystem [
          rustc
          rustlings
          rustscan
          rustup
          rustywind
        ]
        # Android/APK development and analysis
        ++ optionals config.modules.packages.devtools.androidDevelopment [
          abootimg # Android boot image tools
          android-tools # Android platform tools (adb, fastboot)
          apkeep # APK downloader
          apksigner # APK signing tool
          apktool # Tool for reverse engineering Android APK files
          bundletool # Android App Bundle tool
          dex2jar # Tools to work with Android .dex and Java .class files
          simg2img # Sparse image to image converter
        ]
        # Nix development utilities
        ++ optionals config.modules.packages.devtools.nixUtilities [
          manix # Fast documentation searcher for Nix
          nix-index # Nix package and option search
          nixos-generators # NixOS image generators for different formats
        ]
        # System compilers and low-level tools
        ++ optionals config.modules.packages.devtools.systemCompilers [
          clang # C/C++ compiler
          gcc-unwrapped # GCC compiler unwrapped
          patchelf # Modify ELF executables and libraries
        ]
        # Web development
        ++ optionals config.modules.packages.devtools.webDevelopment [
          cloudflare-cli
          cloudflared
          node2nix
          nodenv
          pnpm
          sass
          yarn
          yarn2nix
        ]
        # Database tools
        ++ optionals config.modules.packages.devtools.databases [
          sqlite
          sqlite-analyzer
          sqlite-interactive
          sqlite-utils
          sqlitebrowser
          usql
        ]
        # Editors and development environment
        ++ optionals config.modules.packages.devtools.editors [
          lldb
          opencode
          pandoc
          pandoc-lua-filters
        ]
        # Tree-sitter grammars
        ++ optionals config.modules.packages.devtools.treeSitterGrammars [
          tree-sitter
          tree-sitter-grammars.tree-sitter-c
          tree-sitter-grammars.tree-sitter-ql
          tree-sitter-grammars.tree-sitter-go
          tree-sitter-grammars.tree-sitter-vue
          tree-sitter-grammars.tree-sitter-rust
          tree-sitter-grammars.tree-sitter-vim
          tree-sitter-grammars.tree-sitter-tsx
          tree-sitter-grammars.tree-sitter-sql
          tree-sitter-grammars.tree-sitter-rst
          tree-sitter-grammars.tree-sitter-nix
          tree-sitter-grammars.tree-sitter-lua
          tree-sitter-grammars.tree-sitter-dot
          tree-sitter-grammars.tree-sitter-css
          tree-sitter-grammars.tree-sitter-cpp
          tree-sitter-grammars.tree-sitter-yaml
          tree-sitter-grammars.tree-sitter-toml
          tree-sitter-grammars.tree-sitter-scss
          tree-sitter-grammars.tree-sitter-ruby
          tree-sitter-grammars.tree-sitter-regex
          tree-sitter-grammars.tree-sitter-make
          tree-sitter-grammars.tree-sitter-just
          tree-sitter-grammars.tree-sitter-json
          tree-sitter-grammars.tree-sitter-cuda
          tree-sitter-grammars.tree-sitter-html
          tree-sitter-grammars.tree-sitter-bash
          tree-sitter-grammars.tree-sitter-python
          tree-sitter-grammars.tree-sitter-graphql
          tree-sitter-grammars.tree-sitter-markdown
          tree-sitter-grammars.tree-sitter-typescript
          tree-sitter-grammars.tree-sitter-javascript
          tree-sitter-grammars.tree-sitter-dockerfile
        ]
        # Additional utilities
        ++ [
          any-nix-shell
          boxes
          brotli
          cached-nix-shell
          clolcat
          direnv
          dotacat
          fuse3
          getopt
          getoptions
          gettext
          glib
          glow
          gnutls
          grex
          imlib2Full
          inetutils
          libffi
          libimobiledevice
          libpkgconf
          libtiff
          libtool
          lynis
          nix-init
          nix-tree
          nps
          nvd
          pciutils
          pet
          pixcat
          poetry
          rmlint
          squashfs-tools-ng
          squashfsTools
          squashfuse
          surfraw
          tokei
          treegen
          fswatch
          lynx
          feather
        ];
    })
  ];
}
