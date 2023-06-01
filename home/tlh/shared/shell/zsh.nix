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

    #    initExtra = ''
    ##     any-nix-shell zsh --info-right | source /dev/stdin
    #     zle reset-prompt;
    #   '';

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

      function run() {
        nix run nixpkgs#$@
      }

      function extract() {
        if [ -z "$1" ]; then
           # display usage if no parameters given
           echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso>"
           echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
        else
           for n in "$@"
           do
             if [ -f "$n" ] ; then
                 case "''${n%,}" in
                   *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                                tar xvf "$n"       ;;
                   *.lzma)      unlzma ./"$n"      ;;
                   *.bz2)       bunzip2 ./"$n"     ;;
                   *.cbr|*.rar) unrar x -ad ./"$n" ;;
                   *.gz)        gunzip ./"$n"      ;;
                   *.cbz|*.epub|*.zip) unzip ./"$n"   ;;
                   *.z)         uncompress ./"$n"  ;;
                   *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                                7z x ./"$n"        ;;
                   *.xz)        unxz ./"$n"        ;;
                   *.exe)       cabextract ./"$n"  ;;
                   *.cpio)      cpio -id < ./"$n"  ;;
                   *.cba|*.ace) unace x ./"$n"     ;;
                   *.zpaq)      zpaq x ./"$n"      ;;
                   *.arc)       arc e ./"$n"       ;;
                   *.cso)       ciso 0 ./"$n" ./"$n.iso" && \
                                     extract "$n.iso" && \rm -f "$n" ;;
                   *.zlib)      zlib-flate -uncompress < ./"$n" > ./"$n.tmp" && \
                                     mv ./"$n.tmp" ./"''${n%.*zlib}" && rm -f "$n"   ;;
                   *)
                                echo "extract: '$n' - unknown archive method"
                                return 1
                                ;;
                 esac
             else
                 echo "'$n' - file doesn't exist"
                 return 1
             fi
           done
      fi
      }
    '';

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
