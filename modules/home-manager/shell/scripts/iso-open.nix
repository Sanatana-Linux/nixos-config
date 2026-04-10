{pkgs}:
with pkgs;
  writeScriptBin "iso-open" ''
    #!/usr/bin/env bash
    # unarchive an iso file
    file="$1"
    name=$(basename "$file" .iso)
    dest="$HOME/$name"
    sudo mkdir -p "$dest" && sudo mount -o loop "$file" "$dest" && cd "$dest" && ls -alhF
  ''
