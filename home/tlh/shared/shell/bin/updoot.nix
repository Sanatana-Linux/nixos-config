{pkgs}:
with pkgs;
  writeScriptBin "updoot" ''
    [ -f "$1" ] && op="cat"
    ''${op:-echo} "''${@:-$(cat -)}" \
        | curl -sF file='@-' 'http://0x0.st' \
        | tee /dev/stderr \
        | tr -d '\n'      \
        | xclip -sel clip

  ''
