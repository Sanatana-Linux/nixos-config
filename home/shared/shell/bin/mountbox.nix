{pkgs}:
with pkgs;
  writeScriptBin "mountbox" ''
    #!/usr/bin/env bash
    # Assumes a remote called dropbox is already configured and the
    # user wants to mount it at ~/Dropbox
    rclone mount dropbox:/ ~/Dropbox -vv  --daemon   --allow-non-empty --dropbox-pacer-min-sleep 100ms --vfs-cache-mode full --vfs-cache-max-age=24h --dropbox-batch-mode sync --size-only --dir-cache-time 24h   && sleep 10  && rclone rc vfs/refresh recursive=true &
    rclone mount drive-tlh:/ ~/GoogleDriveTLH    --daemon --allow-non-empty --vfs-cache-mode full --vfs-cache-max-age=6h --fast-list  && sleep 10  && rclone rc vfs/refresh recursive=true &
    rclone mount drive-510:/ ~/GoogleDrive510 --daemon --allow-non-empty --vfs-cache-mode full --vfs-cache-max-age=6h --fast-list - && sleep 10 && rclone rc vfs/refresh recursive=true &
  ''
