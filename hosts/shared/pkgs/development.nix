{ pkgs, ... }:
with pkgs; [
  any-nix-shell
  awscli
  bash
  biber
  bibtex2html
  black
  brotli
  cached-nix-shell
  cargo
  cargo-binutils
  cbfmt
  chruby
  cmake
  cpp-hocon
  cpp-utilities
  cppclean
  cppdb
  cutter
  deadnix
  dejsonlz4
  direnv
  efm-langserver
  ejson
  ejson2env
  expat
  fclones
  fcppt
  flutter
  fuse3
  gdk-pixbuf
  gdk-pixbuf-xlib
  getopt
  getoptions
  git
  git-revise
  gitleaks

  git-backup
  git-extras
  git-filter-repo
  git-ignore
  git-repo-updater
  git-trim
  glib
  glow
  glxinfo
  gnumake
  gnutls
  go
  go-protobuf
  gofumpt
  gource
  hoard
  icu
  imlib2Full
  ipfs
  ispell
  isync
  joplin-desktop
  just
  kotlin
  kotlin-language-server
  kotlin-native
  ktlint
  libffi
  libimobiledevice
  libpkgconf
  libtiff
  libtool
  lightningcss
  logseq
  lua
  lua-language-server
  lua51Packages.lgi
  lua51Packages.lua
  lua51Packages.luarocks-nix
  lua5_3_compat
  lua5_4_compat
  luabind
  luaformatter
  luajitPackages.busted
  luajitPackages.cqueues
  luajitPackages.dkjson
  luajitPackages.ldbus
  luajitPackages.ldoc
  luajitPackages.lgi
  luajitPackages.lpeg
  luajitPackages.lpeg_patterns
  luajitPackages.lpeglabel
  luajitPackages.lua
  luajitPackages.lua-curl
  luajitPackages.lua-lsp
  luajitPackages.lua-messagepack
  luajitPackages.lua-protobuf
  luajitPackages.lua-subprocess
  luajitPackages.luacheck
  luajitPackages.luarocks
  luajitPackages.luarocks-nix
  luajitPackages.luasocket
  luajitPackages.luasql-sqlite3
  luajitPackages.mediator_lua
  luajitPackages.mpack
  luajitPackages.std-_debug
  luajitPackages.std-normalize
  luajitPackages.stdlib
  luajitPackages.vicious
  luajitPackages.vusted
  luajitPackages.wrapLua
  lynis
  marksman
  mu
  ncdu
  neovim-unwrapped
  nil
  nix-init
  nix-tree
  nixfmt
  nixpkgs-fmt
  node2nix
  nodePackages.prettier
  nodePackages_latest.diagnostic-languageserver
  nodePackages_latest.eslint
  nodePackages_latest.gulp
  nodePackages_latest.neovim
  nodePackages_latest.vscode-json-languageserver-bin
  nodejs
  nps
  nss
  nvd
  onefetch
  openjdk
  pandoc
  pandoc-lua-filters
  pciutils
  pet
  pkg-config
  pkg-config-unwrapped
  pkg-configUpstream
  prisma-engines
  protobuf
  protobufc
  puppeteer-cli
  python311Packages.PyICU
  python311Packages.brotlicffi
  python311Packages.brotlipy
  python311Packages.googleapis-common-protos
  python311Packages.mdformat
  python311Packages.protobuf
  python311Packages.pylsp-mypy
  python311Packages.websockets
  python311Packages.wheel
  ruby
  rustc
  rustfmt
  rustscan
  rustup
  sass
  sassc
  scribus
  shellcheck
  shellharden
  shfmt
  skim
  sqlite
  sqlite-utils
  stdenv.cc.cc
  stylua
  sublime4
  sumneko-lua-language-server
  tectonic
  tokei
  tree-sitter
  typescript
  vim
  vim-vint
  vimPlugins.rust-tools-nvim
  wkhtmltopdf-bin
  xcftools
  xorg.libX11
  xorg_sys_opengl
  yarn
  yarn2nix
  tree-sitter
  tree-sitter-grammars.tree-sitter-bash
  tree-sitter-grammars.tree-sitter-bibtex
  tree-sitter-grammars.tree-sitter-c
  tree-sitter-grammars.tree-sitter-c-sharp
  tree-sitter-grammars.tree-sitter-clojure
  tree-sitter-grammars.tree-sitter-cmake
  tree-sitter-grammars.tree-sitter-comment
  tree-sitter-grammars.tree-sitter-commonlisp
  tree-sitter-grammars.tree-sitter-cpp
  tree-sitter-grammars.tree-sitter-css
  tree-sitter-grammars.tree-sitter-cuda
  tree-sitter-grammars.tree-sitter-dart
  tree-sitter-grammars.tree-sitter-devicetree
  tree-sitter-grammars.tree-sitter-dockerfile
  tree-sitter-grammars.tree-sitter-dot
  tree-sitter-grammars.tree-sitter-elisp
  tree-sitter-grammars.tree-sitter-embedded-template
  tree-sitter-grammars.tree-sitter-fennel
  tree-sitter-grammars.tree-sitter-fortran
  tree-sitter-grammars.tree-sitter-glsl
  tree-sitter-grammars.tree-sitter-go
  tree-sitter-grammars.tree-sitter-godot-resource
  tree-sitter-grammars.tree-sitter-gomod
  tree-sitter-grammars.tree-sitter-gowork
  tree-sitter-grammars.tree-sitter-graphql
  tree-sitter-grammars.tree-sitter-html
  tree-sitter-grammars.tree-sitter-http
  tree-sitter-grammars.tree-sitter-java
  tree-sitter-grammars.tree-sitter-javascript
  tree-sitter-grammars.tree-sitter-jsdoc
  tree-sitter-grammars.tree-sitter-json
  tree-sitter-grammars.tree-sitter-json5
  tree-sitter-grammars.tree-sitter-kotlin
  tree-sitter-grammars.tree-sitter-latex
  tree-sitter-grammars.tree-sitter-llvm
  tree-sitter-grammars.tree-sitter-lua
  tree-sitter-grammars.tree-sitter-make
  tree-sitter-grammars.tree-sitter-markdown
  tree-sitter-grammars.tree-sitter-markdown-inline
  tree-sitter-grammars.tree-sitter-nix
  tree-sitter-grammars.tree-sitter-ocaml
  tree-sitter-grammars.tree-sitter-ocaml-interface
  tree-sitter-grammars.tree-sitter-org-nvim
  tree-sitter-grammars.tree-sitter-perl
  tree-sitter-grammars.tree-sitter-php
  tree-sitter-grammars.tree-sitter-python
  tree-sitter-grammars.tree-sitter-regex
  tree-sitter-grammars.tree-sitter-ruby
  tree-sitter-grammars.tree-sitter-rust
  tree-sitter-grammars.tree-sitter-scheme
  tree-sitter-grammars.tree-sitter-scss
  tree-sitter-grammars.tree-sitter-sql
  tree-sitter-grammars.tree-sitter-toml
  tree-sitter-grammars.tree-sitter-tsq
  tree-sitter-grammars.tree-sitter-tsx
  tree-sitter-grammars.tree-sitter-typescript
  tree-sitter-grammars.tree-sitter-vim
  tree-sitter-grammars.tree-sitter-vue
  tree-sitter-grammars.tree-sitter-yaml

]
