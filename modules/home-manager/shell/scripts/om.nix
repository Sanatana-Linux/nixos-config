{pkgs}:
with pkgs;
  writeScriptBin "om" ''
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
      GREEN="\e[38;2;134;239;172m"

      UNDERLINE="\e[4m"
      SPECIAL_END="\e[0m"

      echo -e "$SKY_BLUE Description: $SPECIAL_END"
      echo " This script is a personal wrapper script around various functions"
      echo " used to ease the administration of NixOS systems. Not to be "
      echo " confused with omnix, which is unrelated... and not as useful ;]"
      echo
      echo
      echo -e "$RED USAGE: $SPECIAL_END $DIRTY om $SPECIAL_END [command]"
      echo
      echo -e "$GREEN Available commands: $SPECIAL_END"
      echo
      echo -e "            $SKY_BLUE help $SPECIAL_END               show this text"
      echo -e "            $SKY_BLUE repair $SPECIAL_END             repair the Nix Store"
      echo -e "            $SKY_BLUE clean $SPECIAL_END              clean and garbage collect store"
      echo -e "            $SKY_BLUE rebuild $SPECIAL_END            rebuild configuration for host"
      echo -e "            $SKY_BLUE optimize $SPECIAL_END           clean then optimize the Nix Store"
      echo -e "            $SKY_BLUE weight $SPECIAL_END             determine the size of the system's configuration"
      echo -e "            $SKY_BLUE rollback $SPECIAL_END           rollback to previous generation"
      echo -e "            $SKY_BLUE search $SPECIAL_END             search packages available"
      echo -e "            $SKY_BLUE options $SPECIAL_END            search nixos and home-manager options"
      echo -e "            $SKY_BLUE sync $SPECIAL_END               pull config from git repo, then commit and push"
      echo -e "            $SKY_BLUE update $SPECIAL_END             update flake"
      echo -e "            $SKY_BLUE format $SPECIAL_END             format nix files in configuration"
      echo -e "            $SKY_BLUE vm $SPECIAL_END                 build a vm"
      echo -e "            $SKY_BLUE health $SPECIAL_END             run nix-health check"
      echo -e "            $SKY_BLUE tree $SPECIAL_END               show dependency tree for a host (nix-tree)"
      echo -e "            $SKY_BLUE build-iso $SPECIAL_END          build chhinamasta ISO and copy to $DIRTY<dest-dir>$SPECIAL_END"
    }

    function repair() {
      echo "Repairing the Nix Store Now"
      doas nix-store --verify --repair
      doas nix-store --verify --check-contents --repair
      doas nix store verify --all
      doas nix store repair --all
      doas nix-collect-garbage -d
      echo "Finding SymLinks into the Store & Deleting"
      doas find ~/* -lname '/nix/store/*' -delete
      echo "Run the Garbage Collector"
      doas nix-store --gc

      echo "Repair Process Finished"
    }

    function format() {
      echo "Formatting NixOS Configuration Files Now"
      find "$dots" -name "*.nix" -print0 | while IFS= read -r -d $'\0' file; do
        alejandra "$file"
      done
    }

    function weight() {
      echo "You Current System Size is:"
      nix path-info -Sh /run/current-system
    }

    function sync() {
      echo "Syncing Nix Configuration Now"
      cd $dots && git add . && git commit && git push && echo "Sync Completed!" || echo "Error With Git, See Output Above" && exit
    }

    function rebuild() {
      echo "Rebuilding Configuration Now"
      rm -rf $HOME/.config/*.bak
      rm -rf $HOME/.config/**/*.bak
      nixos-rebuild switch --flake ".#$2" --impure  --sudo && echo "Done Rebuilding NixOS Configuration"
    }

    function vm() {
      echo "Creating Virtual Machine Now"
      nixos-rebuild --flake $dots#"$2" --impure build-vm
    }

    function optimize() {
      echo "Optimizing the Nix Store Now"
      doas nix store optimise --verbose
      doas nix-store --optimize --verbose
    }

    function rollback() {
      echo "Rolling Back Configuration Now"
      nixos-rebuild --rollback switch
    }

    function update() {
      echo "Updating Flake Lock File Now"
      nix flake update
    }

    function clean() {
      echo "Cleaning the Nix Store"
      echo "Finding SymLinks into the Store & Deleting"
      doas find ~/* -lname '/nix/store/*' -delete
      echo "Run the Garbage Collector"
      doas nix-store --gc
      echo "Removing Old Generations"
      doas nix-env --delete-generations old
      echo "Collecting System Garbage"
      doas nix-collect-garbage -d
      doas nix profile wipe-history
      echo "Collecting User Garbage"
      nix-collect-garbage -d
      nix profile wipe-history
      echo "Running nix-janitor as a Redundancy"
      doas janitor --gc
    }

    function search() {
      #  rippkgs  -m 100 "$2"
      nps -e=true "$2"
    }

    function options() {
             ns
    }

    function health() {
      echo "Running nix-health check"
      nix-health
    }

    function tree() {
      nix-tree ".#$2" --derivation
    }

    function build-iso() {
      local host="$2"
      local dest="$3"

      if [ -z "$host" ]; then
        echo -e "\e[38;2;191;97;106mError:\e[0m Please provide a host (chhinamasta or shodashi)."
        echo -e "  Usage: \e[38;2;133;133;133mom\e[0m build-iso \e[38;2;133;133;133m<host> /path/to/output\e[0m"
        exit 1
      fi

      if [[ "$host" != "chhinamasta" && "$host" != "shodashi" ]]; then
         echo -e "\e[38;2;191;97;106mError:\e[0m Invalid host. Must be 'chhinamasta' or 'shodashi'."
         exit 1
      fi

      if [ -z "$dest" ]; then
        echo -e "\e[38;2;191;97;106mError:\e[0m Please provide a destination directory."
        echo -e "  Usage: \e[38;2;133;133;133mom\e[0m build-iso \e[38;2;133;133;133m$host /path/to/output\e[0m"
        exit 1
      fi

      if [ ! -d "$dest" ]; then
        echo -e "\e[38;2;219;245;76mDirectory does not exist, creating:\e[0m $dest"
        mkdir -p "$dest" || { echo -e "\e[38;2;191;97;106mError:\e[0m Failed to create directory $dest"; exit 1; }
      fi

      echo -e "\e[38;2;136;192;208mBuilding $host ISO image...\e[0m"
      local build_result
      build_result=$(nix build "$dots#nixosConfigurations.$host.config.system.build.isoImage" --no-link --print-out-paths 2>&1)

      if [ $? -ne 0 ]; then
        echo -e "\e[38;2;191;97;106mError:\e[0m ISO build failed:"
        echo "$build_result"
        exit 1
      fi

      local iso_path
      iso_path=$(find "$build_result" -name "*.iso" -type f | head -n 1)

      if [ -z "$iso_path" ]; then
        echo -e "\e[38;2;191;97;106mError:\e[0m No .iso file found in build output: $build_result"
        exit 1
      fi

      local iso_name
      iso_name=$(basename "$iso_path")
      echo -e "\e[38;2;134;239;172mBuild complete:\e[0m $iso_name"
      echo -e "\e[38;2;136;192;208mCopying to:\e[0m $dest/$iso_name"
      cp "$iso_path" "$dest/$iso_name" || { echo -e "\e[38;2;191;97;106mError:\e[0m Failed to copy ISO to $dest"; exit 1; }

      local iso_size
      iso_size=$(du -h "$dest/$iso_name" | cut -f1)
      echo -e "\e[38;2;134;239;172mDone!\e[0m ISO copied to $dest/$iso_name ($iso_size)"
    }

    case "$1" in
    sync)
      sync
      ;;
    repair)
      repair
      ;;
    rebuild)
      rebuild "$@"
      ;;
    optimize)
      optimize
      ;;
    format)
      format
      ;;
    vm)
      vm "$@"
      ;;
    rollback)
      rollback
      ;;
    weight)
      weight
      ;;
    update)
      update
      ;;
    clean)
      clean
      ;;
    search)
      search "$@"
      ;;
    options)
      options "$@"
      ;;
    health)
      health
      ;;
    tree)
      tree "$@"
      ;;
    build-iso)
      build-iso "$@"
      ;;
    help)
      help
      ;;
    *)
      help
      ;;
    esac
  ''
