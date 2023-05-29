{
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.attrValues {
    inherit
      (pkgs)
      black
      cargo
      ccls
      clang
      clang-tools
      cmake
      delve
      go
      gopls
      grex
      keychain
      java-language-server
      lldb
      nodejs
      rust-analyzer
      rustfmt
      selene
      shfmt
      shellcheck
      sqlite
      texlab
      sumneko-lua-language-server
      stylua
      uncrustify
      ;
      inherit 
      (pkgs.gnome)
        gnome-keyring
        libgnome-keyring
      ;

    inherit
      (pkgs.luaPackages)
      lua
      ;

    inherit
      (pkgs.nodePackages_latest)
      jsonlint
      prettier
      typescript-language-server
      vls
      vscode-langservers-extracted
      yaml-language-server
      yarn
      ;

    pylsp = pkgs.python310.withPackages (p:
      with p; [
        python-lsp-server
        flake8
      ]);
  };
}
