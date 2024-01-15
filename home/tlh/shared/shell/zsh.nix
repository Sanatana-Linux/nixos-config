{ config
, lib
, pkgs
, ...
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
      source $HOME/.config/zsh/zplug/**/*.zsh

    '';

    initExtraFirst = ''
      source $HOME/.config/zsh/zplug/**/*.zsh
      export QT_QPA_PLATFORMTHEME="qt5ct"
    '';

    shellAliases = with pkgs; {
      cleanup = "sudo nix-collect-garbage --delete-older-than 3d";
      purge = "doas sync; echo 3 | doas tee /proc/sys/vm/drop_caches"; # cleans up drop caches 
      "dtrx-zip-all" = "for i in ./**/*.zip; do dtrx $i; done"; # unzips all zip archives in a directory
      "cd.." = "cd ../"; # shortens the go back command
      "cd..." = "cd ../../"; # shortens go back twice command
      c = "clear"; # clear in two keystrokes
      g = "git"; # git in one keystroke
      commit = "git add . && git commit -m"; # commit - git
      push = "git push"; # push minus git
      pull = "git pull"; # pull minus git
      m = "mkdir -p"; # mkdir with path in one keystroke
      rm = "rm -rvf"; # dangerous! remove with force, verbose and recursive as just remove
      vim = "nvim"; # just use neovim for vim, since I only configure neovim 
      fcd = "cd $(find -type d | fzf)"; # find a directory then cd into it
      grep = "${lib.getBin ripgrep-all}/bin/rga"; # fixes an annoyance with nix I had 
      du = "${lib.getBin du-dust}/bin/du-dust"; # same as above
      ps = "${lib.getBin procs}/bin/procs"; # procs but shorter 
      trm = "${lib.getBin trash-cli}/bin/trash-cli"; # rm like trash command
      cat = "${lib.getBin bat}/bin/bat --style=plain"; # replace cat with bat
      l = "${lib.getBin eza}/bin/eza -lF --git --color=auto --group-directories-first --time-style=long-iso --icons -s extension "; # replace ls with eza
      la = "${lib.getBin eza}/bin/eza -lah --tree --git --color=auto --group-directories-first --time-style=long-iso --icons -s extension "; # ls with tree
      lx = "${lib.getBin eza}/bin/eza -alh -s extension --color=auto --group-directories-first --icons --git";
      ls = "${lib.getBin eza}/bin/eza -h --git --icons --color=auto --group-directories-first -s extension"; # ls with preferred flags
      ll = "${lib.getBin eza}/bin/eza -alh "; # ls it all
      tree = "${lib.getBin eza}/bin/eza --tree --icons --tree"; # because tree is not an option, I just made it myself.
      take = "mkdir $1 && cd $1 "; # make directory and cd into it
      ytmp3 = ''
        ${lib.getBin yt-dlp}/bin/yt-dlp -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title="%(artist)s - %(title)s" --prefer-ffmpeg -o "%(title)s.%(ext)s"
      ''; # download the video, extract the audio from it, save as mp3
    };

    zplug = {
      enable = true;
      zplugHome = "${config.xdg.configHome}/zsh/zplug";
      plugins = [
        { name = "hlissner/zsh-autopair"; }
        { name = "chisui/zsh-nix-shell"; }
        { name = "lincheney/fzf-tab-completion"; }
        { name = "Aloxaf/fzf-tab"; }
        { name = "molovo/tipz"; }
        { name = "zimfw/archive"; }
        { name = "nix-community/nix-zsh-completions"; }
      ];
    };
  };
}
