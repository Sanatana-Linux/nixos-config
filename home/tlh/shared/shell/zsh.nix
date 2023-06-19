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
    completionInit = ''
      zmodload zsh/zle
      zmodload zsh/zpty
      zmodload zsh/complist
      autoload -U compinit
      zstyle ':completion:*' menu select
      zmodload zsh/complist
      compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
      _comp_options+=(globdots)
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"       # Colored completion (different colors for dirs/files/etc)
      zstyle ':completion:*' rehash true      # automatically find new executables in path
      # Speed up completions
      zstyle ':completion:*' accept-exact '*(N)'
      zstyle ':completion:*' use-cache on
      mkdir -p "$(dirname ${config.xdg.cacheHome}/zsh/completion-cache)"
      zstyle ':completion:*' cache-path "${config.xdg.cacheHome}/zsh/completion-cache"
      zstyle ':completion:*' menu select
      WORDCHARS=''${WORDCHARS//\/[&.;]}

    '';

    profileExtra = ''
      while read -r option
      do
      setopt $option
      done <<-EOF
        ALWAYS_TO_END
        APPEND_HISTORY
        APPENDHISTORY
        AUTO_CD
        AUTO_LIST
        AUTO_MENU
        AUTO_PARAM_SLASH
        AUTO_PUSHD
        COMPLETE_IN_WORD
        CORRECT
        EXTENDED_HISTORY
        EXTENDEDGLOB
        HIST_EXPIRE_DUPS_FIRST
        HIST_FCNTL_LOCK
        HIST_IGNORE_ALL_DUPS
        HIST_IGNORE_DUPS
        HIST_IGNORE_SPACE
        HIST_REDUCE_BLANKS
        HIST_SAVE_NO_DUPS
        HIST_VERIFY
        HISTFINDNODUPS
        HISTREDUCEBLANKS
        HISTVERIFY
        INC_APPEND_HISTORY
        INCAPPENDHISTORY
        INTERACTIVE_COMMENTS
        INTERACTIVECOMMENTS
        MENU_COMPLETE
        NO_NOMATCH
        NOCASEGLOB
        NUMERICGLOBSORT
        PUSHD_IGNORE_DUPS
        PUSHD_SILENT
        PUSHD_TO_HOME
        RCEXPANDPARAM
        SHARE_HISTORY
      EOF

      while read -r option
      do
       unsetopt $option
      done <<-EOF
        BEEP
        CORRECT_ALL
        HIST_BEEP
        MENU_COMPLETE
      EOF


    '';

    initExtraFirst = ''
      any-nix-shell zsh --info-right | source /dev/stdin
      source ${config.xdg.configHome}/zsh/zplug/**/*.zsh
    '';

    shellAliases = with pkgs; {
      cleanup = "sudo nix-collect-garbage --delete-older-than 3d";
      bloat = "nix path-info -Sh /run/current-system";
      purge = "doas sync; echo 3 | doas tee /proc/sys/vm/drop_caches";
      "cd.." = "cd ../";
      "cd..." = "cd ../../";
      c="clear";
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
        {name = "hlissner/zsh-autopair";}
        {name = "chisui/zsh-nix-shell";}
        {name = "chisui/zsh-nix-shell";}
        {name = "lincheney/fzf-tab-completion";}
      ];
    };
  };
}
