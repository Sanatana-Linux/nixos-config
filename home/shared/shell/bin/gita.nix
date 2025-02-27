{pkgs}:
with pkgs;
  writeScriptBin "gita" ''
    #!/usr/bin/env bash

    git add .

    git commit -m "$(date +"%Y-%m-%d %H:%M:%S")"

    git push

  ''
