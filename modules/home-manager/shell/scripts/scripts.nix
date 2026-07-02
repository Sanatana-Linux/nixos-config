{pkgs}: let
  ns = pkgs.writeShellScriptBin "ns" (builtins.readFile ./nixpkgs.sh);
in
  with pkgs; [
    # git add/commit/push with timestamped message
    (writeScriptBin "gita" ''
      #!/usr/bin/env bash
      git add .
      git commit -m "$(date +"%Y-%m-%d %H:%M:%S")"
      git push
    '')

    # NixOS system info display with Nix logo
    (writeScriptBin "nixfetch" ''
      f=3 b=4
      for j in f b; do
        for i in {0..7}; do
          printf -v $j$i %b "\e[''${!j}''${i}m"
        done
      done
      d=$'\e[1m'
      t=$'\e[0m'
      v=$'\e[7m'
      os_name=$(cat /etc/os-release | grep -i ID= | grep -v _ | cut -f2 -d '=')
      os_vers=$(cat /etc/os-release | grep -i VERSION_ID= | cut -f2 -d '=' | tr -d '\"')
      os="$os_name $os_vers"
      krn=$(cat /proc/version | awk '{print $3}')
      wm_id=$(xprop -root -notype _NET_SUPPORTING_WM_CHECK | awk '{print $5}')
      pkgs=$(nix-store -q --requisites /run/current-system/sw | wc -l)
      cat << EOF
                  $f4\\\\  $f6\\\\ //
                 $f4==\\\\__$f6\\\\/ $f4//
                   $f6//   \\\\$f4//
                $f6==//     $f4//==
                 $f6//$f4\\\\$f6 __$f4//
                $f6// $f4/\\\\  $f6\\\\==
                  $f4// \\\\  $f6\\\\
          $f4         os $f7.$t $os
          $f6     kernel $f7.$t $krn
          $f4      de/wm $f7.$t $wm_id
          $f6   packages $f7.$t $pkgs
              $f0 $f1 $f2 $f3 $f4 $f5 $f6 $f7 $t
      EOF
    '')

    # Mount Dropbox and Google Drive remotes via rclone
    (writeScriptBin "mountbox" ''
      #!/usr/bin/env bash
      rclone mount dropbox:/ ~/Dropbox -vv --daemon --allow-non-empty --dropbox-pacer-min-sleep 100ms --vfs-cache-mode full --vfs-cache-max-age=24h --dropbox-batch-mode sync --size-only --dir-cache-time 24h && sleep 10 && rclone rc vfs/refresh recursive=true &
      rclone mount drive-tlh:/ ~/GoogleDriveTLH --daemon --allow-non-empty --vfs-cache-mode full --vfs-cache-max-age=6h --fast-list && sleep 10 && rclone rc vfs/refresh recursive=true &
      rclone mount drive-510:/ ~/GoogleDrive510 --daemon --allow-non-empty --vfs-cache-mode full --vfs-cache-max-age=6h --fast-list - && sleep 10 && rclone rc vfs/refresh recursive=true &
    '')

    # Mount and extract ISO file contents
    (writeScriptBin "iso-open" ''
      #!/usr/bin/env bash
      set -euo pipefail
      if [ $# -ne 1 ]; then
          echo "Usage: iso-open <file.iso>"
          exit 1
      fi
      file="$1"
      if [ ! -f "$file" ]; then
          echo "Error: File '$file' does not exist"
          exit 1
      fi
      name=$(basename "$file" .iso)
      dest="./$name"
      mount_point=$(mktemp -d)
      cleanup() {
          if mountpoint -q "$mount_point" 2>/dev/null; then
              sudo umount "$mount_point" 2>/dev/null || true
          fi
          rm -rf "$mount_point"
      }
      trap cleanup EXIT INT TERM
      sudo mount -o loop,ro "$file" "$mount_point"
      mkdir -p "$dest"
      cp -r "$mount_point"/* "$dest/" 2>/dev/null || true
      chmod -R u+w "$dest"
      echo "Extracted to: $dest"
      ls -alhF "$dest"
    '')

    # Terminal color palette display (8-color ANSI swatch)
    (writeScriptBin "panes" ''
      #!/usr/bin/env bash
      f=3 b=4
      for j in f b; do
        for i in {0..7}; do
          printf -v $j$i %b "\e[''${!j}''${i}m"
        done
      done
      d=$'\e[1m'
      t=$'\e[0m'
      v=$'\e[7m'
      cat << EOF
       $f0████$d▄$t  $f1████$d▄$t  $f2████$d▄$t  $f3████$d▄$t  $f4████$d▄$t  $f5████$d▄$t  $f6████$d▄$t  $f7████$d▄$t
       $f0████$d█$t  $f1████$d█$t  $f2████$d█$t  $f3████$d█$t  $f4████$d█$t  $f5████$d█$t  $f6████$d█$t  $f7████$d█$t
       $f0████$d█$t  $f1████$d█$t  $f2████$d█$t  $f3████$d█$t  $f4████$d█$t  $f5████$d█$t  $f6████$d█$t  $f7████$d█$t
       $d$f0 ▀▀▀▀  $d$f1 ▀▀▀▀   $f2▀▀▀▀   $f3▀▀▀▀   $f4▀▀▀▀   $f5▀▀▀▀   $f6▀▀▀▀   $f7▀▀▀▀$t
      EOF
    '')

    # Colorful mushroom ASCII art terminal banner
    (writeScriptBin "shrooms" ''
      #!/usr/bin/env bash
      bkf=$'\e[30m'; rf=$'\e[31m'; gf=$'\e[32m'; yf=$'\e[33m'; bf=$'\e[34m'; mf=$'\e[35m'; cf=$'\e[36m'; wf=$'\e[37m'
      bkb=$'\e[40m'; rb=$'\e[41m'; gb=$'\e[42m'; yb=$'\e[43m'; bb=$'\e[44m'; mb=$'\e[45m'; cb=$'\e[46m'; wb=$'\e[47m'; rst=$'\e[0m'
      ibkf=$'\e[90m'; irf=$'\e[91m'; igf=$'\e[92m'; iyf=$'\e[93m'; ibf=$'\e[94m'; imf=$'\e[95m'; icf=$'\e[96m'; iwf=$'\e[97m'
      ibkb=$'\e[100m'; irb=$'\e[101m'; igb=$'\e[102m'; iyb=$'\e[103m'; ibb=$'\e[104m'; imb=$'\e[105m'; icb=$'\e[106m'; iwb=$'\e[107m';
      width=$(tput cols)
      for ((v=0; v < (width-64)/3; v++)); do spaces="$spaces "; done
      cat << EOF
      $ibkf   ▄▄█$wb▀$rb▀▀$wb▀█$rst$ibkf▄$rst$break$spaces    $ibkf   ▄▄█$wb▀$igb▀▀$wb▀█$rst$ibkf▄$rst$break$spaces    $ibkf   ▄▄█$wb▀$yb▀▀$wb▀█$rst$ibkf▄$rst$break$spaces    $ibkf   ▄▄█$wb▀$bb▀▀$wb▀█$rst$ibkf▄$rst
      $ibkf ▄█$rb▀$wf██▀$rf██$wf$rb▀██$ibkf▀█$rst$break$spaces $ibkf ▄█$igb▀$wf██▀$igf██$wf$igb▀██$ibkf▀█$rst$break$spaces $ibkf ▄█$yb▀$wf██▀$yf██$wf$yb▀██$ibkf▀█$rst$break$spaces $ibkf ▄█$bb▀$wf██▀$bf██$wf$bb▀██$ibkf▀█$rst
      $ibkf▄█$wf█$rb▄$rf██$wb▀▀▀▀██▀$wf█$rst$ibkf█▄$rst$break$spaces$ibkf▄█$wf█$igb▄$igf██$wb▀▀▀▀██▀$wf█$ibkf█▄$rst$break$spaces$ibkf▄█$wf█$yb▄$yf██$wb▀▀▀▀██▀$wf█$ibkf█▄$rst$break$spaces$ibkf▄█$wf█$bb▄$bf██$wb▀▀▀▀██▀$wf█$ibkf█▄$rst
      $ibkf█$wf███$rf█$wf██████$rf█$wf███$ibkf█$rst$break$spaces$ibkf█$wf███$igf█$wf██████$igf█$wf███$ibkf█$rst$break$spaces$ibkf█$wf███$yf█$wf██████$yf█$wf███$ibkf█$rst$break$spaces$ibkf█$wf███$bf█$wf██████$bf█$wf███$ibkf█$rst
      $ibkf█$rf$wb▄▄██▄$wf████$rf$wb▄██▄▄$ibkf█$rst$break$spaces$ibkf█$igf$wb▄▄██▄$wf████$igf$wb▄██▄▄$ibkf█$rst$break$spaces$ibkf█$yf$wb▄▄██▄$wf████$yf$wb▄██▄▄$ibkf█$rst$break$spaces$ibkf█$bf$wb▄▄██▄$wf████$bf$wb▄██▄▄$ibkf█$rst
      $ibkf█$wb▄▄█▀▀█▀▀█▀▀█▄▄█$rst$break$spaces$ibkf█$wb▄▄█▀▀█▀▀█▀▀█▄▄█$rst$break$spaces$ibkf█$wb▄▄█▀▀█▀▀█▀▀█▄▄█$rst$break$spaces$ibkf█$wb▄▄█▀▀█▀▀█▀▀█▄▄█$rst
      $ibkf ▀█$wf███$ibkb▄██▄███$rst$ibkf█▀$rst$break$spaces $ibkf ▀█$wf███$ibkb▄██▄███$rst$ibkf█▀$rst$break$spaces $ibkf ▀█$wf███$ibkb▄██▄███$rst$ibkf█▀$rst$break$spaces $ibkf ▀█$wf███$ibkb▄██▄███$rst$ibkf█▀$rst
      $ibkf  ▀█$wb▄▄▄▄▄▄▄▄█$rst$ibkf▀$rst$break$spaces  $ibkf  ▀█$wb▄▄▄▄▄▄▄▄█$rst$ibkf▀$rst$break$spaces  $ibkf  ▀█$wb▄▄▄▄▄▄▄▄█$rst$ibkf▀$rst$break$spaces  $ibkf  ▀█$wb▄▄▄▄▄▄▄▄█$rst$ibkf▀$rst
      $break
      EOF
    '')

    # Nixpkgs search
    ns
  ]
