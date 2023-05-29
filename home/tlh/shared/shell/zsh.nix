{
  config,
  lib,
  pkgs,
  ...
}: {
  # Clean this up a bit, its unruly and unncessary
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";
    defaultKeymap = "viins";
    history = {
      extended = true;
      ignoreDups = false;
      expireDuplicatesFirst = false;
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
      autoload -Uz compinit
      zstyle ':completion:*' menu select
      zstyle ':completion:*' menu yes select
      zstyle ':completion:*' sort false
      zstyle ':completion:*' completer _complete _match _approximate
      zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
      zstyle ':completion:*' special-dirs true
      zstyle ':completion:*' rehash true
      zstyle ':completion:*' list-grouped false
      zstyle ':completion:*' list-separator '''
      zstyle ':completion:*' group-name '''
      zstyle ':completion:*' verbose yes
      zstyle ':completion:*' file-sort modification
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*:matches' group 'yes'
      zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
      zstyle ':completion:*:messages' format '%d'
      zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*:match:*' original only
      zstyle ':completion:*:approximate:*' max-errors 1 numeric
      zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
      zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
      zstyle ':completion:*:jobs' numbers true
      zstyle ':completion:*:jobs' verbose true
      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':completion:*:exa' sort false
      zstyle ':completion:complete:*:options' sort false
      zstyle ':completion:files' sort false
      zmodload zsh/zle
      zmodload zsh/zpty
      zmodload zsh/complist
      compinit -i
      _comp_options+=(globdots)

      autoload -Uz colors && colors

      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -v '^?' backward-delete-char
    '';

    envExtra = ''
      export LANG="en_US.UTF-8"
      export LC_COLLATE="en_US.UTF-8"
      export LC_CTYPE="en_US.UTF-8"
      export LC_MESSAGES="en_US.UTF-8"
      export LC_MONETARY="en_US.UTF-8"
      export LC_NUMERIC="en_US.UTF-8"
      export LC_TIME="en_US.UTF-8"
      export LC_ALL="en_US.UTF-8"
      export SUDO_PROMPT=$'Password for ->\033[32;05;16m %u\033[0m  '
   function extract()
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xjf $1   ;;
           *.tar.gz)    tar xzf $1   ;;
           *.bz2)       bunzip2 $1   ;;
           *.rar)       unrar x $1   ;;
           *.gz)        gunzip $1    ;;
           *.tar)       tar xf $1    ;;
           *.tbz2)      tar xjf $1   ;;
           *.tgz)       tar xzf $1   ;;
           *.zip)       unzip $1     ;;
           *.Z)         uncompress $1;;
           *.7z)        7z x $1      ;;
           *)           echo "'$1' cannot be extracted via extract" ;;
       esac
   else
       echo "'$1' is not a valid file"
   fi
   end 
   
      export FZF_DEFAULT_OPTS="
        --color fg:#d1d1d1
        --color fg+:#f4f4f4
        --color bg:#1c1c1c
        --color bg+:#2c2c2c
        --color hl:#555555
        --color hl+:#4f4f4f
        --color info:#00eaff
        --color marker:#f0ffaa
        --color prompt:#8265ff
        --color spinner:#f83d80
        --color pointer:#d1d1d1
        --color header:#f4f4f4
        --color preview-fg:#717171
        --color preview-bg:#282828
        --color gutter:#1c1c1c
        --color border:#222222
        --border
       --prompt '🕉 '
        --pointer ''
        --marker ''
      "
    '';

    initExtra = ''
      FZF_TAB_COMMAND=(
        ${lib.getExe pkgs.fzf}
        --ansi
        --expect='$continuous_trigger'
        --nth=2,3 --delimiter='\x00'
        --layout=reverse --height="''${FZF_TMUX_HEIGHT:=50%}"
        --tiebreak=begin -m --bind=tab:down,btab:up,change:top,ctrl-space:toggle --cycle
        '--query=$query'
        '--header-lines=$#headers'
      )

      zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND
      zstyle ':fzf-tab:*' switch-group ',' '.'
      zstyle ':fzf-tab:complete:_zlua:*' query-string input
      zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview.sh $realpath'

      ZSH_AUTOSUGGEST_USE_ASYNC="true"
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor regexp root line)
      ZSH_HIGHLIGHT_MAXLENGTH=512

      while read -r option
      do
        setopt $option
      done <<-EOF
      AUTO_CD
      AUTO_LIST
      AUTO_MENU
      AUTO_PARAM_SLASH
      AUTO_PUSHD
      APPEND_HISTORY
      ALWAYS_TO_END
      COMPLETE_IN_WORD
      CORRECT
      EXTENDED_HISTORY
      HIST_EXPIRE_DUPS_FIRST
      HIST_FCNTL_LOCK
      HIST_IGNORE_ALL_DUPS
      HIST_IGNORE_DUPS
      HIST_IGNORE_SPACE
      HIST_REDUCE_BLANKS
      HIST_SAVE_NO_DUPS
      HIST_VERIFY
      INC_APPEND_HISTORY
      INTERACTIVE_COMMENTS
      MENU_COMPLETE
      NO_NOMATCH
      PUSHD_IGNORE_DUPS
      PUSHD_TO_HOME
      PUSHD_SILENT
      SHARE_HISTORY
      EOF

      while read -r option
      do
        unsetopt $option
      done <<-EOF
      CORRECT_ALL
      HIST_BEEP
      MENU_COMPLETE
      EOF

      any-nix-shell zsh --info-right | source /dev/stdin
  autoload -U promptinit; promptinit
   prompt pure;
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
        {name = "zsh-users/zsh-history-substring-search";}
        {name = "zsh-users/zsh-completions";}
        {name = "zsh-users/zsh-autosuggestions";}
        {name = "hlissner/zsh-autopair";}
        {name = "chisui/zsh-nix-shell";}
        {name = "marlonrichert/zsh-hist";}
        {name = "marlonrichert/zsh-edit";}
      ];
    };
  };
}
