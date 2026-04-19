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
      echo -e "            $SKY_BLUE clean $SPECIAL_END              clean and garbage collect store"
      echo -e "            $SKY_BLUE rebuild $SPECIAL_END            rebuild configuration for host"
      echo -e "            $SKY_BLUE optimize $SPECIAL_END           clean then optimize the Nix Store"
      echo -e "            $SKY_BLUE weight $SPECIAL_END             determine the size of the system's configuration"
      echo -e "            $SKY_BLUE rollback $SPECIAL_END           rollback to previous generation"
      echo -e "            $SKY_BLUE search $SPECIAL_END             search packages available"
      echo -e "            $SKY_BLUE options $SPECIAL_END            search nixos and home-manager options"
      echo -e "            $SKY_BLUE sync $SPECIAL_END               sync external repos and main config with commit message"
      echo -e "            $SKY_BLUE update $SPECIAL_END             update flake"
      echo -e "            $SKY_BLUE format $SPECIAL_END             format nix files in configuration"
      echo -e "            $SKY_BLUE vm $SPECIAL_END                 build a vm"
      echo -e "            $SKY_BLUE health $SPECIAL_END             run nix-health check"
      echo -e "            $SKY_BLUE tree $SPECIAL_END               show dependency tree for a host (nix-tree)"
      echo -e "            $SKY_BLUE build-iso $SPECIAL_END          build ISO (chhinamasta or bhairavi) and copy to $DIRTY<dest-dir>$SPECIAL_END"
      echo -e "            $SKY_BLUE build-qcow $SPECIAL_END         build bhairavi qcow2 image with custom size (GB)"
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
      local commit_msg="$2"
      
      if [ -z "$commit_msg" ]; then
        echo -e "\e[38;2;191;97;106mError:\e[0m Please provide a commit message."
        echo -e "  Usage: \e[38;2;133;133;133mom\e[0m sync \e[38;2;133;133;133m\"commit message\"\e[0m"
        exit 1
      fi

      local external_dir="$dots/external"
      local failed=0

      if [ -d "$external_dir" ]; then
        echo -e "\e[38;2;136;192;208mSyncing external repositories...\e[0m"
        for dir in "$external_dir"/*/; do
          if [ -d "$dir/.git" ]; then
            local dirname=$(basename "$dir")
            echo -e "\e[38;2;134;239;172mProcessing:\e[0m $dirname"
            cd "$dir" || { echo -e "\e[38;2;191;97;106mError:\e[0m Cannot enter $dir"; continue; }
            
            if git diff-index --quiet HEAD -- 2>/dev/null; then
              echo -e "  \e[38;2;133;133;133mNo changes in $dirname\e[0m"
            else
              git add . && \
              git commit -m "$commit_msg" && \
              git push && \
              echo -e "  \e[38;2;134;239;172mSynced $dirname\e[0m" || \
              { echo -e "  \e[38;2;191;97;106mError syncing $dirname\e[0m"; failed=1; }
            fi
          fi
        done
      fi

      echo -e "\e[38;2;136;192;208mSyncing main NixOS configuration...\e[0m"
      cd "$dots" || { echo -e "\e[38;2;191;97;106mError:\e[0m Cannot enter $dots"; exit 1; }
      
      if git diff-index --quiet HEAD -- 2>/dev/null; then
        echo -e "\e[38;2;133;133;133mNo changes in main configuration\e[0m"
      else
        git add . && \
        git commit -m "$commit_msg" && \
        git push && \
        echo -e "\e[38;2;134;239;172mSynced main configuration\e[0m" || \
        { echo -e "\e[38;2;191;97;106mError syncing main configuration\e[0m"; failed=1; }
      fi

      if [ $failed -eq 0 ]; then
        echo -e "\e[38;2;134;239;172mAll repositories synced successfully!\e[0m"
      else
        echo -e "\e[38;2;219;245;76mSome repositories had errors. Check output above.\e[0m"
        exit 1
      fi
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
      echo "Deleting all historical versions older than 7 days"
      doas nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system
      echo "Finding SymLinks into the Store & Deleting Them Now"
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
      local dest="$2"
      local host="$3"

      if [ -z "$dest" ]; then
        echo -e "\e[38;2;191;97;106mError:\e[0m Please provide a destination directory."
        echo -e "  Usage: \e[38;2;133;133;133mom\e[0m build-iso \e[38;2;133;133;133m/path/to/output [chhinamasta|bhairavi]\e[0m"
        exit 1
      fi

      if [ -z "$host" ]; then
        echo -e "\e[38;2;219;245;76mNo host specified, defaulting to chhinamasta\e[0m"
        host="chhinamasta"
      fi

      if [[ "$host" != "chhinamasta" && "$host" != "bhairavi" ]]; then
        echo -e "\e[38;2;191;97;106mError:\e[0m Invalid host. Must be 'chhinamasta' or 'bhairavi'."
        echo -e "  Usage: \e[38;2;133;133;133mom\e[0m build-iso \e[38;2;133;133;133m/path/to/output [chhinamasta|bhairavi]\e[0m"
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

    function build-qcow() {
      local dest="$2"
      local disk_size="$3"

      if [ -z "$dest" ]; then
        echo -e "\e[38;2;191;97;106mError:\e[0m Please provide a destination directory."
        echo -e "  Usage: \e[38;2;133;133;133mom\e[0m build-qcow \e[38;2;133;133;133m/path/to/output [disk-size-GB]\e[0m"
        echo -e "  Example: \e[38;2;133;133;133mom\e[0m build-qcow /tmp/vms 80"
        exit 1
      fi

      if [ -z "$disk_size" ]; then
        echo -e "\e[38;2;219;245;76mNo disk size specified, defaulting to 50 GB\e[0m"
        disk_size=50
      fi

      if ! [[ "$disk_size" =~ ^[0-9]+$ ]]; then
        echo -e "\e[38;2;191;97;106mError:\e[0m Disk size must be a number (in GB)."
        exit 1
      fi

      if [ ! -d "$dest" ]; then
        echo -e "\e[38;2;219;245;76mDirectory does not exist, creating:\e[0m $dest"
        mkdir -p "$dest" || { echo -e "\e[38;2;191;97;106mError:\e[0m Failed to create directory $dest"; exit 1; }
      fi

      echo -e "\e[38;2;136;192;208mBuilding bhairavi qcow2 image (${disk_size}GB)...\e[0m"
      echo -e "\e[38;2;133;133;133mThis may take several minutes...\e[0m"
      
      cd "$dots" || { echo -e "\e[38;2;191;97;106mError:\e[0m Cannot enter $dots"; exit 1; }
      
      # Build qcow2 image using nixos-generators via flake
      local build_result
      build_result=$(nix build ".#nixosConfigurations.bhairavi.config.system.build.images.qcow" \
        --no-link --print-out-paths 2>&1)

      local build_status=$?
      
      if [ $build_status -ne 0 ]; then
        echo -e "\e[38;2;191;97;106mError:\e[0m qcow2 build failed:"
        echo "$build_result"
        exit 1
      fi

      # Find the qcow2 file
      local qcow_path
      qcow_path=$(find "$build_result" -name "*.qcow2" -type f 2>/dev/null | head -n 1)

      if [ -z "$qcow_path" ]; then
        # Try listing directly
        qcow_path=$(ls "$build_result"/*.qcow2 2>/dev/null | head -n 1)
      fi

      if [ -z "$qcow_path" ]; then
        echo -e "\e[38;2;191;97;106mError:\e[0m No .qcow2 file found in build output"
        echo -e "\e[38;2;133;133;133mBuild directory: $build_result\e[0m"
        ls -la "$build_result" 2>/dev/null || true
        exit 1
      fi

      local qcow_name="bhairavi-${disk_size}G.qcow2"
      local final_path="$dest/$qcow_name"
      
      echo -e "\e[38;2;134;239;172mBuild complete, copying to destination\e[0m"
      cp "$qcow_path" "$final_path" || { 
        echo -e "\e[38;2;191;97;106mError:\e[0m Failed to copy qcow2 to destination"; 
        exit 1; 
      }

      # Resize if needed
      echo -e "\e[38;2;136;192;208mResizing image to ${disk_size}GB...\e[0m"
      if command -v qemu-img &> /dev/null; then
        qemu-img resize "$final_path" "${disk_size}G" 2>/dev/null || {
          echo -e "\e[38;2;219;245;76mWarning:\e[0m Could not resize image. Image may have fixed size."
        }
      else
        echo -e "\e[38;2;219;245;76mNote:\e[0m qemu-img not found, skipping resize"
      fi
      
      local qcow_size
      qcow_size=$(du -h "$final_path" | cut -f1)
      
      echo -e ""
      echo -e "\e[38;2;134;239;172m╔══════════════════════════════════════════════════════════╗\e[0m"
      echo -e "\e[38;2;134;239;172m║                    Build Complete!                      ║\e[0m"
      echo -e "\e[38;2;134;239;172m╚══════════════════════════════════════════════════════════╝\e[0m"
      echo -e ""
      echo -e "  \e[38;2;136;192;208mImage:\e[0m $final_path"
      echo -e "  \e[38;2;136;192;208mSize:\e[0m  $qcow_size on disk (${disk_size}GB virtual)"
      echo -e ""
      echo -e "  \e[38;2;219;245;76mRun with:\e[0m"
      echo -e "    qemu-system-x86_64 -m 8G -smp 4 \\\\"
      echo -e "      -drive file=$final_path,format=qcow2 \\\\"
      echo -e "      -enable-kvm"
    }

    case "$1" in
    sync)
      sync "$@"
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
    build-qcow)
      build-qcow "$@"
      ;;
    help)
      help
      ;;
    *)
      help
      ;;
    esac
  ''
