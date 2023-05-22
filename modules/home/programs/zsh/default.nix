{
  config,
  lib,
  pkgs,
  colors,
  ...
}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      save = 10000;
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    sessionVariables = {};

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
      export QT_QPA_PLATFORMTHEME=qt5ct

      path=(
        $path
        ~/.local/bin
        ~/.npm-packages/bin
        ~/.npm-packages/lib
        ~/.local/share/gem/ruby/3.1.0/gems
       )

      export SUDO_PROMPT=$'Password for ->\033[32;05;16m %u\033[0m  '

      export FZF_DEFAULT_OPTS="
        --color fg:${colors.fg}
        --color fg+:${colors.light-white}
        --color bg:${colors.bg-darker}
        --color bg+:${colors.bg}
        --color hl:${colors.grey}
        --color hl+:${colors.dark-grey}
        --color info:${colors.green}
        --color marker:${colors.yellow}
        --color prompt:${colors.cyan}
        --color spinner:${colors.magenta}
        --color pointer:${colors.fg}
        --color header:${colors.white}
        --color preview-fg:${colors.light-white}
        --color preview-bg:${colors.dimblack}
        --color gutter:${colors.bg-darker}
        --color border:${colors.dimblack}
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
      NO_BEEP
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

    shellAliases = with pkgs; {
      cleanup = "doas nix-collect-garbage --delete-older-than 7d";
      bloat = "nix path-info -Sh /run/current-system";
      # DO NOT DO THIS
      # IT WILL FORCE RM FOLDERS
      rm = "rm -rvf";
      vim = "nvim";
      purge = "doas sync; echo 3 | doas tee /proc/sys/vm/drop_caches";
      # -------------------------------------------------------------------------- */
      g = "git";
      commit = "git add . && git commit -m";
      push = "git push";
      pull = "git pull";
      m = "mkdir -p";
      all = "${lib.getExe exa} -lha  --icons --tree ";
      fcd = "cd $(find -type d | fzf)";
      grep = lib.getExe ripgrep;
      du = lib.getExe du-dust;
      ps = lib.getExe procs;
      rmt = lib.getExe trash-cli;
      cat = "${lib.getExe bat} --style=plain";
      l = "${lib.getExe exa} -lF --time-style=long-iso --icons";
      tree = "${lib.getExe exa} --tree --icons --tree";
      nps = "nps -C=description --separator=true";
      ytmp3 = ''
        ${
          lib.getExe yt-dlp
        } -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title="%(artist)s - %(title)s" --prefer-ffmpeg -o "%(title)s.%(ext)s"
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
