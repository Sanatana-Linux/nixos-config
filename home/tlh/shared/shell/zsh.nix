{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autocd = true;
    enableVteIntegration = true;
    autosuggestion.enable = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    history = {
      extended = true;
      ignoreDups = false; # sometimes the subtle variants are useful to have in the history
      expireDuplicatesFirst = true;
      path = "${config.xdg.dataHome}/zsh/history";
      save = 9000000; # number of lines to save
      size = 9900000; # number of lines to keep
      share = true; # share between sessions
    };

    historySubstringSearch = {
      enable = true;
      searchDownKey = "^[[B"; # DOWN Arrow key
      searchUpKey = "^[[A"; # UP Arrow key
    };
    completionInit = ''
      zmodload zsh/zle
      zmodload zsh/zpty
      zmodload zsh/complist
      autoload -Uz compinit
      zstyle ':completion:*' menu select
      zmodload zsh/complist
      compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
      _comp_options+=(globdots)
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"       # Colored completion (different colors for dirs/files/etc)
      zstyle ':completion:*' rehash true                              # automatically find new executables in path
      # Speed up completions
      zstyle ':completion:*' accept-exact '*(N)'
      zstyle ':completion:*' use-cache on
      mkdir -p "$(dirname ${config.xdg.cacheHome}/zsh/completion-cache)"
      zstyle ':completion:*' cache-path "${config.xdg.cacheHome}/zsh/completion-cache"
      zstyle ':completion:*' menu select
      zstyle ':completion::complete:*' gain-privileges 1
      WORDCHARS=''${WORDCHARS//\/[&.;]}
    '';

    profileExtra = ''
      setopt  APPEND_HISTORY
      setopt  AUTO_LIST
      setopt  AUTO_MENU
      setopt  AUTO_PARAM_SLASH
      setopt  AUTO_PUSHD
      setopt  COMPLETE_ALIASES
      setopt  CORRECT_ALL
      setopt  EXTENDED_GLOB
      setopt  EXTENDED_HISTORY
      setopt  GLOB_COMPLETE
      setopt  GLOB_STAR_SHORT
      setopt  HIST_FCNTL_LOCK
      setopt  HIST_REDUCE_BLANKS
      setopt  INC_APPEND_HISTORY
      setopt  INTERACTIVE_COMMENTS
      setopt  NOCASEGLOB
      setopt  NO_CLOBBER
      setopt  NUMERIC_GLOB_SORT
      setopt  PUSHD_SILENT
      setopt  PUSHD_TO_HOME
      setopt  RCEXPANDPARAM
      setopt  SHARE_HISTORY
      setopt  TRANSIENT_RPROMPT
      unsetopt  BEEP
      unsetopt  FLOW_CONTROL
      unsetopt  HIST_BEEP
      source $HOME/.config/zsh/**/*.zsh

    '';

    shellAliases = with pkgs; {
      "cd.." = "cd ../"; # shortens the go back command
      "cd..." = "cd ../../"; # shortens go back twice command
      "dtrx-zip-all" = "for i in ./**/*.zip; do dtrx $i; done"; # unzips all zip archives in a directory
      c = "clear"; # clear in two keystrokes
      cat = "${lib.getBin bat}/bin/bat --style=plain"; # replace cat with bat
      cleanup = "sudo nix-collect-garbage --delete-older-than 3d";
      commit = "git add . && git commit -m"; # commit - git
      du = "${lib.getBin du-dust}/bin/du-dust"; # same as above
      fcd = "cd $(find -type d | fzf)"; # find a directory then cd into it
      fzim = "fzf | xargs nvim"; # fzf then open in neovim
      g = "git"; # git in one keystroke
      grep = "${lib.getBin ripgrep-all}/bin/rga"; # fixes an annoyance with nix I had
      gz = "gzip -l";
      l = "${lib.getBin eza}/bin/eza -lF --git --color=auto --group-directories-first --time-style=long-iso --icons -s extension "; # replace ls with eza
      la = "${lib.getBin eza}/bin/eza -lah --tree --git --color=auto --group-directories-first --time-style=long-iso --icons -s extension "; # ls with tree
      ll = "${lib.getBin eza}/bin/eza -alh "; # ls it all
      ls = "${lib.getBin eza}/bin/eza -h --git --icons --color=auto --group-directories-first -s extension"; # ls with preferred flags
      lx = "${lib.getBin eza}/bin/eza -alh -s extension --color=auto --group-directories-first --icons --git";
      m = "mkdir -p"; # mkdir with path in one keystroke
      ps = "${lib.getBin procs}/bin/procs"; # procs but shorter
      pull = "git pull"; # pull minus git
      purge = "doas sync; echo 3 | doas tee /proc/sys/vm/drop_caches"; # cleans up drop caches
      push = "git push"; # push minus git
      rm = "rm -rvf"; # dangerous! remove with force, verbose and recursive as just remove
      take = "mkdir $1 && cd $1 "; # make directory and cd into it
      tree = "${lib.getBin eza}/bin/eza --tree --icons --tree"; # because tree is not an option, I just made it myself.
      trm = "${lib.getBin trash-cli}/bin/trash-cli"; # rm like trash command
      vim = "nvim"; # just use neovim for vim, since I only configure neovim
      ytmp3 = ''
        ${lib.getBin yt-dlp}/bin/yt-dlp -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title="%(artist)s - %(title)s" --prefer-ffmpeg -o "%(title)s.%(ext)s"
      ''; # download the video, extract the audio from it, save as mp3
    };

    zplug = {
      enable = true;
      zplugHome = "${config.xdg.configHome}/zsh/zplug";
      plugins = [
        {name = "hlissner/zsh-autopair";}
        {name = "z-shell/F-Sy-H";}
        {name = "chisui/zsh-nix-shell";}
        {name = "Aloxaf/fzf-tab";}
        {name = "b0o/zfzf";}
        {name = "joshskidmore/zsh-fzf-history-search";}
        {name = "lincheney/fzf-tab-completion";}
        {name = "marlonrichert/zsh-autocomplete";}
        {name = "molovo/tipz";}
        {name = "nix-community/nix-zsh-completions";}
        {name = "redxtech/zsh-fzf-utils";}
        {name = "tom-power/fzf-tab-widgets";}
        {name = "ytet5uy4/fzf-widgets";}
        {name = "zimfw/archive";}
      ];
    };
  };
}
