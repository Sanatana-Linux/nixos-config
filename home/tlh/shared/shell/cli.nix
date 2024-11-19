{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    bc
    btop
    catimg
    bat
    curl
    direnv
    nix-direnv
    du-dust
    duf
    editorconfig-core-c
    fd
    fzf-obc
    fzf
    findutils
    file
    imv
    jq
    killall
    lm_sensors
    lz4
    man-pages
    man-pages-posix
    mpc_cli
    mpg123
    neofetch
    pciutils
    perl
    procs
    psmisc
    p7zip
    ranger
    ripgrep
    rsync
    sd
    trash-cli
    tree
    unrar
    unzip
    util-linux
    wget
    xarchiver
    zip
    yt-dlp
    zsh
    zplug
    zsh-autosuggestions
zsh-fzf-tab 

  ];

  programs = {
    eza.enable = true;
    gpg.enable = true;
    man.enable = true;
    ssh.enable = true;

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    pyenv = {
      enable = true;
      enableZshIntegration = true;
    };
    rbenv = {
      enable = true;
      enableZshIntegration = true;
    };
    carapace = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };
    keychain = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
