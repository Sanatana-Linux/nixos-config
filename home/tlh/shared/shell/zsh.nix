{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";
    defaultKeymap = "viins";
    history = {
      extended = true;
      ignoreDups = true;
      expireDuplicatesFirst = true;
      path = "${config.xdg.dataHome}/zsh/history";
      save = 9000000; # number of lines to save
      size = 9000000; # number of lines to keep
      share = true; # share between sessions
    };

    historySubstringSearch = {
      enable = true;
      searchDownKey = "^[[B"; # DOWN Arrow key
      searchUpKey = "^[[A"; # UP Arrow key
    };

    sessionVariables = {
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    };
  

    initExtra = ''
      any-nix-shell zsh --info-right | source /dev/stdin
       '';

    shellAliases = with pkgs; {
      cleanup = "sudo nix-collect-garbage --delete-older-than 7d";

      bloat = "nix path-info -Sh /run/current-system";

      purge = "doas sync; echo 3 | doas tee /proc/sys/vm/drop_caches";

      g = "git";
      commit = "git add . && git commit -m";
      push = "git push";

      pull = "git pull";

      m = "mkdir -p";

      rm = "rm -rvf";

      vim = "nvim";

      fcd = "cd $(find -type d | fzf)";

      grep = lib.getExe ripgrep;
      du = lib.getExe du-dust;
      ps = lib.getExe procs;
      trm = lib.getExe trash-cli;

      cat = "${lib.getExe bat} --style=plain";

      l = "${lib.getExe exa} -lF --time-style=long-iso --icons";

      la = "${lib.getExe exa} -lah --tree";

      ls = "${lib.getExe exa} -h --git --icons --color=auto --group-directories-first -s extension";

      tree = "${lib.getExe exa} --tree --icons --tree";

      ytmp3 = ''
        ${lib.getExe yt-dlp} -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title="%(artist)s - %(title)s" --prefer-ffmpeg -o "%(title)s.%(ext)s"
      '';
    };

    zplug = {
      enable = true;
      zplugHome = "${config.xdg.configHome}/zsh/zplug";
      plugins = [
        {name = "Aloxaf/fzf-tab";}
        {name = "zsh-users/zsh-completions";}
        {name = "hlissner/zsh-autopair";}
        {name = "chisui/zsh-nix-shell";}
        {name = "marlonrichert/zsh-hist";}
        {name = "marlonrichert/zsh-edit";}
      ];
    };
  };
}
