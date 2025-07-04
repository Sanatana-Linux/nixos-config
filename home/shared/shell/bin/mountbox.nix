{pkgs}:
with pkgs;
  writeScriptBin "mountbox" ''
      #!/usr/bin/env bash
      # Assumes a remote called dropbox is already configured and the
      # user wants to mount it at ~/Dropbox
    rclone mount dropbox:/ ~/Dropbox  --daemon   --allow-non-empty --dropbox-pacer-min-sleep 100ms --vfs-cache-mode full
  ''
