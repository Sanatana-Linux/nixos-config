{pkgs}:
with pkgs;
# We will use writeScriptBin as requested, and inject the necessary PATH
# at the top of the script.
  writeScriptBin "nix-search-tv-integration" ''
      #!/usr/bin/env bash

      # === Dependency Injection ===
      # This is the crucial fix for a `writeScriptBin` script. We are building
      # a PATH variable that includes all the tools our script needs to run.
      # This line is processed by Nix when the script is built, embedding the
      # full /nix/store paths into the final script.
      export PATH="${lib.makeBinPath [
      nix-search-tv
      fzf
      xdg-utils # for xdg-open
      ncurses # for tput
      nix # for nix-shell
      gnused # for sed
      gawk # for awk
      coreutils # for tr
    ]}:$PATH"

      # === Keybinds and Indexes ===

      SEARCH_SNIPPET_KEY="ctrl-w"
      OPEN_SOURCE_KEY="ctrl-s"
      OPEN_HOMEPAGE_KEY="ctrl-o"
      NIX_SHELL_KEY="ctrl-i"
      OPENER="xdg-open"

      # === State and Command Setup ===

      # We can now refer to the command directly as it's in our PATH.
      CMD="nix-search-tv"
      STATE_FILE="/tmp/nix-search-tv-fzf"

      # === Functions ===

      bind_index() {
          local key="$1" index="$2"
          local prompt="" indexes_flag=""
          [[ -n "$index" && "$index" != "all" ]] && indexes_flag="--indexes $index" && prompt=$index
          local preview="$CMD preview $indexes_flag"
          local print="$CMD print $indexes_flag"
          echo "$key:change-prompt($prompt> )+change-preview($preview {})+reload($print)"
      }

      save_state() {
          local index="$1"
          local indexes_flag=""
          [[ -n "$index" && "$index" != "all" ]] && indexes_flag="--indexes $index"
          echo "execute(echo $indexes_flag > $STATE_FILE)"
      }

      # === Header and FZF Binds ===

      HEADER="$OPEN_HOMEPAGE_KEY - open homepage
    $OPEN_SOURCE_KEY - open source
    $SEARCH_SNIPPET_KEY - search github for snippets
    $NIX_SHELL_KEY - nix-shell
    "

      FZF_BINDS=""
      while IFS=":" read -r index keybind; do
          fzf_bind=$(bind_index "$keybind" "$index")
          fzf_save_state=$(save_state "$index")
          FZF_BINDS="$FZF_BINDS --bind '$fzf_bind+$fzf_save_state'"
          # FIX 1: We must escape the '$' in bash's `$'...'` syntax.
          # The escape sequence in Nix's indented strings is `''$`.
          HEADER+="$keybind - $index"''$'\n'
      done <<EOF
    nixpkgs:ctrl-n
    home-manager:ctrl-h
    all:ctrl-a
    EOF

      # === Reset State ===

      : > "$STATE_FILE"

      # === Command Templates ===

      # The original command was fine, just ensuring robustness with quoting.
      SEARCH_SNIPPET_CMD='url=$(echo "{}" | tr -d "'"'"'" | awk "{ print \$2 ? \$2 : \$1 }" | xargs -I{} printf "https://github.com/search?type=code&q=lang:nix+%s" "{}"); '"$OPENER"' "$url"'

      NIX_SHELL_CMD='nix-shell --run "$SHELL" -p $(echo "{}" | sed "s:nixpkgs/::g" | tr -d "'"'"'")'

      # === Preview Window ===

      PREVIEW_WINDOW="wrap"
      [ "$(tput cols)" -lt 90 ] && PREVIEW_WINDOW="$PREVIEW_WINDOW,up"

      # === Main FZF Invocation ===

      eval "$CMD print | fzf \
          --preview '$CMD preview \$(cat $STATE_FILE) {}' \
          --bind '$OPEN_SOURCE_KEY:execute($CMD source \$(cat $STATE_FILE) {} | xargs -r $OPENER)' \
          --bind '$OPEN_HOMEPAGE_KEY:execute($CMD homepage \$(cat $STATE_FILE) {} | xargs -r $OPENER)' \
          --bind ''$'$SEARCH_SNIPPET_KEY:execute($SEARCH_SNIPPET_CMD)' \
          --bind ''$'$NIX_SHELL_KEY:become($NIX_SHELL_CMD)' \
          --layout reverse \
          --scheme history \
          --preview-window='$PREVIEW_WINDOW' \
          --header \"$HEADER\" \
          --header-first \
          --header-border \
          --header-label \"Help\" \
          $FZF_BINDS
      "
  ''
