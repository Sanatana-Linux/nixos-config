{pkgs}:
with pkgs;
  writeScriptBin "nux" ''
     #!/usr/bin/env bash
     dots="/etc/nixos"

    function help() {
    cat <<EOF

    The Nux script is a wrapper around various functions that ease the use
    of the Nix package manager within the context of a NixOS system.

    Usage: nux [OPTION] [OPTION]

    Options:
        help               show this text
        repair             repair the Nix Store
        clean              clean and garabge collect store
        rebuild            rebuild configuration for host
        optimize           clean then optimize the Nix Store
        weight             determine the size of the system's configuration
        rollback           rollback to previous generation
        search             search packages available
        sync               pull config from git repo, then commit and push
        update             update flake
        vm                 build a vm
    EOF
    }

    function repair() {
      echo "Repairing the Nix Store Now"
      doas nix-collect-garbage -d
      doas nix-store --verify --repair
      doas nix-store --verify --check-contents --repair
      doas nix store verify --all
      doas nix store repair --all
     doas nix-collect-garbage -d
      echo "Repair Process Finished"
    }

    function weight(){
      echo "You Current System Size is:"
        nix path-info -Sh /run/current-system
    }
    function sync() {
        echo "Syncing Nix Configuration Now"
        cd $dots \
        &&  git pull \
        &&  git add . \
        &&  git commit \
        &&  git push \
        || echo "Error with location of Nix Configuration" \
        && exit
        echo "Sync Completed!"
      }

    function rebuild() {
        echo "Rebuilding Configuration Now"
        rm -rf $HOME/.config/*.bak
        rm -rf $HOME/.config/**/*.bak
        doas nixos-rebuild switch --impure --flake $dots#"$2" -v && echo "Done Rebuilding NixOS Configuration"
    }

    function vm() {
        echo "Creating Virtual Machine Now"
        doas nixos-rebuild --flake $dots#"$2" --impure build-vm
    }

     function optimize() {
       echo "Optimizing the Nix Store Now"
        doas nix-collect-garbage -d
        doas nix-store --verify --check-contents --repair
        doas nix-store --optimize --verbose
     }

    function rollback() {
        echo "Rolling Back Configuration Now"
        doas nixos-rebuild --rollback switch
    }

    function update() {
        echo "Updating Flake Lock File Now"
        doas nix flake update
        rm -rf $HOME/.config/*.bak
        rm -rf $HOME/.config/**/*.bak
        sudo nixos-rebuild switch --flake . --upgrade
    }

    function clean() {
        echo "Cleaning the Nix Store"
        doas nix-store --gc
        echo "Removing old generations"
        doas nix-env --delete-generations old
        echo "Collecting system garbage"
        doas nix-collect-garbage -d
        echo "Collecting user garbage"
        nix-collect-garbage -d
        nix profile wipe-history
        doas janitor --gc
    }




    function search() {
       nix-search  "$2" --details
    }

    case "$1" in
        sync)       sync ;;
        repair)     repair ;;
        rebuild)    rebuild "$@";;
        optimize)    optimize;;
        vm)         vm "$@";;
        rollback)   rollback ;;
        weight)     weight ;;
        update)     update ;;
        clean)      clean ;;
        search)     search "$@" ;;
        help)       help ;;
        *)          help ;;
    esac
  ''
