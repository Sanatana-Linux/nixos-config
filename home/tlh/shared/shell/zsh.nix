# This module configures the ZSH shell environment.
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
    autocd = true; # Automatically change directory on typing a directory name.
    enableVteIntegration = true; # Integrate with VTE terminals.
    autosuggestion = {
      enable = true;
      highlight = "fg=8,bg=default"; # Set highlight style for autosuggestions.
    };
    defaultKeymap = "viins"; # Use vi insert mode as the default keymap.
    dotDir = ".config/zsh"; # Location for ZSH configuration files.

    # History configuration
    history = {
      extended = true; # Use extended history format.
      ignoreDups = false; # Do not ignore duplicate history entries.
      expireDuplicatesFirst = true; # Expire duplicate entries first.
      path = "${config.xdg.dataHome}/zsh/history"; # Path to the history file.
      save = 9000000; # Number of history lines to save.
      size = 9900000; # Maximum number of history lines.
      share = true; # Share history between sessions.
    };

    # History substring search
    historySubstringSearch = {
      enable = true;
      searchDownKey = "\e[B"; # Keybinding for searching down in history.
      searchUpKey = "\e[A"; # Keybinding for searching up in history.
    };

    # Completion system initialization
    completionInit = ''
      zmodload -i zsh/zle
      autoload -Uz compinit
      compinit

      _comp_options+=(globdots) # Include hidden files in completion

      zstyle ':completion:*' file-patterns '%p:executable files *(-/):directories'  # Prioritize executables and include directories
      zstyle ':completion:*' group-name "" # Prevent directory grouping in fzf-tab
      zstyle ':completion:*' menu select # select completions with arrow keys
       zstyle ':completion:*:default' menu select=2  # Use menu even if only one match

      zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching
      zstyle ':completion:*' list-colors "${s.:.LS_COLORS}" # Use LS_COLORS for completion coloring
      zstyle ':completion:*' rehash true # Rehash completion cache when needed

      zstyle ':completion:*' accept-exact '*(N)' use-cache on # Cache exact matches

      zstyle ':completion:*' cache-path "${config.xdg.cacheHome}/zsh/completion-cache" # Completion cache location


    '';

    # Create the completion cache directory
    initExtra = ''
            mkdir -p "${config.xdg.cacheHome}/zsh/completion-cache" # Use xdg directory for cache
            if zplug check 'ytet5uy4/fzf-widgets'; then
        # Map widgets to key
        bindkey '^@'  fzf-select-widget
        bindkey '^@.' fzf-edit-dotfiles
        bindkey '^@c' fzf-change-directory
        bindkey '^@n' fzf-change-named-directory
        bindkey '^@f' fzf-edit-files
        bindkey '^@k' fzf-kill-processes
        bindkey '^@s' fzf-exec-ssh
        bindkey '^\'  fzf-change-recent-directory
        bindkey '^r'  fzf-insert-history
        bindkey '^xf' fzf-insert-files
        bindkey '^xd' fzf-insert-directory
        bindkey '^xn' fzf-insert-named-directory

        ## Git
        bindkey '^@g'  fzf-select-git-widget
        bindkey '^@ga' fzf-git-add-files
        bindkey '^@gc' fzf-git-change-repository

        # GitHub
        bindkey '^@h'  fzf-select-github-widget
        bindkey '^@hs' fzf-github-show-issue
        bindkey '^@hc' fzf-github-close-issue

        ## Docker
        bindkey '^@d'  fzf-select-docker-widget
        bindkey '^@dc' fzf-docker-remove-containers
        bindkey '^@di' fzf-docker-remove-images
        bindkey '^@dv' fzf-docker-remove-volumes

        # Enable Exact-match by fzf-insert-history
        FZF_WIDGET_OPTS[insert-history]='--exact'

        # Start fzf in a tmux pane
        FZF_WIDGET_TMUX=1
      fi
    '';

    # ZSH options
    profileExtra = ''
      setopt  APPEND_HISTORY AUTO_LIST AUTO_PARAM_SLASH AUTO_PUSHD COMPLETE_ALIASES CORRECT_ALL \
              EXTENDED_GLOB EXTENDED_HISTORY GLOB_COMPLETE GLOB_STAR_SHORT HIST_FCNTL_LOCK HIST_REDUCE_BLANKS \
              INTERACTIVE_COMMENTS NOCASEGLOB NO_CLOBBER NUMERIC_GLOB_SORT PUSHD_SILENT \
              PUSHD_TO_HOME RCEXPANDPARAM SHARE_HISTORY TRANSIENT_RPROMPT

      unsetopt BEEP FLOW_CONTROL HIST_BEEP


    '';

    # Local ZSH variables
    localVariables = with pkgs; {
      ZSH_AUTOSUGGEST_USE_ASYNC = "true"; # Use asynchronous autosuggestions.
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = 40; # Maximum buffer size for autosuggestions.
      KEYTIMEOUT = 1;
      VISUAL = "${pkgs.neovim}/bin/nvim";
      EDITOR = "${pkgs.neovim}/bin/nvim";
    };

    # Shell aliases, grouped by category

    shellAliases = with pkgs; {
      # Navigation
      "cd.." = "cd ../";
      "cd..." = "cd ../../";
      fcd = "cd $(find -type d | fzf)"; # Fuzzy find a directory and change to it
      mkcd = "mkdir $1 && cd $1 "; # Create a directory and change to it.

      # File Management and Viewing
      l = "${lib.getBin eza}/bin/eza -lF --git --color=auto --group-directories-first --time-style=long-iso --icons -s extension "; # Enhanced ls.
      la = "${lib.getBin eza}/bin/eza -lah --tree --git --color=auto --group-directories-first --time-style=long-iso --icons -s extension "; # Enhanced ls with all and human readable sizes.
      ll = "${lib.getBin eza}/bin/eza -alh "; # Another alias for enhanced ls.
      ls = "${lib.getBin eza}/bin/eza -h --git --icons --color=auto --group-directories-first -s extension"; # Enhanced ls with human readable sizes.
      lx = "${lib.getBin eza}/bin/eza -alh -s extension --color=auto --group-directories-first --icons --git"; # Another enhanced ls alias.

      tree = "${lib.getBin eza}/bin/eza --tree --icons --tree";
      cat = "${lib.getBin bat}/bin/bat --style=plain"; # Use bat for syntax highlighting, plain style for regular "cat" behaviour.
      du = "${lib.getBin du-dust}/bin/du-dust"; # Disk usage analyzer.
      gz = "gzip -l"; # list contents of gzipped files
      rm = "rm -rvf"; # remove files and directories recursively and forcefully
      trm = "${lib.getBin trash-cli}/bin/trash-cli"; # Move files to trash

      # Archiving
      "dtrx-zip-all" = "for i in ./**/*.zip; do dtrx $i; done"; # Extract all zip files recursively. Make sure `dtrx` is available

      # System
      cleanup = "sudo nix-collect-garbage --delete-older-than 3d"; # Clean up old Nix store entries.
      purge = "doas sync; echo 3 | doas tee /proc/sys/vm/drop_caches"; # Purge disk caches (requires doas).
      ps = "${lib.getBin procs}/bin/procs"; # Improved process viewer.

      # Searching and File Opening
      grep = "${lib.getBin ripgrep-all}/bin/rga"; # Use ripgrep for fast searching
      fzim = "fzf | xargs nvim"; # Fuzzy find a file and open it with Neovim.
      vim = "nvim";

      # Miscellaneous
      c = "clear";
      m = "mkdir -p"; # create directory if not exists
      ytmp3 = ''
        ${lib.getBin yt-dlp}/bin/yt-dlp -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title="%(artist)s - %(title)s" --prefer-ffmpeg -o "%(title)s.%(ext)s"
      ''; # Download YouTube videos as MP3.
    };

    zplug = {
      enable = true;
      zplugHome = "${config.xdg.configHome}/zsh/zplug";
      plugins = [
        {name = "hlissner/zsh-autopair";}
        {name = "chisui/zsh-nix-shell";}
        {name = "molovo/tipz";}
        {name = "nix-community/nix-zsh-completions";}
        {name = "ytet5uy4/fzf-widgets";}
      ];
    };
  };
}
