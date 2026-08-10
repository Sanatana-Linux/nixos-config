{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = {
    enable = mkEnableOption "ZSH shell with custom configuration and plugins";

    enableAliases = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable custom shell aliases";
    };

    enablePlugins = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable ZSH plugins via zplug";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      autocomplete-sh
    ];

    # Pre-seed autocomplete-sh config to use the local Ollama model.
    home.file.".autocomplete/config".text = ''
      # ~/.autocomplete/config
      provider: ollama
      model: lfm2.5:latest
      temperature: 0.0
      endpoint: http://localhost:11434/api/chat
      api_prompt_cost: 0.000000
      api_completion_cost: 0.000000
      max_history_commands: 20
      max_recent_files: 20
      cache_dir: $HOME/.autocomplete/cache
      cache_size: 10
      log_file: $HOME/.autocomplete/autocomplete.log
    '';

    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      # Don't use home-manager's built-in compinit — we handle it ourselves in
      # completionInit with -C (cache-only) for much faster startup on NixOS.
      enableCompletion = false;
      autocd = true;
      enableVteIntegration = true;

      autosuggestion = {
        enable = true;
        highlight = "fg=8,bg=default";
      };

      defaultKeymap = "viins";
      dotDir = "${config.xdg.configHome}/zsh";

      # History configuration
      history = {
        append = true;
        extended = true;
        ignoreDups = false;
        expireDuplicatesFirst = true;
        ignoreSpace = false;
        path = "${config.xdg.dataHome}/zsh/history";
        save = 50000;
        size = 55000;
        share = true;
      };

      historySubstringSearch = {
        enable = true;
        searchDownKey = "\\e[B";
        searchUpKey = "\\e[A";
      };

      # Completion: use compinit -C on NixOS. Store paths are immutable,
      # so the completion cache is never stale — skip the file scan entirely.
      completionInit = ''
        autoload -U compinit; compinit -C
        zmodload zsh/complist
        _comp_options+=(globdots)
        WORDCHARS="$WORDCHARS//[\/[&.;]"

        # Cache completion results for speed
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "${config.xdg.cacheHome}/zsh/completion-cache"
        mkdir -p "${config.xdg.cacheHome}/zsh/completion-cache"

        # Completion menu and matcher
        zstyle ':completion:*' completer _complete _ignored _approximate
        zstyle ':completion:*' complete true
        zstyle ':completion:*' complete-options true
        zstyle ':completion:*' file-sort modification
        zstyle ':completion:*' group-name ''''
        zstyle ':completion:*' keep-prefix true
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
        zstyle ':completion:*' menu select
        zstyle ':completion:*' verbose true

        zstyle ':completion:*:default' list-prompt '%S%M matches%s'
        zstyle ':completion:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
        zstyle ':completion:*:descriptions' format '%F{blue}-- %D %d --%f'
        zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
        zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
        zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
        zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

        # Vim-style navigation in completion menu (menuselect keymap created by compinit)
        bindkey -M menuselect 'h' vi-backward-char
        bindkey -M menuselect 'k' vi-up-line-or-history
        bindkey -M menuselect 'l' vi-forward-char
        bindkey -M menuselect 'j' vi-down-line-or-history
      '';

      # ZSH initialization
      initContent = ''
        # Home/End key bindings - Jump to beginning/end of line
        bindkey '^[[H' beginning-of-line
        bindkey '^[[F' end-of-line
        bindkey '^[[1~' beginning-of-line
        bindkey '^[[4~' end-of-line
        bindkey '^[[7~' beginning-of-line
        bindkey '^[[8~' end-of-line
        bindkey '^[OH' beginning-of-line
        bindkey '^[OF' end-of-line
        bindkey -M vicmd '^[[H' beginning-of-line
        bindkey -M vicmd '^[[F' end-of-line
        bindkey -M vicmd '^[[1~' beginning-of-line
        bindkey -M vicmd '^[[4~' end-of-line
        bindkey -M vicmd '^[[7~' beginning-of-line
        bindkey -M vicmd '^[[8~' end-of-line
        bindkey -M vicmd '^[OH' beginning-of-line
        bindkey -M vicmd '^[OF' end-of-line

        # Ctrl+A / Ctrl+E - Emacs-style line navigation
        bindkey '^A' vi-beginning-of-line
        bindkey '^E' vi-end-of-line

        # Ctrl+Right / Ctrl+Left - Word navigation
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word

        # Ctrl+Backspace - Delete word backward
        bindkey '^H' backward-kill-word

        # Autocomplete.sh - LLM-powered command completion (Ollama backend)
        source ${pkgs.autocomplete-sh}/bin/autocomplete enable
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
      localVariables = {
        ZSH_AUTOSUGGEST_USE_ASYNC = "true";
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = 40;
        KEYTIMEOUT = 1;
      };

      # Shell aliases
      shellAliases = mkIf cfg.enableAliases (with pkgs; {
        # Navigation
        "cd.." = "cd ../";
        "cd..." = "cd ../../";
        fcd = "cd $(find -type d | fzf)";
        mkcd = "mkdir $1 && cd $1 ";

        # File Management and Viewing
        l = "eza -l --git --color=auto --group-directories-first --time-style=long-iso --icons -s extension";
        la = "eza -lah --tree --git --color=auto --group-directories-first --time-style=long-iso --icons -s extension";
        ll = "eza -alh";
        ls = "eza -h --git --icons --color=auto --group-directories-first -s extension";
        lx = "eza -alh -s extension --color=auto --group-directories-first --icons -R";
        tree = "eza --icons --tree";
        cat = "bat --style=plain";
        du = "${lib.getBin dust}/bin/dust";
        gz = "gzip -l";
        rm = "rm -rvf";
        trm = "${lib.getBin trash-cli}/bin/trash-cli";
        less = "moor";

        # Compression/Decompression
        decom = "_() { echo -n 'Enter base name to decrypt: '; read n; gpg -d \"$n.7z.gpg\" > \"$n.7z\" && rm \"$n.7z.gpg\" && ouch decompress \"$n.7z\" && rm \"$n.7z\"; }; _";
        encom = "_() { echo -n 'Enter directory name to compress and encrypt: '; read n; ouch compress \"$n\" \"$n.7z\" && gpg --symmetric \"$n.7z\" && rm \"$n.7z\"; }; _";

        # System
        cleanup = "sudo nix-collect-garbage --delete-older-than 3d";
        purge = "doas sync; echo 3 | doas tee /proc/sys/vm/drop_caches";
        ps = "${lib.getBin procs}/bin/procs";

        # Searching and File Opening
        grep = "${lib.getBin ripgrep-all}/bin/rga";
        fzim = "fzf | xargs nvim";
        skvim = "nvim $(find . -type f | sk -m)";
        vim = "nvim";

        # Miscellaneous
        c = "clear";
        m = "mkdir -p";
        ytmp3 = "${lib.getBin yt-dlp}/bin/yt-dlp -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title=\"%(artist)s - %(title)s\" --prefer-ffmpeg -o \"%(title)s.%(ext)s\"";

        # Downloaders
        ardo = "${lib.getBin aria2}/bin/aria2c -x 16 -s 16";
        arlist = "${lib.getBin aria2}/bin/aria2c -i $1 -j 16";

        # AI
        pgpt = "npx @pollinations/cli gen text";
      });

      zplug = mkIf cfg.enablePlugins {
        enable = true;
        zplugHome = "${config.xdg.configHome}/zsh/zplug";
        plugins = [
          {
            name = "hlissner/zsh-autopair";
            tags = ["defer:2"];
          }
          {
            name = "chisui/zsh-nix-shell";
            tags = ["defer:2"];
          }
          {
            name = "molovo/tipz";
            tags = ["defer:2"];
          }
        ];
      };
    };
  };
}
