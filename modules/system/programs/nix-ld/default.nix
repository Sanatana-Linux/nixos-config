{ config, pkgs, ... }: {
  # Enable nix ld
  programs.nix-ld.enable = true;

  # Sets up all the libraries to load
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    zlib
    nss
    openssl
    curl
    expat
    nodejs
    lua
    luajitPackages.luadbi-sqlite3
luajitPackages.luarocks-nix
luajitPackages.luasql-sqlite3
luajitPackages.sqlite
lua51Packages.luarocks-nix
lua52Packages.luarocks-nix
lua53Packages.luarocks-nix
lua54Packages.luarocks-nix
nodePackages_latest.diagnostic-languageserver
nodePackages_latest.eslint
nodePackages_latest.gulp
nodePackages_latest.neovim
nodePackages.prettier
python311
python311Packages.ipykernel
python311Packages.ipython
python311Packages.jupyter
python311Packages.notebook
python311Packages.numpy
python311Packages.pip
python311Packages.pynvim
python311Packages.python
python311Packages.python-dotenv
python311Packages.setuptoolsBuildHook
python311Packages.wheelUnpackHook
python311Packages.youtube-transcript-api
python311Packages.huggingface-hub
rustc
rustfmt
sass
sassc
puppeteer-cli

ruby

shellcheck
shfmt
sqlite
sqlite-utils
stylua
    # ...
  ];
}