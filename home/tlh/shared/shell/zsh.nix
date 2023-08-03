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
    enableAutosuggestions = true;
    dotDir = ".config/zsh";
    defaultKeymap = "viins";
    history = {
      extended = true;
      ignoreDups = false; # sometimes the subtle variants are useful to have in the history
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
        AUTO_LIST
        AUTO_MENU
        AUTO_PARAM_SLASH
        AUTO_PUSHD
        COMPLETE_IN_WORD
        CORRECT
        EXTENDEDGLOB
        INC_APPEND_HISTORY
        INTERACTIVE_COMMENTS
        MENU_COMPLETE
        NO_NOMATCH
        NOCASEGLOB
        NUMERICGLOBSORT
        PUSHD_SILENT
        PUSHD_TO_HOME
        RCEXPANDPARAM
      EOF

      while read -r option
      do
       unsetopt $option
      done <<-EOF
        BEEP
        HIST_BEEP
        MENU_COMPLETE
      EOF


    '';

    initExtraFirst = ''
      source ${config.xdg.configHome}/zsh/zplug/**/*.zsh
      any-nix-shell zsh --info-right | source /dev/stdin
    '';

    shellAliases = with pkgs; {
      cleanup = "sudo nix-collect-garbage --delete-older-than 3d";
      bloat = "nix path-info -Sh /run/current-system";
      purge = "doas sync; echo 3 | doas tee /proc/sys/vm/drop_caches";
      "cd.." = "cd ../";
      "cd..." = "cd ../../";
      c = "clear";
      g = "git";
      commit = "git add . && git commit -m";
      push = "git push";
      pull = "git pull";
      m = "mkdir -p";
      rm = "rm -rvf";
      vim = "nvim";
      fcd = "cd $(find -type d | fzf)";
      grep = "${lib.getBin ripgrep}/bin/ripgrep";
      du = "${lib.getBin du-dust}/bin/du-dust";
      ps = "${lib.getBin procs}/bin/procs";
      trm = "${lib.getBin trash-cli}/bin/trash-cli";
      cat = "${lib.getBin bat}/bin/bat --style=plain";
      l = "${lib.getBin exa}/bin/exa -lF --time-style=long-iso --icons";
      la = "${lib.getBin exa}/bin/exa -lah --tree";
      lx = "${lib.getBin exa}/bin/exa -alh --color=auto --group-directories-first --icons --git";
      ls = "${lib.getBin exa}/bin/exa -h --git --icons --color=auto --group-directories-first -s extension";
      tree = "${lib.getBin exa}/bin/exa --tree --icons --tree";
      ytmp3 = ''
        ${lib.getBin yt-dlp}/bin/yt-dlp -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title="%(artist)s - %(title)s" --prefer-ffmpeg -o "%(title)s.%(ext)s"
      '';
    };

    zplug = {
      enable = true;
      zplugHome = "${config.xdg.configHome}/zsh/zplug";
      plugins = [
        {name = "hlissner/zsh-autopair";}
        {name = "chisui/zsh-nix-shell";}
        {name = "lincheney/fzf-tab-completion";}
        {name = "Aloxaf/fzf-tab";}
        {name = "molovo/tipz";}
        {name = "zimfw/archive";}
        {name = "nix-community/nix-zsh-completions";}
      ];
    };
  };
}
