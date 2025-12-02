{pkgs, ...}:
with pkgs; [
  #nodePackages_latest.neovim
  #nodePackages_latest.diagnostic-languageserver
  #nodePackages_latest.gulp
  #nodePackages_latest.nodejs
  #nodePackages_latest.prettier
  # General CLI tools and utilities
  actionlint # Linter for GitHub Actions workflows
  any-nix-shell # Shell integration for Nix
  bc # Arbitrary precision calculator language
  opencode # Open files in your editor from the command line
  prettier # Code formatter for multiple languages

  # Cloudflare tools
  cloudflare-cli # Cloudflare command-line interface
  cloudflared # Cloudflare tunneling daemon



  # Git and repository management
  bfg-repo-cleaner # Remove large files from Git history
  black # Python code formatter
  treegen # Generate directory trees
  brotli # Compression tool
  cached-nix-shell # Faster nix-shell startup
  cargo # Rust package manager
  cloudflare-cli # (duplicate) Cloudflare CLI
  cmake # Build system generator
  commitlint-rs # Commit message linter
  deadnix # Find unused Nix code
  diagnostic-languageserver # Language server for diagnostics
  direnv # Environment switcher for shells
  dotenv-linter # Linter for .env files
  eslint_d # Fast ESLint daemon
  fuse3 # Filesystem in Userspace
  getopt # Command-line option parser
  getoptions # Bash option parser
  gettext # Internationalization tools
  gist # GitHub Gist CLI
  git # Version control system
  git-backup-go # Backup git repositories
  git-extras # Extra git utilities
  git-filter-repo # Tool to rewrite git history
  git-filter-repo # (duplicate) Tool to rewrite git history
  git-ignore # Generate .gitignore files
  git-lfs # Git Large File Storage
  git-repo-updater # Update multiple git repos
  git-revise # Amend and edit git commits
  git-trim # Remove merged branches
  git-trim # (duplicate) Remove merged branches

  # GitHub tools
  gh # GitHub CLI
  git-absorb # Auto-squash fixup commits
  git-machete # Git branch management

  # Security and code quality
  gitleaks # Scan for secrets in git repos
  gitleaks # (duplicate) Scan for secrets in git repos

  # Miscellaneous development tools
  glib # Core application library
  glow # Markdown previewer
  gnumake # Build automation tool
  gnutls # TLS library
  go # Go programming language
  go # (duplicate) Go programming language
  gopls # Go language server
  gource # Git repository visualizer
  grex # Regex generator
  hlint # Haskell linter
  imlib2Full # Image library
  inetutils # Network utilities
  just # Command runner
  latex2html # Convert LaTeX to HTML
  leptosfmt # Formatter for Leptos
  libffi # Foreign function interface library
  libglibutil # GLib utility library
  libimobiledevice # iOS device library
  libpkgconf # Package configuration tool
  libtiff # TIFF image library
  libtool # Generic library support script
  lldb # LLVM debugger

  # Lua and related tools
  lua # Lua interpreter
  lua-language-server # Lua language server
  lua51Packages.lua # Lua 5.1 package
  lua51Packages.luarocks # Lua package manager
  lua5_1 # Lua 5.1 interpreter
  lua5_2 # Lua 5.2 interpreter
  lua5_2_compat # Lua 5.2 compatibility
  lua5_3_compat # Lua 5.3 compatibility
  lua5_4_compat # Lua 5.4 compatibility
  luabind # Lua binding library
  luaformatter # Lua code formatter
  luajitPackages.inspect # LuaJIT inspection library
  luajitPackages.ldbus # LuaJIT D-Bus bindings
  luajitPackages.ldoc # LuaJIT documentation generator
  luajitPackages.lgi # LuaJIT GObject Introspection
  luajitPackages.lua # LuaJIT interpreter
  luajitPackages.lua-messagepack # LuaJIT MessagePack
  luajitPackages.lua-protobuf # LuaJIT Protobuf
  luajitPackages.luarocks-nix # LuaJIT Luarocks for Nix
  luajitPackages.luasocket # LuaJIT networking library
  luajitPackages.std-_debug # LuaJIT debug library
  luajitPackages.std-normalize # LuaJIT normalization library
  luajitPackages.stdlib # LuaJIT standard library
  luajitPackages.vicious # LuaJIT widgets
  luajitPackages.wrapLua # LuaJIT wrapper
  lynis # Security auditing tool
  meson # Build system
  meson-tools # Meson utilities
  nix-init # Nix package initializer
  nix-tree # Visualize Nix store
  nixpkgs-fmt # Nix code formatter
  node2nix # Convert Node.js packages to Nix
  nodejs # Node.js runtime
  nodenv # Node.js version manager
  nps # Nix package search
  nss # Network Security Services
  nvd # Nix package diff
  onefetch # Git repository summary
  openjdk # Java Development Kit
  pandoc # Document converter
  pandoc-lua-filters # Pandoc Lua filters
  pciutils # PCI utilities
  pet # Command-line snippet manager
  pipx # Python package runner
  pixcat # Image viewer
  pkg-config # Package configuration tool
  poetry # Python dependency manager
  protobuf # Protocol Buffers
  protobufc # Protocol Buffers C implementation
  pylint # Python linter
  rmlint # Duplicate file finder
  ruby # Ruby programming language
  rubyfmt # Ruby code formatter
  rust-analyzer # Rust language server
  rustc # Rust compiler
  rustfmt # Rust code formatter
  rustlings # Rust exercises
  rustscan # Rust-based port scanner
  rustup # Rust toolchain installer
  rustywind # Tailwind CSS sorter
  sass # CSS preprocessor
  sassc # Sass compiler
  shellcheck # Shell script linter
  shellharden # Shell script hardener
  shfmt # Shell script formatter
  sqlite # SQL database engine
  sqlite-analyzer # SQLite database analyzer
  sqlite-interactive # SQLite interactive shell
  sqlite-utils # SQLite utilities
  sqlite-utils # (duplicate) SQLite utilities
  sqlitebrowser # SQLite database browser
  stylua # Lua code formatter
  stylua # (duplicate) Lua code formatter
  lua-language-server # Lua language server
  tailwindcss-language-server # Tailwind CSS language server
  tokei # Code statistics
  tree-sitter # Incremental parsing library
  typescript # TypeScript language
  pnpm # Node.js package manager
  squashfs-tools-ng # SquashFS tools (next-gen)
  squashfsTools # SquashFS tools
  squashfuse # SquashFS FUSE
  usort # Python import sorter
  usql # Universal SQL client
  vscode-langservers-extracted # VSCode language servers
  wkhtmltopdf # HTML to PDF converter
  xorg.libX11 # X11 library
  xorg_sys_opengl # Xorg OpenGL system
  yamllint # YAML linter
  yarn2nix # Convert Yarn packages to Nix
  dotacat # Dota 2 stats tool
  clolcat # Colorized lolcat
  boxes # ASCII art boxes
  zlib # Compression library
  surfraw # Shell interface to web search
]
