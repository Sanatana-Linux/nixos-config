{pkgs}:
with pkgs;
  writeScriptBin "dix" ''
         #!/usr/bin/env bash
         dots="/etc/nixos"

        function help() {
         WHITE_PINK="\e[38;2;232;232;232m"
         SKY_BLUE="\e[38;2;136;192;208m"
         MAGENTA="\e[38;2;154;32;201m"
         ORANGE="\e[38;2;242;161;56m"
         DIRTY="\e[38;2;133;133;133m"
         YELLOW="\e[38;2;219;245;76m"
         RED="\e[38;2;191;97;106m"

         UNDERLINE="\e[4m"
         SPECIAL_END="\e[0m"


        echo -e "$SKY_BLUE Description: $SPECIAL_END"
        echo "This script, named for the artist Otto Dix, is a personal"
        echo "wrapper script around various functions I use to ease the"
        echo "administration of my NixOS systems."
        echo
        echo
        echo -e "$DIRTY dix $SPECIAL_END [command] [flags]"
        echo
        echo -e "$YELLOW Available commands: $SPECIAL_END"
        echo
        echo -e  "            $ORANGE help $SPECIAL_END               show this  text"
        echo -e  "            $MAGENTA repair $SPECIAL_END             repair the Nix Store"
        echo -e  "            $RED clean $SPECIAL_END              clean and garabge collect store"
        echo -e  "            $WHITE_PINK rebuild $SPECIAL_END            rebuild configuration for host"
        echo -e  "            $SKY_BLUE optimize $SPECIAL_END           clean then optimize the Nix Store"
        echo -e  "            $YELLOW weight $SPECIAL_END             determine the size of the system's configuration"
        echo -e  "            $ORANGE rollback $SPECIAL_END           rollback to previous generation"
        echo -e  "            $MAGENTA search $SPECIAL_END             search packages available"
        echo -e  "            $RED options $SPECIAL_END            search nixos and home-manager options"
        echo -e   "            $WHITE_PINK sync $SPECIAL_END               pull config from git repo, then commit and push"
        echo -e "            $SKY_BLUE update $SPECIAL_END             update flake"
        echo -e "            $YELLOW format $SPECIAL_END             format nix files in configuration"
        echo -e "            $ORANGE vm $SPECIAL_END                 build a vm"

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

        function format(){
            echo "Formatting NixOS Configuration Files Now"
            cd $dots
            alejandra **/*.nix
        }

        function weight(){
          echo "You Current System Size is:"
            nix path-info -Sh /run/current-system
        }
        function sync() {
    echo "Syncing Nix Configuration Now"
         cd $dots && git add . && git commit  && git push && echo "Sync Completed!" || echo "Error With Git, See Output Above"  && exit
          }

        function rebuild() {
            echo "Rebuilding Configuration Now"
            rm -rf $HOME/.config/*.bak
            rm -rf $HOME/.config/**/*.bak
            doas nixos-rebuild switch --flake ".#$2" --impure -v && echo "Done Rebuilding NixOS Configuration"
        }

        function vm() {
            echo "Creating Virtual Machine Now"
            doas nixos-rebuild --flake $dots#"$2" --impure build-vm
        }

         function optimize() {
           echo "Optimizing the Nix Store Now"
            doas nix-collect-garbage -d
            doas nix-store --verify --check-contents --repair
            doas nix-store  --optimize --verbose
         }

        function rollback() {
            echo "Rolling Back Configuration Now"
            doas nixos-rebuild --rollback switch
        }

        function update() {
            echo "Updating Flake Lock File Now"
            doas nix flake update
    }


        function clean() {
            echo "Cleaning the Nix Store"
            doas nix-store --gc
            echo "Removing old generations"
            doas nix-env --delete-generations old
            echo "Collecting system garbage"
            doas nix-collect-garbage -d
            doas nix profile wipe-history
            echo "Collecting user garbage"
            nix-collect-garbage -d
            nix profile wipe-history
            doas janitor --gc
        }




        function search() {
           nix search  nixpkgs "$2"
        }

        function options(){
            manix  --source=hm_options,nixos_options,nixpkgs_doc,nixpkgs_tree,nixpkgs_comments "$2"
        }

        case "$1" in
            sync)       sync ;;
            repair)     repair ;;
            rebuild)    rebuild "$@";;
            optimize)    optimize;;
            format)     format;;
            vm)         vm "$@";;
            rollback)   rollback ;;
            weight)     weight ;;
            update)     update ;;
            clean)      clean ;;
            search)     search "$@" ;;
            options)    options "$@";;
            help)       help ;;
            *)          help ;;
        esac
  ''
