{pkgs, ...}:
with pkgs; [
  actionlint # Linter for GitHub Actions workflows
  any-nix-shell # Fish and zsh support for nix-shell
  bc # Arbitrary precision calculator language
  bfg-repo-cleaner # Remove large files from Git history
  boxes # ASCII art text filter
  brotli # Compression tool using brotli algorithm
  bun # Fast JavaScript runtime and bundler
  cached-nix-shell # Faster nix-shell startup
  cargo # Rust package manager
  cloudflare-cli # Cloudflare command-line interface
  cloudflared # Cloudflare tunnel daemon
  clolcat # Colorized version of lolcat
  cmake # Cross-platform build system generator
  commitlint-rs # Commit message linter written in Rust
  deadnix # Find and remove unused Nix code
  diagnostic-languageserver # General purpose language server for diagnostics
  direnv # Load/unload environment variables based on directory
  dotacat # Animate your text with cat-like animations
  dotenv-linter # Linter for .env files
  eslint_d # Fast ESLint daemon
  fuse3 # Filesystem in Userspace (version 3)
  getopt # Command-line option parsing utility
  getoptions # Bash option parser generator
  gettext # GNU internationalization utilities
  gh # GitHub CLI
  gist # GitHub Gist CLI
  git # Distributed version control system
  git-absorb # Automatic commit absorption tool
  git-backup-go # Backup git repositories
  git-extras # Extra git utilities
  git-filter-repo # Tool to rewrite git repository history
  git-ignore # Generate .gitignore files
  git-lfs # Git extension for large file storage
  git-machete # Git branch management and visualization
  git-repo-updater # Update multiple git repositories
  git-revise # Efficiently edit git commit history
  git-trim # Automatically remove merged git branches
  gitleaks # Scan git repositories for secrets
  glib # Core application building blocks library
  glow # Markdown reader for the terminal
  gnumake # GNU Make build automation tool
  gnutls # Transport Layer Security library
  go # Go programming language
  google-antigravity # Easter egg from Google
  gopls # Go language server
  gource # Software version control visualization
  grex # Generate regular expressions from test cases
  hlint # Haskell source code linter
  imlib2Full # Image loading and rendering library (full version)
  inetutils # Common network utilities
  just # Command runner similar to make
  leptosfmt # Formatter for Leptos framework
  libffi # Foreign function interface library
  libimobiledevice # Library to communicate with iOS devices
  libpkgconf # Package compiler and linker metadata toolkit
  libtiff # TIFF image format library
  libtool # Generic library support script
  lldb # LLVM debugger
  lua # Lua programming language interpreter
  lua-language-server # Language server for Lua
  lua51Packages.lua # Lua 5.1 package
  lua51Packages.luarocks # Lua package manager
  lua5_1 # Lua 5.1 interpreter
  lua5_2 # Lua 5.2 interpreter
  lua5_2_compat # Lua 5.2 compatibility layer
  lua5_3_compat # Lua 5.3 compatibility layer
  lua5_4_compat # Lua 5.4 compatibility layer
  luabind # Library for binding Lua to C++
  luaformatter # Code formatter for Lua
  luajitPackages.inspect # Human-readable representation of Lua tables
  luajitPackages.ldbus # Lua bindings for D-Bus
  luajitPackages.ldoc # LuaDoc documentation generator
  luajitPackages.lgi # Lua bindings for GObject Introspection
  luajitPackages.lua # LuaJIT interpreter
  luajitPackages.lua-messagepack # MessagePack for Lua
  luajitPackages.lua-protobuf # Protocol Buffers for Lua
  luajitPackages.luarocks-nix # LuaRocks package manager for Nix
  luajitPackages.luasocket # Network support for Lua
  luajitPackages.std-_debug # Debug library for Lua
  luajitPackages.std-normalize # Lua normalization library
  luajitPackages.stdlib # Standard library extensions for Lua
  luajitPackages.vicious # Widgets for window managers
  luajitPackages.wrapLua # Lua wrapper utility
  lynis # Security auditing tool for Unix systems
  meson # Build system focused on speed
  meson-tools # Utilities for Meson build system
  nix-init # Generate Nix package expressions
  nix-tree # Visualize Nix dependencies as a tree
  nixpkgs-fmt # Nix code formatter
  node2nix # Generate Nix expressions for Node.js packages
  nodejs # JavaScript runtime environment
  nodenv # Node.js version manager
  nps # Nix package search tool
  nvd # Nix version diff tool
  onefetch # Git repository information tool
  opencode # Open code files in your editor
  openjdk # Open source Java Development Kit
  pandoc # Universal document converter
  pandoc-lua-filters # Pandoc Lua filters collection
  pciutils # PCI utilities (lspci, setpci)
  pet # Command-line snippet manager
  pixcat # Display images in the terminal
  pkg-config # Helper tool for compiling applications
  pnpm # Fast, disk space efficient package manager
  poetry # Python dependency management tool
  prettier # Opinionated code formatter
  protobuf # Protocol Buffers - data interchange format
  protobufc # Protocol Buffers C implementation
  rmlint # Find and remove duplicate files and other lint
  ruby # Ruby programming language
  rubyfmt # Ruby code formatter
  rust-analyzer # Rust language server implementation
  rustc # Rust compiler
  rustfmt # Rust code formatter
  rustlings # Small exercises to learn Rust
  rustscan # Modern port scanner
  rustup # Rust toolchain installer
  rustywind # Tool to sort Tailwind CSS classes
  sass # CSS preprocessor
  shellcheck # Static analysis tool for shell scripts
  shellharden # Bash linting and hardening tool
  shfmt # Shell script formatter
  sqlite # SQL database engine
  sqlite-analyzer # Analyze SQLite database files
  sqlite-interactive # Interactive SQLite shell
  sqlite-utils # CLI tool for manipulating SQLite databases
  sqlitebrowser # Visual tool to create and edit SQLite databases
  squashfs-tools-ng # SquashFS filesystem tools (next generation)
  squashfsTools # SquashFS filesystem creation tools
  squashfuse # Mount SquashFS archives with FUSE
  stylua # Code formatter for Lua
  surfraw # Shell users' revolutionary front for web searching
  tailwindcss-language-server # Tailwind CSS language server
  tokei # Count lines of code
  tree-sitter # Parser generator tool and incremental parsing library
  treegen # Generate directory tree structures
  typescript # TypeScript language
  usort # Safe, minimal import sorting for Python
  usql # Universal command-line interface for SQL databases
  vscode-langservers-extracted # Language servers extracted from VS Code
  wkhtmltopdf # Convert HTML to PDF using WebKit
  xorg.libX11 # X11 client library
  xorg_sys_opengl # X.org OpenGL system integration
  yamllint # Linter for YAML files
  yarn2nix # Convert Yarn dependencies to Nix expressions
]
