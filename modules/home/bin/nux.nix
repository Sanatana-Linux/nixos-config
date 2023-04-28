{ pkgs }:

with pkgs;

writeScriptBin "nux" ''
  #!/usr/bin/env bash
  dots="/etc/nixos"



  function help() {
      cat <<EOF
  Usage: nux [OPTION] [OPTION]

  Options:
      help         show this text
      +------------------------------------------------------------+
      sync         pull config from git repo, then commit and push
      rebuild      rebuild configuration for host
      vm           build a vm
      rollback     rollback to previous generation
      update       update flake
      clean        clean and garabge collect store
  EOF
  }

  function sync() {
      echo "Syncing nix config"
      cd $dots \
      &&  git pull \
      &&  git add . \
      &&  git commit \
      &&  git push \
      || echo "Error with location of Nix Configuration" \
      && exit
  }

  function rebuild() {
      echo "Rebuilding config"
      doas nixos-rebuild --flake /etc/nixos#"$2" --impure switch
  }

  function vm() {
      echo "Creating VM"
      doas nixos-rebuild --flake /etc/nixos#"$2" --impure build-vm
  }

  function rollback() {
      echo "Rolling back"
      doas nixos-rebuild --rollback switch
  }

  function update() {
      echo "Updating flake"
      doas nix flake update $dots
  }

  function clean() {
      echo "Clearing store"
      doas nix-store --gc
      echo "Removing old generations"
      doas nix-env --delete-generations old
      echo "Collecting system garbage"
      doas nix-collect-garbage -d
      echo "Collecting system garbage"
      nix-collect-garbage -d
  }



  case "$1" in
      sync)      sync ;;
      rebuild)   rebuild "$@";;
      vm)        vm "$@";;
      rollback)  rollback ;;
      update)    update ;;
      clean)     clean ;;
      help)    help ;;
      *)       help ;;
  esac

''
