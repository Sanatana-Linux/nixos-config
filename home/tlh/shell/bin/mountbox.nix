{config, pkgs}:
with pkgs;
  writeScriptBin "panes" ''
    #!/usr/bin/env bash
    # Assumes a remote called dropbox is already configured and the 
    # user wants to mount it at ~/Dropbox
  rclone mount dropbox:/ ${config.home.homeDirectory}/Dropbox  --daemon   --allow-non-empty      & 
  ''

