{pkgs}:
let
  bashScript = ''
    #!/usr/bin/env bash
    ps=()
    os=()

    for p in "$@"; do
      if [[ "$p" != --* ]]; then
        ps+=("nixpkgs#$p")
      else
        os+=("$p")
      fi
    done

    cmd=(SHELL="''${which zsh}''" IN_NIX_SHELL="impure" nix shell "''${os[@]}''" "''${ps[@]}''")
    echo "Executing: ''${cmd[*]}''" # echo with extra single quotes for Nix
    "''${cmd[@]}''" # Execute the command.  Double single quotes for Nix evaluation.
  '';
in
writeScriptBin "nix-shell-wrapper" bashScript
