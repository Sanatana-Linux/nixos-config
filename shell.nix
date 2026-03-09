{pkgs, ...}: {
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      nix
      git
      home-manager
      figlet
      lolcat
      nixVersions.latest
      alejandra
      neovim
      silver-searcher
      nodejs
      pnpm
    ];

    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";
    
    shellHook = ''
      SAY=$(echo -e "Sanatana \n Linux")
      if command -v pnpx >/dev/null; then
         pnpx cfonts "$SAY" --colors "#4FB0BE","#F25F89" --align center --font slick
      fi
    '';
  };
}
