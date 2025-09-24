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
    moar
    curl
    direnv
    du-dust
    duf
    editorconfig-core-c
    eza
    fd
    fnm
    fzf-obc
    fzf
    findutils
    file
    imv
    jq
    killall
    lm_sensors
    lz4
    mpc_cli
    mpg123
    neofetch
    pciutils
    perl
    procs
    psmisc
    p7zip
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
    (let
      base = pkgs.appimageTools.defaultFhsEnvArgs;
    in
      pkgs.buildFHSEnv (base
        // {
          name = "fhs";
          targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
          profile = "export FHS=1";
          runScript = "zsh";
          extraOutputsToInstall = ["dev"];
        }))
  ];

  programs = {
    eza = {
      enable = true;
      colors = "always";
      icons = "always";
      git = true;
      enableZshIntegration = true;
    };
    gpg.enable = true;
    man.enable = true;

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    skim = {
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
      options = [
        "--cmd cd"
      ];
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
