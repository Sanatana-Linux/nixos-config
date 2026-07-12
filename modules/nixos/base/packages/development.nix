{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.packages.development;
in {
  options.modules.base.packages.development = {
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

  config = mkIf cfg.enable (mkMerge [
    # Minimal preset for ISO
    (mkIf cfg.minimal {
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

          json-glib
          json-repair
          json-sort-cli

          # Browsing & Search
          surfraw # Shell web search
          lynx # Text web browser
          feather # Lightweight note-taking
        ]
        # Linters
        ++ optionals cfg.linters [
          css-variables-language-server
          actionlint # GitHub Actions linter
          commitlint-rs # Commit message linter
          deadnix # Dead code detector for Nix
          eslint_d # ESLint daemon
          hlint # Haskell linter
          nixpkgs-fmt # Nix formatter
          shellcheck # Shell script analysis tool
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
        ++ optionals cfg.versionControl [
          gh # GitHub CLI
          gist # Gist CLI
          bfg-repo-cleaner # Git history cleaner
          gource # Git history visualizer
          onefetch # Git repo summary
          lazygit # Terminal UI for git
        ]
        # Build tools
        ++ optionals cfg.buildTools [
          gnumake # Make build tool
          just # Command runner (make alternative)
          meson # Fast build system
          pkg-config # Library compiler flags
          protobuf # Protocol buffers
          automake # GNU automake
          binutils # Binary utilities
        ]
        # Runtime languages
        ++ optionals cfg.runtimeLanguages [
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
        ++ optionals cfg.luaEcosystem [
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
        ++ optionals cfg.rustEcosystem [
          rustc # Rust compiler
          rustlings # Rust learning exercises
          rustscan # Fast Rust scanner
          rustup # Rust toolchain manager
          rustywind # Tailwind class sorter
        ]
        # Nix utilities
        ++ optionals cfg.nixUtilities [
          manix # Nix documentation searcher
          nix-index # Nix package file index
          nixos-generators # NixOS image generators
        ]
        # System compilers
        ++ optionals cfg.systemCompilers [
          patchelf # ELF patching tool
        ]
        # Web development
        ++ optionals cfg.webDevelopment [
          nodenv # Node version manager
          yarn # Node package manager
          gibo # Gitignore boilerplates
        ]
        # Databases
        ++ optionals cfg.databases [
          sqlite # SQLite database
          sqlite-utils # SQLite utilities
          usql # Universal SQL CLI
          sqlitebrowser # SQLite GUI browser
        ]
        # Editors
        ++ optionals cfg.editors [
          lldb # LLVM debugger
          opencode # AI coding assistant
        ]
        # Tree-sitter grammars
        ++ optionals cfg.treeSitterGrammars [
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
        ++ optionals cfg.languageServers [
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
  ]);
}
