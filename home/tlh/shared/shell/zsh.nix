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

        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"       # Colored completion (different colors for dirs/files/etc)
        zstyle ':completion:*' rehash true      # automatically find new executables in path
        # Speed up completions
        zstyle ':completion:*' accept-exact '*(N)'
        zstyle ':completion:*' use-cache on
        mkdir -p "$(dirname ${config.xdg.cacheHome}/zsh/completion-cache)"
        zstyle ':completion:*' cache-path "${config.xdg.cacheHome}/zsh/completion-cache"
        zstyle ':completion:*' menu select
        WORDCHARS=''${WORDCHARS//\/[&.;]}         # Don't consider certain characters part of the word/


    '';

    initExtraFirst = ''
      source ${config.xdg.configHome}/zsh/zplug/**/*.zsh

      FZF_TAB_COMMAND=(${lib.getExe pkgs.fzf}
      --ansi
      --expect='$continuous_trigger'
      --nth=2,3 --delimiter='\x00'
      --layout=reverse --height="''${FZF_TMUX_HEIGHT:=50%}"
      --tiebreak=begin -m --bind=tab:down,btab:up,change:top,ctrl-space:toggle --cycle
      '--query=$query'
      '--header-lines=$#headers')
      zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND
      zstyle ':fzf-tab:*' switch-group ',' '.'
      zstyle ':fzf-tab:complete:_zlua:*' query-string input
      zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview.sh $realpath'
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
        {name = "zdharma-continuum/fast-syntax-highlighting";}
        {name = "zsh-users/zsh-completions";}
        {name = "zsh-users/zsh-history-substring-search";}
        {name = "hlissner/zsh-autopair";}
        {name = "zsh-users/zsh-autosuggestions";}
        {name = "chisui/zsh-nix-shell";}
        {name = "marlonrichert/zsh-hist";}
        {name = "marlonrichert/zsh-edit";}
        {name = "marlonrichert/zsh-autocomplete";}
      ];
    };
  };
}
