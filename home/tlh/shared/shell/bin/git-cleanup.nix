{pkgs}:
with pkgs;
  writeScriptBin "git-cleanup" ''

           #!/usr/bin/env bash

      # Repository cleanup

      echo "Cleaning up repository..."

      # Backup config & remove git dir
      echo "Backing up config & deleting git dir..."
      mv .git/config config
      rm -rf .git

      # Setup git
      echo "Setting up git repository..."
    git init
    git config --global user.name "Thomashighbaugh"
    git config --global user.email "thighbaugh@zoho.com"
      sudo ${pkgs.git} config --system core.editor vim
    git config --global credential.helper cache
    git config credential.helper store
    git config --global push.default simple
      echo "Git repository setup complete!"

      # Move config to git again & push changes to repository
      echo "Moving config to git dir & push changes..."
      mv config .git/config
    git add --all .
    git commit -m "From Script"
    git push origin master --force

      echo "Clean up completed."

  ''
