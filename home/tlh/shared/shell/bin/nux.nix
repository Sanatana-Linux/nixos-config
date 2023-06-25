{pkgs}:
with pkgs;
  writeScriptBin "nux" ''
     #!/usr/bin/env bash
     dots="/etc/nixos"
     awesomewm="$HOME/.config/awesome"
     nvim="$HOME/.config/nvim"

    function help() {
        cat <<EOF
    Usage: nux [OPTION] [OPTION]

    Options:
        help               show this text
        repair             repair the Nix Store
        clean              clean and garabge collect store
        rebuild            rebuild configuration for host
        optimize           clean then optimize the Nix Store
        rollback           rollback to previous generation
        search             search packages available
        sync               pull config from git repo, then commit and push
        update             update flake
        vm                 build a vm
    EOF
    }

    function repair() {
      doas nix-collect-garbage -d
      doas nix-store --verify --repair
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
        doas nixos-rebuild --flake $dots#"$2" --impure switch
    }

    function vm() {
        echo "Creating VM"
        doas nixos-rebuild --flake $dots#"$2" --impure build-vm
    }

     function optimize() {
        doas nix-collect-garbage -d
        doas nix-store --optimize --verbose 
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
        echo "Collecting user garbage"
        nix-collect-garbage -d
        nix profile wipe-history
    }




    function search() {
       nps -C=description --separator=true "$2"
    }

    case "$1" in
        sync)       sync ;;
        repair)     repair ;;
        rebuild)    rebuild "$@";;
        optimize)    optimize;;
        vm)         vm "$@";;
        rollback)   rollback ;;
        update)     update ;;
        clean)      clean ;;
        search)     search "$@" ;;
        help)       help ;;
        *)          help ;;
    esac
  ''
